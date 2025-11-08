//
//  DailyForecastViewController+Observer.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 06.11.2025.
//

import Foundation
import CoreLocation

extension DailyForecastViewController: Observer {
    
    func start() {
        token = .init(uuid: UUID(), observer: self)
        center?.add(observerWith: token)
    }
    
    func stop() {
        center?.remove(observerWith: token)
    }
    
    func center(_ center: any ObservationCenter, emit event: ObserverEvent, userInfo: [String : Any]?) {
        guard let location = userInfo?["location"] as? CLLocation else {
            return
        }
        viewModel.location = location
    }
    
}
