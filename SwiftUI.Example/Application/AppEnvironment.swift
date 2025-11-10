//
//  AppEnvironment.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 09.11.2025.
//

import Foundation

struct AppEnvironment {
    
    static let `default`: AppEnvironment =
        .init(presentation: PresentationModuleFactory(
            moduleFactory: .init(
                locationService: LocationService()
            )
        ))
    
    let presentation: PresentationModuleFactory
    
}
