//
//  Forecast.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 6/20/22.
//

import Foundation

// MARK: - ForecastData
//Использование протокола Codable, позволяющего конвертировать данные в/из JSON
struct ForecastData: Codable {
    
    var lat: Double?
    var lon: Double?
    var timeZone: String?
    var timeZoneOffset: Int?
    var current: CurrentForecastData?
    var hourly: [HourlyForecastData]?
    var daily: [DailyForecastData]?

    //Постановка соответствий ключей JSON и свойств структуры
    enum CodingKeys: String, CodingKey {
        
        case timeZone = "timezone"
        case timeZoneOffset = "timezone_offset"
        case lat, lon, current
        case hourly, daily
    }
}

// MARK: - CurrentForecastData
struct CurrentForecastData: Codable {
    
    var dt: Int?
    var sunrise: Int?
    var sunset: Int?
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
    var weather: [Forecast]?
    
    enum CodingKeys: String, CodingKey {
        
        case feelsLike = "feels_like"
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case dt, sunrise, sunset, temp, pressure, humidity, uvi, clouds, visibility, weather
    }
}

// MARK: - Forecast
struct Forecast: Codable {
    
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}
