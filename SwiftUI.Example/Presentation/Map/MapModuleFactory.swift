//
//  MapModuleFactory.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import CoreLocation
import SwiftUI

struct MapModuleFactory {
    
    let location: CLLocation
    
    func makeView() -> some View {
        let viewModel = MapViewModel(location: location)
        return MapView(viewModel: viewModel)
    }
    
}
