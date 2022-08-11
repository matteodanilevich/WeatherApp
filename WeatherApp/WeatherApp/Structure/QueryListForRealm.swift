//
//  QueryListForRealm.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import Foundation
import RealmSwift

class QueryListForRealm: Object {

    @objc dynamic var time: Int = 0
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var currentForecast: CurrentForecastForRealm?
}
