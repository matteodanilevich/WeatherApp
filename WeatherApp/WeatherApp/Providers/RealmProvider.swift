//
//  RealmProvider.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/7/22.
//

import Foundation
import RealmSwift
import UIKit

class RealmProvider: RealmProviderProtocol {
    
    private let realm = try! Realm()

    func writeDataToDataBase(name: Object) {

        try! realm.write {
            realm.add(name)
        }
    }

    func getResultForDataBase<T: RealmFetchable>(objectName: T.Type) -> Results<T> {

        realm.objects(objectName.self)
    }

    func addCoordinatesToQueryList(time: Int, lat: Double, lon: Double) {

        let ourRequest = QueryListForRealm()

        ourRequest.time = time
        ourRequest.latitude = lat
        ourRequest.longitude = lon
        ourRequest.currentForecast = getResultForDataBase(objectName: CurrentForecastForRealm.self).last

        writeDataToDataBase(name: ourRequest)
    }

    func addCurrentForecastToQueryList(time: Int, forecast: String, temp: Double, isCurrentWeather: Bool) {

        let ourRequest = CurrentForecastForRealm()

        ourRequest.time = time
        ourRequest.forecastDescription = forecast
        ourRequest.temp = temp
        ourRequest.isCurrentWeather = isCurrentWeather

        writeDataToDataBase(name: ourRequest)
    }

    func addSettingsProperties(systemType: Bool, formatData: Bool) {

        let systemSettings = RealmSettings()

        systemSettings.systemType = systemType
        systemSettings.formatData = formatData
        systemSettings.weatherConditional = getResultForDataBase(objectName: WeatherConditional.self).last

        writeDataToDataBase(name: systemSettings)
    }

    func addWeatherConditional(snow: Bool, thunder: Bool, rain: Bool) {

        let weatherRequest = WeatherConditional()

        weatherRequest.snow = snow
        weatherRequest.thunderStorm = thunder
        weatherRequest.rain = rain

        writeDataToDataBase(name: weatherRequest)
    }

    func formatUpdate(formatedData: Bool) {
        try! realm.write {
            guard let settingProperties = getResultForDataBase(objectName: RealmSettings.self).last else { return }

            settingProperties.formatData = formatedData
        }
    }

    func systemUpdate(formatedData: Bool) {

        try! realm.write {
            guard let settingProperties = getResultForDataBase(objectName: RealmSettings.self).last else { return }

            settingProperties.systemType = formatedData
        }
    }

    func weatherConditionalUpdate(snow: Bool, thunder: Bool, rain: Bool) {

        try! realm.write {
            guard let settingProperties = getResultForDataBase(objectName: RealmSettings.self).last, let weatherConditional = settingProperties.weatherConditional else { return }

            weatherConditional.snow = snow
            weatherConditional.thunderStorm = thunder
            weatherConditional.rain = rain
        }
    }
}
