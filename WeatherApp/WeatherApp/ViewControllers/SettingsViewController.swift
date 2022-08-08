//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/8/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var arraySettings: [String]!
    
    enum settingsType: Int {
        case weatherRequestList = 0
        case requestList
        case systemList
        case dateFormatList
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arraySettings = ["Choose weather conditional", "History request", "Weather measurement", "Data format"]
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SettingsViewCell", bundle: nil), forCellReuseIdentifier: SettingsViewCell.key)
    }
}
