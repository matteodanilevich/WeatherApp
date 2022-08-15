//
//  WeatherConditionalView.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/8/22.
//

import UIKit

class WeatherConditionalView: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var weatherConditionalList: [String]!
    var provider = RealmProvider()

    let notificationCenter = UNUserNotificationCenter.current()

    enum WeatherConditionalTypes: Int {

        case thunder = 0
        case rain
        case snow
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        weatherConditionalList = ["Thunderstorm", "Rain", "Snow"]

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "WeatherConditionalCell", bundle: nil), forCellReuseIdentifier: WeatherConditionalCell.key)
    }

    @IBAction func closeVcController(_ sender: Any) {
        dismiss(animated: true)
    }
}
