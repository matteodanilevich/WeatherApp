//
//  Constants.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import Foundation

struct Constants {

    static var baseURL = "https://api.openweathermap.org/"
    
    static var getCodingURL: String {
        return baseURL.appending("geo/1.0/direct")
    }
    
    static var weatherURL: String {
        return baseURL.appending("data/2.5/onecall")
    }
}
