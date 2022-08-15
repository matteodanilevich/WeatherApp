//
//  ContentType.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/10/22.
//

import Foundation


enum ContentType: Int {

    case current = 0
    case hourly
    case daily

    var description: String {
        switch self {
        case .current:
            return "Current weather"
        case .hourly:
            return "Hourly weather"
        case .daily:
            return "Daily weather"
        }
    }
}
