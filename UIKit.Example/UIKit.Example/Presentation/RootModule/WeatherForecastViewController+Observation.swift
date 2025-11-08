//
//  WeatherForecastViewController+Observation.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 06.11.2025.
//

import Foundation

extension WeatherForecastViewController: ObservationCenter {
    
    func add(observerWith token: ObservationToken) {
        guard observers.firstIndex(of: token) == nil else {
            return
        }
        observers.append(token)
        if let location = viewModel.location {
            observers[observers.count - 1]
                .observer?
                .center(self,
                        emit: .locationChanged,
                        userInfo: ["location" : location]
                )
        }
    }
    
    func remove(observerWith token: ObservationToken) {
        guard let index = observers.firstIndex(of: token) else {
            return
        }
        observers.remove(at: index)
    }
    
    
    
}
