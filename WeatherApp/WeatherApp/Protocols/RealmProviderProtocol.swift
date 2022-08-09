//
//  RealmProviderProtocol.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import Foundation
import RealmSwift

protocol RealmProviderProtocol {
    
    func writeDataToDataBase(name: Object)
    func getResultForDataBase<T: RealmFetchable>(objectName: T.Type) -> Results<T>
    func addCoordinatesToQueryList(time: Int, lat: Double, lon: Double)
    func addCurrentForecastToQueryList(time: Int, forecast: String, temp: Double, isCurrentWeather: Bool)
    func addSettingsProperties(systemType: Bool, formatData: Bool)
    func addWeatherConditional(snow: Bool, thunder: Bool, rain: Bool)
    func formatUpdate(formatedData: Bool)
    func systemUpdate(formatedData: Bool)
    func weatherConditionalUpdate(snow: Bool, thunder: Bool, rain: Bool)
}
