//
//  ViewController.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 6/20/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //Задание адреса сервера
        if let serverURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?id=625144&appid=06c5fe9775b87218fa105e081e316374&units=metric&lang=en") {
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
}
