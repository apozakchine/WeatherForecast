//
//  MapModuleFactory.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 27.10.2025.
//

import UIKit
import CoreLocation

protocol LocationChangeEmitter: AnyObject {
    
    var locationDidChangeHandler: ((CLLocation) -> Void)? { get set }
    
}

struct MapModuleFactory {
    
    typealias MapModule = UIViewController & LocationChangeEmitter
    
    let location: CLLocation
    
    func makeViewController() -> some MapModule {
        let viewModel = MapViewModel(location: location)
        return MapViewController(viewModel: viewModel)
    }
    
}
