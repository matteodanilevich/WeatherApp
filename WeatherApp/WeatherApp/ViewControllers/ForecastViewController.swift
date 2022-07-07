//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var tableViewForWeatherData: UITableView!
    @IBOutlet weak var blurVisualEffect: UIVisualEffectView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!

    var nameOfCity: String!

    var currentTemperature: Double!
    var currentForecast: String!
    var currentForecastImage: UIImage!

    var arrayForHourlyDt: [String] = []
    var arrayForHourlyBadWeatherDt: [Int] = []
    var arrayForhHourlyBadWeatherId: [Int] = []
    var arrayForHourlyTemp: [Double] = []
    var arrayForHourlyForecastImage: [UIImage] = []

    var arrayForDailyDt: [String] = []
    var arrayForDailyForecastImage: [UIImage] = []
    var arrayForDailyMinTemp: [Double] = []
    var arrayForDailyMaxTemp: [Double] = []

    enum ContentType: Int {

        case current = 0
        case hourly
        case daily
        var description: String {

            switch self {

            case .current:
                return "Current weather"
            case .hourly:
                return "Houly weather forecast"
            case .daily:
                return "Daily weather forecast"
            }
        }
    }

    let userNotificationCenter = UNUserNotificationCenter.current()

    private var apiProvider: APIProviderProtocol!
    private var realmProvider: RealmProviderProtocol!


    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: City name
        nameOfCity = "Minsk"

        apiProvider = AlamofireProvider()
        realmProvider = RealmProvider()

        blurVisualEffect.isHidden = false
        loadIndicator.startAnimating()
        userNotificationCenter.removeAllPendingNotificationRequests()

        tableViewForWeatherData.delegate = self
        tableViewForWeatherData.dataSource = self
        
        //Hide separator in tableView
        tableViewForWeatherData.separatorStyle = .none

        tableViewForWeatherData.register(UINib(nibName: "CurrentWeatherCell", bundle: nil), forCellReuseIdentifier: CurrentWeatherCell.key)
        tableViewForWeatherData.register(UINib(nibName: "HourlyWeatherCell", bundle: nil), forCellReuseIdentifier: HourlyWeatherCell.key)
        tableViewForWeatherData.register(UINib(nibName: "DailyWeatherCell", bundle: nil), forCellReuseIdentifier: DailyWeatherCell.key)

        //Call function
        getCoordinatesByName()
    }

    private func getCoordinatesByName() {
        
        guard let cityName = nameOfCity else { return }
        
        apiProvider.getCoordinatesByName(name: cityName) { [weak self] resultData in
            
            guard let self = self else { return }
            
            switch resultData {
                
            case .success(let cityValue):
                if let city = cityValue.first {
                    
                    self.getWeatherForCityByCoordinates(cityInfo: city)
                }
                
            case .failure(let errorMessage):
                print(errorMessage.localizedDescription)
            }
        }
    }
    
    private func getWeatherForCityByCoordinates(cityInfo: CityInfo) {
        
        apiProvider.getWeatherForCityByCoordinates(lat: cityInfo.lat, lon: cityInfo.lon) { [weak self] resultData in
            
            self?.blurVisualEffect.isHidden = true
            self?.loadIndicator.stopAnimating()
            
            guard let self = self else { return }
            
            switch resultData {
                
            case .success(let value):
                guard let actualData = value.current, let lat = value.lat, let lon = value.lon, let weather = actualData.weather, let temperature = actualData.temp, let cloudsState = weather.first?.description else { return }
                
                self.currentTemperature = temperature
                self.currentForecast = cloudsState
                
                let currentDate = Int(Date().timeIntervalSince1970)
                
                self.realmProvider.addCurrentForecastToQueryList(time: currentDate, forecast: cloudsState, temp: temperature)
                self.realmProvider.addCoordinatesToQueryList(time: currentDate, lat: lat, lon: lon)
                
                //MARK: Hourly weather
                guard let hourlyData = value.hourly else { return }
                
                let thunderstormCondition = 200...299
                let rainCondition = 500...599
                let snowCondition = 600...699
                
                for info in hourlyData {
                    
                    guard let hourlyDt = info.dt, let hourlyTemp = info.temp, let weatherId = weather.first?.id, let weather = info.weather, let weatherIcon = weather.first?.icon else { return }
                    
                    //Получение картинки
                    if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png") {
                        
                        do {
                            
                            let imageData = try Data(contentsOf: iconURL)
                            self.arrayForHourlyForecastImage.append(UIImage(data: imageData)!)
                        }
                        catch {
                            print("Error")
                        }
                    }
                    
                    //Add data to array
                    self.arrayForHourlyDt.append(hourlyDt.convertDataTime(.hour))
                    self.arrayForHourlyTemp.append(hourlyTemp)
                    self.arrayForhHourlyBadWeatherId.append(weatherId)
                    
                    //Data for notification
                    if thunderstormCondition.contains(weatherId) || rainCondition.contains(weatherId) || snowCondition.contains(weatherId) {
                        
                        self.arrayForHourlyBadWeatherDt.append(hourlyDt - 60 * 30)
                    }
                }
                
                self.sendWeatherNotifications(arrayTime: self.arrayForHourlyBadWeatherDt)
                
                //MARK: Daily Weather
                guard let dailyData = value.daily else { return }
                
                for info in dailyData {
                    
                    guard let dailyDt = info.dt, let dailyTemp = info.temp, let weather = info.weather, let weatherIcon = weather.first?.icon, let minTemperature = dailyTemp.min, let maxTemperature = dailyTemp.max else { return }
                    
                    //Получение картинки
                    if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png") {
                        
                        do {
                            
                            let imageData = try Data(contentsOf: iconURL)
                            self.arrayForDailyForecastImage.append(UIImage(data: imageData)!)
                        }
                        catch {
                            print("Error")
                        }
                    }
                    self.arrayForDailyDt.append(dailyDt.convertDataTime(.day))
                    self.arrayForDailyMinTemp.append(minTemperature)
                    self.arrayForDailyMaxTemp.append(maxTemperature)
                }
                
                //Update Data in tableView
                self.tableViewForWeatherData.reloadData()
                
            case .failure(let errorMessage):
                print(errorMessage)
            }
        }
    }
    
    private func sendWeatherNotifications(arrayTime: [Int]) {
        
        guard let time = arrayTime.first else {return}
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = "Bad weather is coming..."
        
        var date = DateComponents()
        
        date.minute = Int(time.convertDataTime(.minute))
        date.hour = Int(time.convertDataTime(.hour))
        
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
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
