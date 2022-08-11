//
//  CityInfo.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 6/27/22.
//

import Foundation

// MARK: Information about city
struct CityInfo: Codable {

    let name: String
    let localNames: [String: String]
    let lat, lon: Double
    let country, state: String?

    enum CodingKeys: String, CodingKey {

        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}
