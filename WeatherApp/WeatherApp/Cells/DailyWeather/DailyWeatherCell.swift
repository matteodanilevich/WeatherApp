//
//  DailyWeatherCell.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import UIKit

class DailyWeatherCell: UITableViewCell {

    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    
    static let key = "DailyWeatherCell"
    
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
