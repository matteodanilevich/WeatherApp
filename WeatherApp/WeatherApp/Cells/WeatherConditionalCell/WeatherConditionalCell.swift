//
//  WeatherConditionalCell.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/8/22.
//

import UIKit

class WeatherConditionalCell: UITableViewCell {

    static let key = "WeatherConditionalCell"

    @IBOutlet weak var weatherConditionName: UILabel!
    @IBOutlet weak var weatherConditionIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
