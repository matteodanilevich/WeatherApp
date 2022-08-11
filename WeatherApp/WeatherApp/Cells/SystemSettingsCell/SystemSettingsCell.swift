//
//  SystemSettingsCell.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/8/22.
//

import UIKit

class SystemSettingsCell: UITableViewCell {

    static let key = "SystemSettingsCell"

    @IBOutlet weak var systemSettingsName: UILabel!
    @IBOutlet weak var systemSettingsIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
