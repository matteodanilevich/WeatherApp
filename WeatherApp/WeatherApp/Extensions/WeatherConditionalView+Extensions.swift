//
//  WeatherConditionalView+Extensions.swift
//  WeatherApp
//
//  Created by Mateo Danilevich on 8/9/22.
//

import Foundation
import UIKit

extension WeatherConditionalView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherConditionalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let conditionalCell = tableView.dequeueReusableCell(withIdentifier: WeatherConditionalCell.key) as? WeatherConditionalCell {
            
            conditionalCell.weatherConditionName.text = NSLocalizedString(weatherConditionalList[indexPath.row], comment: "")
            
            let conditional = provider.getResultForDataBase(objectName: WeatherConditional.self).last
            let rain = conditional?.rain ?? false
            let thunder = conditional?.thunderStorm ?? false
            let snow = conditional?.snow ?? false
            
            switch WeatherConditionalTypes(rawValue: indexPath.row) {
                
            case .thunder:
                conditionalCell.weatherConditionIcon.image = UIImage(systemName: thunder ? "circle.fill" : "circle")
            case .rain:
                conditionalCell.weatherConditionIcon.image = UIImage(systemName: rain ? "circle.fill" : "circle")
            default:
                conditionalCell.weatherConditionIcon.image = UIImage(systemName: snow ? "circle.fill" : "circle")
            }
            return conditionalCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let conditional = provider.getResultForDataBase(objectName: WeatherConditional.self).last
        let rain = conditional?.rain ?? false
        let thunder = conditional?.thunderStorm ?? false
        let snow = conditional?.snow ?? false
        
        switch WeatherConditionalTypes(rawValue: indexPath.row){
            
        case .thunder:
            provider.weatherConditionalUpdate(snow: snow, thunder: !thunder, rain: rain)
        case .rain:
            provider.weatherConditionalUpdate(snow: snow, thunder: thunder, rain: !rain)
        default:
            provider.weatherConditionalUpdate(snow: !snow, thunder: thunder, rain: rain)
        }
        
        tableView.reloadData()
        notificationCenter.removeAllPendingNotificationRequests()
    }
}

