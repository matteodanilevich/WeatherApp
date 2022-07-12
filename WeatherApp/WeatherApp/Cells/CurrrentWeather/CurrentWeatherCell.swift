//
//  CurrentWeatherCell.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentSky: UILabel!
    @IBOutlet weak var currentTemperatureExtremum: UILabel!
    
    static let key = "CurrentWeatherCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Make invisable selection
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
