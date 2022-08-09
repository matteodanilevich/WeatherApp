//
//  MapViewController+Extension.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/7/22.
//

import Foundation
import GoogleMaps

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        getForecastByCoordinates(coord: coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        if let infoView = Bundle.main.loadNibNamed("CustomInfoLabel", owner: self, options: nil)?.first as? CustomInfoLabel {
            
            guard let temperature = temperatureData, let iconImage = iconImage, let windSpeed = windSpeed else { return UIView() }
            
            infoView.temperatureData.text = "Temperature: \(temperature)"
            infoView.iconImage.image = iconImage
            infoView.windSpeed.text = "Speed Wind: \(windSpeed)"
            return infoView
        }
        return UIView()
    }
}
