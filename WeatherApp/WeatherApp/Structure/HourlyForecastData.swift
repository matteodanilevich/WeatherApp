//
//  HourlyWeatherData.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/5/22.
//

import Foundation

// MARK: - HourlyForecastData
struct HourlyForecastData: Codable {
    
    var dt: Int?
    var temp: Double?
    var feelsLike: Double?
    var pressure: Int?
    var humidity: Int?
    var dewPoint: Double?
    var uvi: Double?
    var clouds: Int?
    var visibility: Int?
    var windSpeed: Double?
    var windDeg: Int?
    var windGust: Double?
    var weather: [HourlyForecast]?
    var pop: Double?
    
    enum CodingKeys: String, CodingKey {
        
        case feelsLike = "feels_like"
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case dt, temp, pressure, humidity, uvi, clouds, visibility, weather, pop
    }
}

// MARK: - HourlyForecast
struct HourlyForecast: Codable {
    
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}
