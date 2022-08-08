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
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestViewController") as? RequestViewController {
                
                present(vc, animated: true)
            }
        case .dateFormatList:
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DataViewController") as? DataViewController {
                
                present(vc, animated: true)
            }
        case .systemList:
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SystemViewController") as? SystemViewController {
                
                present(vc, animated: true)
            }
            
        default:
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherConditionalView") as? WeatherConditionalView {
              
                present(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
}
