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

    var mapZone: GMSMapView?
    
    var temperatureData: Int!
    var iconImage: UIImage!
    var windSpeed: Double!
    
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
                
                guard let current = value.current, let temp = current.temp, let lat = value.lat, let lon = value.lon, let weather = current.weather, let weatherDescription = weather.first?.description, let iconImage = weather.first?.icon, let windSpeed = current.windSpeed else { return }
                
                let dateTime = Int(Date().timeIntervalSince1970)
                self.realmProvider.addCurrentForecastToQueryList(time: dateTime, forecast: weatherDescription, temp: temp)
                self.realmProvider.addCoordinatesToQueryList(time: dateTime, lat: lat, lon: lon)
                self.temperatureData = Int(temp)
                self.windSpeed = windSpeed
                
                if let imageURL = URL(string: "https://openweathermap.org/img/wn/\(iconImage)@2x.png") {
                    
                    do {
                        let imageData = try Data(contentsOf: imageURL)
                        self.iconImage = UIImage(data: imageData)
                    } catch _ {
                        print("Error")
                    }
                }
                
                let positionPlace = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
                let iconMarker = GMSMarker(position: positionPlace)
                
                guard let mapView = self.mapZone else { return }
                
                iconMarker.map = mapView
                mapView.selectedMarker = iconMarker
                
//                let alert = UIAlertController(title: "Temperature:", message: "Temperature here is equal to \(temp.description) °C", preferredStyle: .alert)
//                let okButton = UIAlertAction(title: "Okey", style: .cancel)
//                alert.addAction(okButton)
//                self.present(alert, animated: true)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
