//
//  DailyCollectionViewModel.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 07.11.2025.
//

import Foundation

struct DailyCollectionViewModel: Hashable {
    
    struct Item: Hashable {
        
        let time: Date
        let imageId: String?
        let name: String?
        let description: String?
        let temperature: Double
        let wind: Double
        let cloud: Double
        
    }
    
    var date: Date
    var sunrise: Date
    var sunset: Date
    var items: [Item]

}
