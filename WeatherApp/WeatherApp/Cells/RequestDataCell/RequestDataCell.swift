//
//  RequestDataCell.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/6/22.
//

import UIKit

class RequestDataCell: UITableViewCell {

    @IBOutlet weak var requestData: UILabel!
    @IBOutlet weak var requestLatitude: UILabel!
    @IBOutlet weak var requestLongitude: UILabel!
    @IBOutlet weak var requestWeather: UILabel!
    @IBOutlet weak var requestTemperature: UILabel!
    
    static let key = "RequestDataCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
