//
//  MapViewModel.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import CoreLocation

final class MapViewModel: ObservableObject {
    
    @Published var state: MapViewModelState = .initial
    
    var initialLocation: CLLocation
    
    var updatedLocation: CLLocation? {
        guard case let .changed(location) = state else {
            return nil
        }
        return location
    }

    init(location: CLLocation) {
        self.initialLocation = location
    }
    
    func setNewLocation(_ location: CLLocation) {
        emit(.changed(location))
    }
 
    private func emit(_ state: MapViewModelState) {
        self.state = state
    }

}
