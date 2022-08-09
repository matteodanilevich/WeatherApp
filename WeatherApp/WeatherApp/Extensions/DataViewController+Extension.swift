//
//  DataViewController+Extension.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/9/22.
//

import Foundation
import UIKit

extension DataViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSettings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: DataSettingCell.key) as? DataSettingCell {

            cell.dataSettingName.text = NSLocalizedString(dataSettings[indexPath.row], comment: "")

            if checkData() {
                switch DataFormat(rawValue: indexPath.row) {
                case .firstData:
                    cell.dataSettingIcon.image = UIImage(systemName: "circle.fill")
                default:
                    cell.dataSettingIcon.image = UIImage(systemName: "circle")
                }
            } else {
                switch DataFormat(rawValue: indexPath.row) {
                case .firstData:
                    cell.dataSettingIcon.image = UIImage(systemName: "circle")
                default:
                    cell.dataSettingIcon.image = UIImage(systemName: "circle.fill")
                }
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        provider.formatUpdate(formatedData: !checkData())
        tableView.reloadData()
    }

}
