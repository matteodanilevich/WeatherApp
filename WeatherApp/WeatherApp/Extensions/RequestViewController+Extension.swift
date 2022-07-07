//
//  RequestViewController+Extension.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/7/22.
//

import Foundation
import RealmSwift
import UIKit

extension RequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        realmProvider.getResultForDataBase(objectName: QueryListForRealm.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let dataCell = tableView.dequeueReusableCell(withIdentifier: RequestDataCell.key) as? RequestDataCell {
            
            let data = realmProvider.getResultForDataBase(objectName: QueryListForRealm.self)[indexPath.row]
            
            guard let currentForecast = data.currentForecast else { return dataCell}
            
            dataCell.requestData.text = data.time.convertDataTime(.customTime)
            dataCell.requestLatitude.text = data.latitude.description
            dataCell.requestLongitude.text = data.longitude.description
            dataCell.requestWeather.text = currentForecast.forecastDescription
            dataCell.requestTemperature.text = "\(currentForecast.temp.description) °C"
            
            return dataCell
        }
        
        return UITableViewCell()
    }
}
