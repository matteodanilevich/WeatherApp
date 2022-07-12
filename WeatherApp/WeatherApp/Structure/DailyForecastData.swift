//
//  DailyForecastData.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/5/22.
//

import Foundation

// MARK: - DailyForecastData
struct DailyForecastData: Codable {
    
    var dt: Int?
    var sunrise: Int?
    var sunset: Int?
    var moonrise: Int?
    var moonset: Int?
    var moonPhase: Double?
    var temp: Temp?
    var feelsLike: FeelsLike?
    var pressure: Int?
    var humidity: Int?
    var dewPoint: Double?
    var windSpeed: Double?
    var windDeg: Int?
    var windGust: Double?
    var weather: [DailyForecast]?
    var clouds: Int?
    var pop: Double?
    var rain: Double?
    var uvi: Double?
    
    enum CodingKeys: String, CodingKey {
        
        case feelsLike = "feels_like"
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case moonPhase = "moon_phase"
        case dt, sunrise, sunset, moonrise, moonset, temp, pressure, humidity, weather, clouds, pop, rain, uvi
    }
}

// MARK: - Temp
struct Temp: Codable {
    
    var day: Double?
    var min: Double?
    var max: Double?
    var night: Double?
    var eve: Double?
    var morn: Double?
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    
    var day: Double?
    var night: Double?
    var eve: Double?
    var morn: Double?
}

// MARK: - DailyForecast
struct DailyForecast: Codable {
    
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}
