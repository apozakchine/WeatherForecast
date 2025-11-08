//
//  MapViewModelState.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 27.10.2025.
//

import CoreLocation

enum MapViewModelState {
    
    case initial
    case changed(CLLocation)
    
}
