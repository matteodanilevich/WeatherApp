//
//  HourlyWeatherCell+Extension.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import Foundation
import UIKit

extension HourlyWeatherCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        temperatureArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionCell.key, for: indexPath) as? HourlyWeatherCollectionCell {

            guard let dtArray = dtArray, let imageArray = imageArray, let temperatureArray = temperatureArray else { return cell }

            cell.currentHour.text = dtArray[indexPath.row].description
            cell.currentWeatherIcon.image = imageArray[indexPath.row]
            cell.currentTemperature.text = "\(temperatureArray[indexPath.row])°"

            return cell
        }

        return UICollectionViewCell()
    }
}
