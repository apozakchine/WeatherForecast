//
//  MapViewModel.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 27.10.2025.
//

import CoreLocation

final class MapViewModel {
    
    private var stateStorage: MapViewModelState = .initial
    
    var state: MapViewModelState { stateStorage }
    
    var initialLocation: CLLocation

    var onStateChange: ((MapViewModelState) -> Void)? {
        didSet {
            guard let observer = onStateChange else { return }
            observer(stateStorage)
        }
    }

    init(location: CLLocation) {
        self.initialLocation = location
    }
    
    func setNewLocation(_ location: CLLocation) {
        emit(.changed(location))
    }
 
    private func emit(_ state: MapViewModelState) {
        stateStorage = state
        onStateChange?(state)
    }

}
