//
//  ViewController.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 6/20/22.
//

import UIKit

class ViewController: UIViewController {

    //CityId
    var cityId = 625144
    //Units
    var measureUnits = MeasureUnits.metric
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //Call function for receive data
       dataReceiving(cityId, measureUnits)
    }
}

func dataReceiving(_ cityId: Int, _ measureUnits: MeasureUnits) {
    
    //Задание адреса сервера
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String, let serverURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?id=\(cityId)&appid=\(apiKey)&units=\(measureUnits)&lang=en") {
        //Создание urlRequest(запрос на сервер)
        var requestURL = URLRequest(url: serverURL)
        //Задаём тип нашего запроса
        requestURL.httpMethod = "GET"
        //Добавляем в заголовок тип нашего контента
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")

        //MARK: Создание таски(task) для непосредственно запроса на сервер
        let forecastTask = URLSession.shared.dataTask(with: requestURL) { data, responce, error in

            //Получение данных
            print("Completed")

            if let data = data {
                let forecast = try! JSONDecoder().decode(Forecast.self, from: data)
                print(forecast)
            }

            if let responce = responce {
                print(responce)
            }

            if let error = error {
                print(error)
            }
        }

        //MARK: Запуск запроса на выполнение
        print("Requesting..")
        forecastTask.resume()
    }
}
