//
//  RealmProvider.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/7/22.
//

import Foundation
import RealmSwift

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

    func addCurrentForecastToQueryList(time: Int, forecast: String, temp: Double) {
        
        let ourRequest = CurrentForecastForRealm()
        
        ourRequest.time = time
        ourRequest.forecastDescription = forecast
        ourRequest.temp = temp
        writeDataToDataBase(name: ourRequest)
    }
}
