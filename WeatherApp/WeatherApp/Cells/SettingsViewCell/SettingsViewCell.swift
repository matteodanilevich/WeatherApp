//
//  SettingsViewCell.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/8/22.
//

import UIKit

class SettingsViewCell: UITableViewCell {

    static let key = "SettingsViewCell"
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
