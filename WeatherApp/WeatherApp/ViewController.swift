//
//  ViewController.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 6/20/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureInfo: UILabel!
    @IBOutlet weak var feelsLikeInfo: UILabel!
    @IBOutlet weak var pressureInfo: UILabel!
    @IBOutlet weak var cloudsInfo: UILabel!
    @IBOutlet weak var windSpeedInfo: UILabel!
    @IBOutlet weak var sunriseInfo: UILabel!
    @IBOutlet weak var sunsetInfo: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //Call function for receive data
        dataReceiving("Minsk", .metric)
    }

    func dataReceiving(_ cityName: String, _ measureUnits: MeasureUnits) {

        //Задание адреса сервера
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String, let cityURL = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=2&appid=\(apiKey)") {
            //Создание urlRequest(запрос на сервер)
            var requestURL = URLRequest(url: cityURL)
            //Задаём тип нашего запроса
            requestURL.httpMethod = "GET"
            //Добавляем в заголовок тип нашего контента
            requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")

            //MARK: Создание таски(task) для непосредственно запроса на сервер
            let cityTask = URLSession.shared.dataTask(with: requestURL) { data, responce, error in

                if let responce = responce {
                    print(responce)
                }
                if let data = data {

                    let cityInfo = try! JSONDecoder().decode([CityInfo].self, from: data)
                    //MARK: Получение данных о погоде
                    guard cityInfo.isEmpty == false else { return }
                    //Координаты города
                    if let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(cityInfo[0].lat)&lon=\(cityInfo[0].lon)&exclude=minutely,alerts&appid=\(apiKey)&units=\(measureUnits)&lang=en") {

                        var weatherRequestURL = URLRequest(url: weatherURL)
                        weatherRequestURL.httpMethod = "GET"

                        let weatherTask = URLSession.shared.dataTask(with: weatherRequestURL) { data, responce, error in

                            if let responce = responce {
                                print(responce)
                            }

                            if let data = data {
                                let currentWeather = try! JSONDecoder().decode(Forecast.self, from: data)

                                //MARK: Присваивание(передача) значений(данных) нашим label на UI
                                DispatchQueue.main.async { [weak self] in

                                    guard let self = self else { return }

                                    self.temperatureInfo.text = "\(currentWeather.current.temp)"
                                    self.feelsLikeInfo.text = "\(currentWeather.current.feelsLike)"
                                    self.pressureInfo.text = "\(currentWeather.current.pressure)"
                                    self.cloudsInfo.text = "\(currentWeather.current.clouds)"
                                    self.windSpeedInfo.text = "\(currentWeather.current.windSpeed)"
                                    self.sunsetInfo.text = "\(currentWeather.current.sunset ?? 0)"
                                    self.sunriseInfo.text = "\(currentWeather.current.sunrise ?? 0)"

                                    guard currentWeather.current.weather.isEmpty == false else {
                                        return
                                    }
                                    // Присваивание значения нашей иконки с погодой
                                    let weatherIcon = currentWeather.current.weather[0].icon
                                    // добавляем иконку по URL
                                    if let url = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png") {
                                        do {
                                            let data = try Data(contentsOf: url)
                                            self.weatherImage.image = UIImage(data: data)
                                        } catch _ {
                                            print("error")
                                        }
                                    }
                                }
                            }
                            if let error = error {
                                print(error)
                            }
                        }
                        weatherTask.resume()
                    }
                }
                if let error = error {
                    print(error)
                }
            }

            //MARK: Запуск запроса на выполнение
            print("Requesting..")
            cityTask.resume()
        }
    }
}
