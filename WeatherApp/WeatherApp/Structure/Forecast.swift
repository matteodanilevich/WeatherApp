//
//  Forecast.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 6/20/22.
//

import Foundation

// MARK: Forecast
//Использование протокола Codable, позволяющего конвертировать данные в/из JSON
struct Forecast: Codable {
    var coord: Coord?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone, id: Int?
    var name: String?
    var cod: Int?
}

// MARK: Clouds
struct Clouds: Codable {
    var all: Int?
}

// MARK: Coord
struct Coord: Codable {
    var lon, lat: Double?
}

// MARK: Main
struct Main: Codable {
    var temp, feelsLike, tempMin, tempMax: Double?
    var pressure, humidity, seaLevel, grndLevel: Int?

    //Постановка соответствий ключей JSON и свойств структуры
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: Sys
struct Sys: Codable {
    var type, id: Int?
    var country: String?
    var sunrise, sunset: Int?
}

// MARK: Weather
struct Weather: Codable {
    var id: Int?
    var main, weatherDescription, icon: String?

    //Постановка соответствий ключей JSON и свойств структуры
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: Wind
struct Wind: Codable {
    var speed: Double?
    var deg: Int?
    var gust: Double?
}
