//
//  AppEnvironment.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 26.10.2025.
//

import Foundation

struct AppEnvironment {
    
    static let `default`: AppEnvironment =
        .init(presentation: PresentationModuleFactory(rootModuleFactory: .init(locationService: LocationService())))
    
    let presentation: PresentationModuleFactory
    
}
