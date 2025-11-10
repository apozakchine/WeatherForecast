//
//  DailyCollectionViewModel.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import Foundation

struct DailyCollectionViewModel: Hashable {
    
    struct Item: Hashable, Identifiable {

        let id = UUID()
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
