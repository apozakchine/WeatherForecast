//
//  RootViewModelState.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 09.11.2025.
//

import Foundation
import CoreLocation
import ServiceAPI

class Place: ObservableObject, Equatable {
    
    static let `default` = Place(location: .default, address: "Moscow, Red Squard")
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.location == rhs.location && lhs.address == rhs.address
    }
    
    @Published var location: CLLocation?
    @Published var address: String?
    
    init(location: CLLocation?, address: String? = nil) {
        self.location = location
        self.address = address
    }
    
    func update(_ newValue: Place) {
        self.location = newValue.location
        self.address = newValue.address
    }
    
}

enum RootViewModelState: Equatable {
        
    case initial
    case locationFetched(Place)
    case weatherFetched(ForecastResponse)
    case error(ServiceAPI.Error)
    
    static func == (lhs: RootViewModelState, rhs: RootViewModelState) -> Bool {
        switch lhs {
        case .initial:
            switch rhs {
            case .initial:
                return true
            default:
                return false
            }
        case let .locationFetched(location):
            switch rhs {
            case let .locationFetched(value):
                return location == value
            default:
                return false
            }
        case let .weatherFetched(response):
            switch rhs {
            case let .weatherFetched(value):
                return response == value
            default:
                return false
            }
        case let .error(error):
            switch rhs {
            case let .error(value):
                return error.errorDescription == value.errorDescription
            default:
                return false
            }
        }
    }

    
}
