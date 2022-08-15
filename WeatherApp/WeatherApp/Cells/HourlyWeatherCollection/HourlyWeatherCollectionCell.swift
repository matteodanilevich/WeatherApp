//
//  HourlyWeatherCollectionCell.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import UIKit

class HourlyWeatherCollectionCell: UICollectionViewCell {

    @IBOutlet weak var currentHour: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentTemperature: UILabel!

    static let key = "HourlyWeatherCollectionCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
