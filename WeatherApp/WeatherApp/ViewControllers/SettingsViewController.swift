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

    enum SettingsType: Int {

        case weatherRequestList = 0
        case requestList
        case systemList
        case dataFormatList
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        arraySettings = ["Choose weather conditional", "History request", "System measurement", "Data format"]
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "SettingsViewCell", bundle: nil), forCellReuseIdentifier: SettingsViewCell.key)
    }
}
