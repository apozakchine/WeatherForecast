//
//  RootModuleFactory.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 09.11.2025.
//

import Foundation
import SwiftUI

struct RootModuleFactory {
    
    let locationService: LocationService
    
    func makeView() -> some View {
        let rootViewModel = RootViewModel(
            requestLocationHandler: {
                try await locationService.requestLocation()
            },
            geocodeLocationHandler: {
                location in try await locationService.reverseGeoocode(location: location)
            },
            weatherRequestHandler: {
                location in try await API.shared.weatherService.forecast(.init(location: location))
            }
        )
        
        let dailyViewModel = DailyViewModel(requestHandler: {
                location in try await API.shared.weatherService.daily(.init(location: location))
        })

        return TabView {
            RootView(viewModel: rootViewModel)
                .tabItem {
                    Label("Main", systemImage: "network")
                }
            DailyView(viewModel: dailyViewModel)
                .tabItem {
                     Label("Daily Forecast", systemImage: "calendar")
                }
        }
    }
    
}
