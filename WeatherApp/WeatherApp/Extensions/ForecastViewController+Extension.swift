//
//  ForecastViewController+Extension.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/7/22.
//

import Foundation
import UIKit
import CoreLocation

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
                tableCell.currentTemperature.text = "\(NSLocalizedString("Now", comment: "")): \(Int(temp))°"
                tableCell.currentSky.text = forecast
                tableCell.currentTemperatureExtremum.text = "\(NSLocalizedString("Min", comment: "")): \(Int(minTemp))°, \(NSLocalizedString("Max", comment: "")): \(Int(maxTemp))°"

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
                tableCell.minTemperature.text = "\(NSLocalizedString("Min", comment: "")): \(Int(arrayForDailyMinTemp[indexPath.row]))°"
                tableCell.maxTemperature.text = "\(NSLocalizedString("Max", comment: "")): \(Int(arrayForDailyMaxTemp[indexPath.row]))°"

                return tableCell
            }
        }
        return UITableViewCell()
    }
}

extension ForecastViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            coreManager.startUpdatingLocation()

        } else if manager.authorizationStatus == .restricted || manager.authorizationStatus == .denied {
            gpsButton.isEnabled = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let userLocation = locations.last! as CLLocation
        self.currentLocationCoordinate = userLocation.coordinate
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(userLocation) { [self] (placemarks, error) in

            if let error = error {
                print("Unable to reverse location: (\(error))")
            } else {

                if let placemarks = placemarks, let placemark = placemarks.first, let locality = placemark.locality {

                    self.currentLocationName = locality

                    if self.selectionModes == .navigation {
                        self.nameOfCity = self.currentLocationName
                    }
                }
            }
        }

        coreManager.stopUpdatingLocation()

        if selectionModes == .navigation {
            getWeatherDataByLocation()
        }
    }
}

extension ForecastViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: string)) || CharacterSet.whitespaces.isSuperset(of: CharacterSet(charactersIn: string)) || CharacterSet(charactersIn: "-").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
}
