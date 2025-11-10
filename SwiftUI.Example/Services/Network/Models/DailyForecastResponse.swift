//
//  DailyForecastResponse.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import Foundation
import ServiceAPI

struct DailyForecastResponse: Codable, CoderProvider {
    
    struct City: Codable {
        
        let id: Int
        let name: String
        let sunset: Double
        let sunrise: Double

    }
    
    struct Item: Codable {
                
        let dt: TimeInterval
        let main: ForecastResponse.Main
        let weather: [ForecastResponse.Weather]
        let clouds: ForecastResponse.Clouds
        let wind: ForecastResponse.Wind

    }
    
    let cnt: Int
    let city: City
    let list: [Item]
}

extension DailyForecastResponse: Equatable {
    
    static func == (lhs: DailyForecastResponse, rhs: DailyForecastResponse) -> Bool {
        return lhs.cnt == rhs.cnt
    }
    
}
