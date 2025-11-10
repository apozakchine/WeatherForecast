//
//  RootTableViewModel.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import Foundation

enum RootTableViewModel {
    
    case weather(ForecastResponse.Weather)
    case main(ForecastResponse.Main)
    case wind(ForecastResponse.Wind)
    case clouds(ForecastResponse.Clouds)
    case sunrise(Double)
    case sunset(Double)
    
}

extension RootTableViewModel: Hashable, Equatable {
    
    var sectionDescription: String {
        switch self {
        case .weather:
            return "Weather"
        case .main:
            return "Temperature"
        case .wind:
            return "Wind"
        case .clouds:
            return "Clouds"
        case .sunset:
            return "Sunset"
        case .sunrise:
            return "Sunrise"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sectionDescription)
    }
    
    static func == (lhs: RootTableViewModel, rhs: RootTableViewModel) -> Bool {
        return lhs.sectionDescription == rhs.sectionDescription
    }
}
