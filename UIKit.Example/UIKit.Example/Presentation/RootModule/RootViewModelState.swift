//
//  RootViewModelState.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 26.10.2025.
//

import Foundation
import CoreLocation
import ServiceAPI

enum RootViewModelState {
    
    typealias Location = (location: CLLocation, address: String?)
    
    case initial
    case locationFetched(Location)
    case weatherFetched(ForecastResponse)
    case error(ServiceAPI.Error)
    
}
