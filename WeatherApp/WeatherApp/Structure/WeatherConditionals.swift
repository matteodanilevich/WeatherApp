//
//  WeatherConditionals.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/9/22.
//

import Foundation
import RealmSwift

class WeatherConditional: Object {
    
    @objc dynamic var snow: Bool = true
    @objc dynamic var thunder: Bool = true
    @objc dynamic var rain: Bool = true
}
