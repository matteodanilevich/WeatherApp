//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import UIKit
import CoreLocation
import Alamofire
import RealmSwift

class ForecastViewController: UIViewController {

    @IBOutlet weak var tableViewForWeatherData: UITableView!
    @IBOutlet weak var blurVisualEffect: UIVisualEffectView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var gpsButton: UIButton!

    var nameOfCity: String!

    var currentTemperature: Double!
    var currentForecast: String!
    private var currentForecastImage: UIImage!

    lazy var coreManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()

    var arrayForHourlyDt: [String] = []
    var arrayForHourlyBadWeatherDt: [Int] = []
    var arrayForhHourlyBadWeatherId: [Int] = []
    var arrayForHourlyTemp: [Double] = []
    var arrayForHourlyForecastImage: [UIImage] = []

    var arrayForDailyDt: [String] = []
    var arrayForDailyForecastImage: [UIImage] = []
    var arrayForDailyMinTemp: [Double] = []
    var arrayForDailyMaxTemp: [Double] = []

    var currentLocationCoordinate: CLLocationCoordinate2D!
    var currentLocationName: String!
    var newCityName: UITextField!

    var nofiticationToken: NotificationToken?

    var userDefaults = UserDefaults()

    var selectionModes: TypeMode = .none {
        didSet {
            gpsButton.isSelected = selectionModes == .navigation
            if gpsButton.isSelected {
                gpsButton.tintColor = .cyan
                UserDefaults.standard.set(true, forKey: "isNavigation")
            } else {
                gpsButton.tintColor = .blue
            }
            locationButton.isSelected = selectionModes == .citySelect
            if locationButton.isSelected {
                locationButton.tintColor = .cyan
                UserDefaults.standard.set(false, forKey: "isNavigation")
            } else {
                locationButton.tintColor = .blue
            }
        }
    }

    let userNotificationCenter = UNUserNotificationCenter.current()

    private var apiProvider: APIProviderProtocol!
    private var realmProvider: RealmProviderProtocol!


    override func viewDidLoad() {
        super.viewDidLoad()

        apiProvider = AlamofireProvider()
        realmProvider = RealmProvider()

        //MARK: Settings
        let settingsList = realmProvider.getResultForDataBase(objectName: RealmSettings.self).last
        let systemList = settingsList?.systemType ?? false
        let dataFormat = settingsList?.formatData ?? false

        //MARK: Weather conditionals
        let weatherConditionals = realmProvider.getResultForDataBase(objectName: WeatherConditional.self).last
        let rain = weatherConditionals?.rain ?? false
        let thunder = weatherConditionals?.thunderStorm ?? false
        let snow = weatherConditionals?.snow ?? false

        realmProvider.weatherConditionalUpdate(snow: snow, thunder: thunder, rain: rain)
        realmProvider.addSettingsProperties(systemType: systemList, formatData: dataFormat)

        guard let settingsList = realmProvider.getResultForDataBase(objectName: RealmSettings.self).last else { return }

        nofiticationToken = settingsList.observe ({ change in

            switch change {

            case .change:
                self.getCoordinatesByName()
                self.tableViewForWeatherData.reloadData()
            case .error(let error):
                print("\(error)")
            case .deleted:
                print("Object was deleted")
            }
        })

        coreManager.delegate = self
        blurVisualEffect.isHidden = false
        loadIndicator.startAnimating()

        //MARK: City name
        nameOfCity = "Minsk"
        if Locale.autoupdatingCurrent.languageCode == "ru" {
            nameOfCity = "Минск"
        }

        blurVisualEffect.isHidden = false
        loadIndicator.startAnimating()

        tableViewForWeatherData.delegate = self
        tableViewForWeatherData.dataSource = self

        //Hide separator in tableView
        tableViewForWeatherData.separatorStyle = .none

        tableViewForWeatherData.register(UINib(nibName: "CurrentWeatherCell", bundle: nil), forCellReuseIdentifier: CurrentWeatherCell.key)
        tableViewForWeatherData.register(UINib(nibName: "HourlyWeatherCell", bundle: nil), forCellReuseIdentifier: HourlyWeatherCell.key)
        tableViewForWeatherData.register(UINib(nibName: "DailyWeatherCell", bundle: nil), forCellReuseIdentifier: DailyWeatherCell.key)

        userNotificationCenter.removeAllPendingNotificationRequests()

        //Call function
        if !userDefaults.bool(forKey: "isAppAlreadyLaunchedOnce") || !userDefaults.bool(forKey: "isNone") {
            UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
            getCoordinatesByName()
        } else if userDefaults.bool(forKey: "isNavigation") {
            selectionModes = .navigation
        } else {
            selectionModes = .citySelect
            nameOfCity = userDefaults.string(forKey: "city")
            getCoordinatesByName()
        }
    }

    @IBAction func locationButtonClicked(_ sender: Any) {

        UserDefaults.standard.set(true, forKey: "isNone")
        selectionModes = .citySelect

        let cityAlert = UIAlertController(title: NSLocalizedString("Enter the name of the city", comment: ""), message: nil, preferredStyle: .alert)
        cityAlert.addTextField { textField in

            textField.delegate = self
            textField.placeholder = NSLocalizedString("Enter name", comment: "")
            self.newCityName = textField
        }

        let okeyButton = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default) { [weak self] _ in

            guard let self = self else { return }
            guard let newCityName = self.newCityName.text else { return }

            UserDefaults.standard.set(newCityName, forKey: "city")

            self.nameOfCity = newCityName

            self.blurVisualEffect.isHidden = false
            self.loadIndicator.startAnimating()

            self.getCoordinatesByName()
        }

        let cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive)

        cityAlert.addAction(okeyButton)
        cityAlert.addAction(cancelButton)

        present(cityAlert, animated: true)
    }

    @IBAction func gpsButtonClicked(_ sender: Any) {

        coreManager.requestWhenInUseAuthorization()
        UserDefaults.standard.set(true, forKey: "isNone")
        selectionModes = .navigation
        getWeatherDataByLocation()
    }

    private func getCoordinatesByName() {

        guard let nameOfCity = nameOfCity else { return }

        var lang = "en"
        if let preferredLanguage = Locale.autoupdatingCurrent.languageCode, preferredLanguage == "ru" {
            lang = preferredLanguage
        }

        apiProvider.getCoordinatesByName(name: nameOfCity) { [weak self] resultData in

            guard let self = self else { return }

            switch resultData {

            case .success(let cityValue):
                if let city = cityValue.first, let localCityName = city.localNames[lang] {

                    self.nameOfCity = localCityName
                    self.getWeatherForCityByCoordinates(cityLat: city.lat, cityLon: city.lon)
                } else {
                    self.blurVisualEffect.isHidden = true
                    self.loadIndicator.stopAnimating()
                    let alertController = UIAlertController(title: NSLocalizedString("Place not found", comment: ""), message: nil, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel) { _ in }
                    alertController.addAction(okButton)
                    self.present(alertController, animated: true)
                }
            case .failure(let errorMessage):
                print(errorMessage.localizedDescription)
            }
        }
    }

    private func getWeatherForCityByCoordinates(cityLat: Double, cityLon: Double) {

        apiProvider.getWeatherForCityByCoordinates(lat: cityLat, lon: cityLon) { [weak self] resultData in

            guard let self = self else { return }

            self.blurVisualEffect.isHidden = true
            self.loadIndicator.stopAnimating()

            switch resultData {

            case .success(let value):
                guard let actualData = value.current, let lat = value.lat, let lon = value.lon, let weather = actualData.weather, let temperature = actualData.temp, let cloudsState = weather.first?.description else { return }

                self.currentTemperature = temperature
                self.currentForecast = cloudsState

                let currentDate = Int(Date().timeIntervalSince1970)

                self.realmProvider.addCurrentForecastToQueryList(time: currentDate, forecast: cloudsState, temp: temperature, isCurrentWeather: true)
                self.realmProvider.addCoordinatesToQueryList(time: currentDate, lat: lat, lon: lon)

                //MARK: Hourly weather
                guard let hourlyData = value.hourly else { return }

                let thunderstorm = 200...299
                let rain = 500...599
                let snow = 600...699

                self.arrayForHourlyDt.removeAll()
                self.arrayForHourlyTemp.removeAll()
                self.arrayForHourlyForecastImage.removeAll()
                self.arrayForhHourlyBadWeatherId.removeAll()

                for info in hourlyData {

                    guard let hourlyDt = info.dt, let hourlyTemp = info.temp, let weather = info.weather, let weatherId = weather.first?.id, let weatherIcon = weather.first?.icon else { return }

                    //Picture receiving
                    if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png") {

                        do {

                            let imageData = try Data(contentsOf: iconURL)
                            if let uiImage = UIImage(data: imageData) {
                                self.arrayForHourlyForecastImage.append(uiImage)
                            }
                        }
                        catch {
                            print("Error")
                        }
                    }

                    let settingsList = self.realmProvider.getResultForDataBase(objectName: RealmSettings.self).last
                    let dataFormating = settingsList?.formatData ?? false

                    //Add data to array
                    self.arrayForHourlyDt.append(hourlyDt.convertDataTime(formattedDataType: dataFormating ? .secondHour : .hour))
                    self.arrayForHourlyTemp.append(hourlyTemp)

                    //Data for notification
                    //Затычка
                    if thunderstorm.contains(weatherId) || rain.contains(weatherId) || snow.contains(weatherId) {

                        self.arrayForHourlyBadWeatherDt.append(hourlyDt - 60 * 30)
                    }
                    //MARK: Проскакивает проверку
//                    guard let conditional = self.realmProvider.getResultForDataBase(objectName: WeatherConditional.self).last else { return }
//
//                    if conditional.thunderStorm && thunderstorm.contains(weatherId) {
//                        self.arrayForHourlyBadWeatherDt.append(hourlyDt - 60 * 30)
//                    }
//
//                    if conditional.rain && rain.contains(weatherId) {
//                        self.arrayForHourlyBadWeatherDt.append(hourlyDt - 60 * 30)
//                    }
//
//                    if conditional.snow && snow.contains(weatherId) {
//                        self.arrayForHourlyBadWeatherDt.append(hourlyDt - 60 * 30)
//                    }
                }

                self.sendWeatherNotifications(arrayTime: self.arrayForHourlyBadWeatherDt)

                //MARK: Daily Weather
                guard let dailyData = value.daily else { return }

                self.arrayForDailyDt.removeAll()
                self.arrayForDailyForecastImage.removeAll()
                self.arrayForDailyMinTemp.removeAll()
                self.arrayForDailyMaxTemp.removeAll()

                for info in dailyData {

                    guard let dailyDt = info.dt, let dailyTemp = info.temp, let weather = info.weather, let weatherIcon = weather.first?.icon, let minTemperature = dailyTemp.min, let maxTemperature = dailyTemp.max else { return }

                    //Picture receiving
                    if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png") {

                        do {

                            let imageData = try Data(contentsOf: iconURL)
                            if let uiImage = UIImage(data: imageData) {
                                self.arrayForDailyForecastImage.append(uiImage)
                            }
                        }
                        catch {
                            print("Error")
                        }
                    }

                    self.arrayForDailyMinTemp.append(minTemperature)
                    self.arrayForDailyMaxTemp.append(maxTemperature)
                    self.arrayForDailyDt.append(dailyDt.convertDataTime(formattedDataType: .day))
                }

                //Update Data in tableView
                self.tableViewForWeatherData.reloadData()

            case .failure(let errorMessage):
                print(errorMessage)
            }
        }
    }

    func getWeatherDataByLocation() {

        guard currentLocationCoordinate != nil else { return }

        self.blurVisualEffect.isHidden = false
        self.loadIndicator.startAnimating()

        self.nameOfCity = currentLocationName
        self.getWeatherForCityByCoordinates(cityLat: Double(currentLocationCoordinate.latitude), cityLon: Double(currentLocationCoordinate.longitude))
    }

    private func sendWeatherNotifications(arrayTime: [Int]) {

        guard let time = arrayTime.first else { return }

        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = NSLocalizedString("Bad weather is coming", comment: "")

        var data = DateComponents()

        data.minute = Int(time.convertDataTime(formattedDataType: .minute))
        data.hour = Int(time.convertDataTime(formattedDataType: .hour))

        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: data, repeats: false)
        let indentifier = String(time)
        let request = UNNotificationRequest(identifier: indentifier, content: notificationContent, trigger: calendarTrigger)

        //Add notification
        self.userNotificationCenter.add(request) { error in
            if let error = error {
                print (error)
            }
        }
    }
}
