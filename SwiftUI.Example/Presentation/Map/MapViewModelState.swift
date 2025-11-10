//
//  MapViewModelState.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import Foundation

import CoreLocation

enum MapViewModelState: Equatable {
    
    case initial
    case changed(CLLocation)
    
}
