//
//  RootView+State.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 09.11.2025.
//

import Foundation

extension RootView {
    
    func onViewModelStateChange() {
        switch viewModel.state {
        case .initial:
            if place.location == nil {
                Task {
                    await viewModel.startInitialState()
                }
            }
        case let .locationFetched(value):
            place.update(value)
            if let _ = value.address {
                Task {
                    await viewModel.requestWeather()
                }
            } else {
                Task {
                    await viewModel.geocodeLocationState()
                }
            }
        case let .weatherFetched(value):
            response = value
        case let .error(error):
            self.error = error
        }
    }

}
