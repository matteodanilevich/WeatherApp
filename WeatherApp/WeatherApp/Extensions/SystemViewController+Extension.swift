//
//  SystemViewController+Extension.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/9/22.
//

import Foundation
import UIKit

extension SystemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        systemSettingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let settingsCell = tableView.dequeueReusableCell(withIdentifier: SystemSettingsCell.key) as? SystemSettingsCell {
            
            settingsCell.systemSettingsName.text = NSLocalizedString(systemSettingList[indexPath.row], comment: "")
            
            if checkSystemType() {
                
                switch SystemTypes(rawValue: indexPath.row) {
                    
                case .metrical:
                    settingsCell.systemSettingsIcon.image = UIImage(systemName: "circle.fill")
                default:
                    settingsCell.systemSettingsIcon.image = UIImage(systemName: "circle")
                }
            } else {
                switch SystemTypes(rawValue: indexPath.row) {
                    
                case .metrical:
                    settingsCell.systemSettingsIcon.image = UIImage(systemName: "circle")
                default:
                    settingsCell.systemSettingsIcon.image = UIImage(systemName: "circle.fill")
                }
            }
            return settingsCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        provider.systemUpdate(formatedData: !checkSystemType())
        tableView.reloadData()
    }
}
