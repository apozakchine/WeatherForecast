//
//  RootTableViewModel.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 03.11.2025.
//

import Foundation

enum RootTableViewModel {
    
    case weather([ForecastResponse.Weather])
    case main(ForecastResponse.Main)
    case wind(ForecastResponse.Wind)
    case clouds(ForecastResponse.Clouds)
    case system(ForecastResponse.System)
    
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
        case .system:
            return ""
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sectionDescription)
    }
    
    static func == (lhs: RootTableViewModel, rhs: RootTableViewModel) -> Bool {
        return lhs.sectionDescription == rhs.sectionDescription
    }
}
