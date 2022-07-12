//
//  AlamofireProvider.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/7/22.
//

import Foundation
import Alamofire

class AlamofireProvider: APIProviderProtocol {
    
    var keyForAPI: String? {
        
        get {
            Bundle.main.infoDictionary?["API_KEY"] as? String
        }
    }
    
    func getCoordinatesByName(name: String, completion: @escaping (Result<[CityInfo], Error>) -> Void) {
        
        let params = addParams(dataForQuery: ["q": name])
        
        AF.request(Constants.getCodingURL, method: .get, parameters: params).responseDecodable(of: [CityInfo].self) { response in
            
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWeatherForCityByCoordinates(lat: Double, lon: Double, completion: @escaping (Result<ForecastData, Error>) -> Void) {
        
        let params = addParams(dataForQuery: ["lat": lat.description, "lon": lon.description, "exlcude":"minutely,alerts", "units" : "metric"])
        
        AF.request(Constants.weatherURL, method: .get, parameters: params).responseDecodable(of: ForecastData.self){ response in
            
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addParams(dataForQuery: [String: String]) -> [String: String] {
        
        var params: [String: String] = [:]
        
        params = dataForQuery
        
        if let key = keyForAPI  {
            
            params["appid"] = "\(key)"
            return params
        }
        return params
    }
}
