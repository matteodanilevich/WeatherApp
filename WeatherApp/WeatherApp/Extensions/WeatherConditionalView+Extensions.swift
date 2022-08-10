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
            let thunderStorm = conditional?.thunder ?? false
            let snow = conditional?.snow ?? false
            
            switch weatherConditionalTypes(rawValue: indexPath.row) {
                
            case .rain:
                conditionalCell.weatherConditionIcon.image = UIImage(systemName: rain ? "circle.fill" : "circle")
            case .snow:
                conditionalCell.weatherConditionIcon.image = UIImage(systemName: snow ? "circle.fill" : "circle")
            default:
                conditionalCell.weatherConditionIcon.image = UIImage(systemName: thunderStorm ? "circle.fill" : "circle")
            }
            return conditionalCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let conditional = provider.getResultForDataBase(objectName: WeatherConditional.self).last
        let rain = conditional?.rain ?? false
        let thunderStorm = conditional?.thunder ?? false
        let snow = conditional?.snow ?? false
        
        switch weatherConditionalTypes(rawValue: indexPath.row){
            
        case .rain:
            provider.weatherConditionalUpdate(snow: snow, thunder: thunderStorm, rain: !rain)
        case .snow:
            provider.weatherConditionalUpdate(snow: !snow, thunder: thunderStorm, rain: rain)
        default:
            provider.weatherConditionalUpdate(snow: snow, thunder: !thunderStorm, rain: rain)
        }
        
        tableView.reloadData()
        notificationCenter.removeAllPendingNotificationRequests()
    }
}

