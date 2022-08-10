//
//  SystemViewController.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/8/22.
//

import UIKit

class SystemViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var systemSettingList: [String]!
    var provider = RealmProvider()
    
    enum SystemTypes: Int {
        
        case metrical = 0
        case imperial
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        systemSettingList = ["Metrical system", "Imperial system"]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SystemSettingsCell", bundle: nil), forCellReuseIdentifier: SystemSettingsCell.key)
    }
    
    func checkSystemType() -> Bool {
        let settingList = provider.getResultForDataBase(objectName: RealmSettings.self).last
        let settingType = settingList?.systemType
        return settingType ?? false
    }
    
    @IBAction func closeVcController(_ sender: Any) {
        dismiss(animated: true)
    }
}
