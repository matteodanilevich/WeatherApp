//
//  DataViewController.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/8/22.
//

import UIKit

class DataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var provider = RealmProvider()
    var defaults = UserDefaults()
    var dataSettings: [String]!
    
    enum DataFormat: Int {
        case firstData = 0
        case secondData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSettings = ["24-hour format", "12-hour format"]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "DataSettingCell", bundle: nil), forCellReuseIdentifier: DataSettingCell.key)
    }
    
    func checkData() -> Bool {
        
        let settingList = provider.getResultForDataBase(objectName: RealmSettings.self).last
        let dataFormat = settingList?.formatData
        return dataFormat ?? false
    }
    
    @IBAction func closeVcController(_ sender: Any) {
        dismiss(animated: true)
    }
}
