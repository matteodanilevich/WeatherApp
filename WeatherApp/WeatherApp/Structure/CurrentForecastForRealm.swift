//
//  CurrentForecastForRealm.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import Foundation
import RealmSwift

class CurrentForecastForRealm: Object {
    
    @objc dynamic var time: Int = 0
    @objc dynamic var forecastDescription: String = ""
    @objc dynamic var temp: Double = 0.0
}
