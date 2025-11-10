//
//  Weather.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 09.11.2025.
//

import Foundation
import ServiceAPI
import CoreLocation

enum Units: String, Codable {
    case standard
    case metric
    case imperial
}

struct Coordinate: Codable, CoderProvider {
    
    let lat: Double
    let lon: Double
    
}

struct ForecastRequest: Codable, CoderProvider {
    
    let lat: Double
    let lon: Double
    let units: Units?
    
    init(location: CLLocation, units: Units = .metric) {
        self.lat = location.coordinate.latitude
        self.lon = location.coordinate.longitude
        self.units = units
    }
    
}

struct ForecastResponse: Codable, CoderProvider {
    
    struct Weather: Codable, Hashable {
        
        let id: Int
        let main: String
        let description: String?
        let icon: String?
        
    }
    
    struct Main: Codable {
        
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Double
        let humidity: Double
        let sea_level: Double?
        let grnd_level: Double?

    }
    
    struct Wind: Codable {
        
        let speed: Double
        let deg: Double
        let gust: Double?

    }
    
    struct Clouds: Codable {
        
        let all: Double
        
    }
    
    struct System: Codable {
        
        let sunrise: TimeInterval
        let sunset: TimeInterval

    }
    
    let coord: Coordinate
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let sys: System
    let visibility: Double
    
}

extension ForecastResponse: Equatable {
    
    static func == (lhs: ForecastResponse, rhs: ForecastResponse) -> Bool {
        return lhs.coord.lat == rhs.coord.lat && lhs.coord.lon == rhs.coord.lon
    }
    
}
