//
//  Int+Extension.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/7/22.
//

import Foundation

extension Int {

    func convertDataTime(formattedDataType: FormattedDataType) -> String {

        let formData = Date(timeIntervalSince1970: TimeInterval(self))
        let formattedData = DateFormatter()

        formattedData.dateFormat = formattedDataType.description

        let convertedTime = formattedData.string(from: formData)
        return convertedTime
    }
}
