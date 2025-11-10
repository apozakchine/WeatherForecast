//
//  PreviewModels.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import CoreLocation

struct PreviewModels {
    
    static let rootViewModel: RootViewModel = .init(
        requestLocationHandler: {
            return .default
        },
        geocodeLocationHandler: { _ in
            return ""
        },
        weatherRequestHandler: { _ in
            return .init(
                coord: .init(
                    lat: CLLocation.default.coordinate.latitude,
                    lon: CLLocation.default.coordinate.longitude
                ),
                weather: [],
                main: .init(
                    temp: 0.0,
                    feels_like: 0.0,
                    temp_min: 0.0,
                    temp_max: 0.0,
                    pressure: 0.0,
                    humidity: 0.0,
                    sea_level: 0.0,
                    grnd_level: 0.0),
                    wind: .init(speed: 0.0, deg: 0.0, gust: 0.0),
                    clouds: .init(all: 0.0),
                    sys: .init(sunrise: 0.0, sunset: 0.0),
                    visibility: 0.0
            )
        }
    )
    
    static let mapViewModel: MapViewModel = .init(location: .default)
    
    static let dailyViewModel: DailyViewModel = .init(requestHandler: { _ in
        return .init(cnt: 0,
                     city: .init(id: 0,
                                 name: "",
                                 sunset: 0.0,
                                 sunrise: 0.0),
                     list: [])
    })

}
