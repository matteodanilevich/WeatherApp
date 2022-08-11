//
//  APIProviderProtocol.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import Foundation

protocol APIProviderProtocol {

    func getCoordinatesByName(name: String, completion: @escaping (Result<[CityInfo], Error>) -> Void)
    func getWeatherForCityByCoordinates(lat: Double, lon: Double, completion: @escaping (Result<ForecastData, Error>) -> Void)
    func addParams(dataForQuery: [String: String]) -> [String: String]
}
