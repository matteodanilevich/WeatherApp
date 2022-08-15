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

            guard let temperature = temperatureData, let iconImage = iconImage else { return UIView() }

            infoView.temperatureData.text = "\(NSLocalizedString("Temperature", comment: "")): \(temperature)°"
            infoView.iconImage.image = iconImage
            return infoView
        }
        return UIView()
    }
}
