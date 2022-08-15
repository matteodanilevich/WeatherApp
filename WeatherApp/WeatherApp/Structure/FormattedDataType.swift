//
//  FormattedDataType.swift
//  WeatherApp
//
//  Created by Matthew Danilevich on 7/5/22.
//

import Foundation

// MARK: - FormattedDataType
enum FormattedDataType {

    case minute
    case hour
    case secondHour
    case day
    case fullTime
    case customTime

    var description: String {

        switch self {
        case .minute:
            return "mm"
        case .hour:
            return "hh"
        case .secondHour:
            return "HH"
        case .day:
            return "EEE"
        case .fullTime:
            return "dd-MM-yy HH:mm:ss"
        case .customTime:
            return "EEE HH:mm:ss"
        }
    }
}
