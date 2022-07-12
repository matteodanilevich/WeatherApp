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
        getForecastByCoordinates(coord: coordinate)
    }
}
