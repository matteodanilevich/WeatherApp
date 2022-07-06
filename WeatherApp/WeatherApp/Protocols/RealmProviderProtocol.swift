//
//  RealmProviderProtocol.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import Foundation
import RealmSwift

protocol RealmProviderProtocol {
    
    func writeDataToDatabase(name: Object) -> Void
    func getResultFromDataBase<T: RealmFetchable>(nameObject: T.Type) -> Results<T>
    func addCoordinatesToQueryList(time: Int, lat: Double, lon: Double)
    func addCurrentWeatherToQueryList(time: Int, weather: String, temp: Double)
}
