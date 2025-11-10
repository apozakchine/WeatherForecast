//
//  MapView+State.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import Foundation
import MapKit

extension MapView {
    
    func onViewModelStateChange() {
        switch viewModel.state {
        case .initial:
            break
        case .changed:
            isButtonDisabled = false
        }
    }

}
