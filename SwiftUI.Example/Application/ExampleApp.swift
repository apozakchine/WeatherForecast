//
//  ExampleApp.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 08.11.2025.
//

import SwiftUI

@main
struct ExampleApp: App {
    @StateObject var place: Place = Place(location: nil)
    
    var environment: AppEnvironment = .default
    
    var body: some Scene {
        WindowGroup {
            environment.presentation.moduleFactory.makeView()
                .environmentObject(place)
        }
    }
}
