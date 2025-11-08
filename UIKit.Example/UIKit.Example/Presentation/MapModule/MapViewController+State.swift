//
//  MapViewController+State.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 27.10.2025.
//

import UIKit
import MapKit

extension MapViewController {
    
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            apply(state: state)
        }
    }
    
    func apply(state: MapViewModelState) {
        switch state {
        case .initial:
            let annotation = MKPointAnnotation()
            annotation.coordinate = viewModel.initialLocation.coordinate
            mapView.center(to: viewModel.initialLocation, animated: true)
            mapView.addAnnotation(annotation)
        case .changed:
            actionButton.isEnabled = true
        }
    }

}
