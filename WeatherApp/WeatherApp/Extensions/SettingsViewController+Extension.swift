//
//  SettingsViewController+Extension.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/8/22.
//

import Foundation
import UIKit

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arraySettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewCell.key) as? SettingsViewCell {
            cell.settingsLabel.text = NSLocalizedString(arraySettings[indexPath.row], comment: "")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch settingsType(rawValue: indexPath.row) {
        case .requestList:
            if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestViewController") as? RequestViewController {
                
                present(viewcontroller, animated: true)
            }
        case .dateFormatList:
            if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DataViewController") as? DataViewController {
                
                present(viewcontroller, animated: true)
            }
        case .systemList:
            if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SystemViewController") as? SystemViewController {
                
                present(viewcontroller, animated: true)
            }
            
        default:
            if let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherConditionalView") as? WeatherConditionalView {
              
                present(viewcontroller, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}
