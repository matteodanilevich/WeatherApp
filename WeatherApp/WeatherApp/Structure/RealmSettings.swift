//
//  RealmSettings.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/9/22.
//

import Foundation
import RealmSwift

class RealmSettings: Object {
    
    @objc dynamic var formatData: Bool = true
    @objc dynamic var systemType: Bool = true
    @objc dynamic var weatherConditional: WeatherConditional?
}
