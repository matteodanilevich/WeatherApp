//
//  HourlyWeatherCell.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import UIKit

class HourlyWeatherCell: UITableViewCell {

    @IBOutlet weak var collectionWeatherCell: UICollectionView!

    static let key = "HourlyWeatherCell"

    var dtArray: [String]!
    var imageArray: [UIImage]!
    var temperatureArray: [Double]!

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionWeatherCell.delegate = self
        collectionWeatherCell.dataSource = self

        collectionWeatherCell.register(UINib(nibName: "HourlyWeatherCollectionCell", bundle: nil), forCellWithReuseIdentifier: HourlyWeatherCollectionCell.key)

        //Make invisable selection
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
