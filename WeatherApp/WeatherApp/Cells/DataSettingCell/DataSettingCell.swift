//
//  DataSettingCell.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/8/22.
//

import UIKit

class DataSettingCell: UITableViewCell {

    static let key = "DataSettingCell"

    @IBOutlet weak var dataSettingName: UILabel!
    @IBOutlet weak var dataSettingIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
