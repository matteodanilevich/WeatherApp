//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    private var apiProvider: APIProviderProtocol!
    private var realmProvider: RealmProviderProtocol!

    override func viewDidLoad() {

        super.viewDidLoad()

        apiProvider = AlamofireProvider()
        realmProvider = RealmProvider()

        let camera = GMSCameraPosition.camera(withLatitude: 53.9024716, longitude: 27.5618225, zoom: 10)
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = self
        view = mapView
    }
    
    func getForecastByCoordinates(coord: CLLocationCoordinate2D) {
        
        apiProvider.getWeatherForCityByCoordinates(lat: coord.latitude, lon: coord.longitude) { [weak self] result in
            
            guard let self = self else {return}
            
            switch result {
            case .success(let value):
                
                guard let current = value.current, let temp = current.temp, let lat = value.lat, let lon = value.lon, let weather = current.weather, let weatherDescription = weather.first?.description else {return}
                let dateTime = Int(Date().timeIntervalSince1970)
                self.realmProvider.addCurrentForecastToQueryList(time: dateTime, forecast: weatherDescription, temp: temp)
                self.realmProvider.addCoordinatesToQueryList(time: dateTime, lat: lat, lon: lon)
                let alert = UIAlertController(title: "Temperature:", message: "\(temp.description) °C", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Okey", style: .cancel)
                alert.addAction(okButton)
                self.present(alert, animated: true)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
