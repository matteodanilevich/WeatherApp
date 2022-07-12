//
//  ForecastViewController+Extension.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/7/22.
//

import Foundation
import UIKit

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let keyValue = ContentType(rawValue: section)

        switch keyValue {

        case .daily:
            return arrayForDailyDt.count
        default:
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {

        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let keyValue = ContentType(rawValue: indexPath.section)

        switch keyValue {

        case .current:
            
            if let tableCell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherCell.key) as? CurrentWeatherCell {

                guard let cityName = nameOfCity, let temp = currentTemperature, let forecast = currentForecast, let minTemp = arrayForDailyMinTemp.min(), let maxTemp = arrayForDailyMaxTemp.max() else { return tableCell }

                tableCell.cityName.text = cityName
                tableCell.currentTemperature.text = "Now: \(temp)°C"
                tableCell.currentSky.text = forecast
                tableCell.currentTemperatureExtremum.text = "Min: \(minTemp)°C, Max: \(maxTemp)°C"
                
                return tableCell
            }

        case .hourly:

            if let tableCell = tableView.dequeueReusableCell(withIdentifier: "HourlyWeatherCell", for: indexPath) as? HourlyWeatherCell {
                
                tableCell.dtArray = arrayForHourlyDt
                tableCell.imageArray = arrayForHourlyForecastImage
                tableCell.temperatureArray = arrayForHourlyTemp
                tableCell.collectionWeatherCell.reloadData()
                
                return tableCell
            }

        default:
            
            if let tableCell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherCell.key) as? DailyWeatherCell {
                
                tableCell.currentDate.text = "\(arrayForDailyDt[indexPath.row])"
                tableCell.weatherIcon.image = arrayForDailyForecastImage[indexPath.row]
                tableCell.minTemperature.text = "Min: \(arrayForDailyMinTemp[indexPath.row])°C"
                tableCell.maxTemperature.text = "Max: \(arrayForDailyMaxTemp[indexPath.row])°C"
                
                return tableCell
            }
        }
        
        return UITableViewCell()
    }
}
