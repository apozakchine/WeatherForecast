//
//  DailyViewModelState.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import Foundation
import ServiceAPI

enum DailyViewModelState: Equatable {
       
    case initial
    case fetched(String, [DailyCollectionViewModel])
    case error(ServiceAPI.Error)
    
    static func == (lhs: DailyViewModelState, rhs: DailyViewModelState) -> Bool {
        switch lhs {
        case .initial:
            switch rhs {
            case .initial:
                return true
            default:
                return false
            }
        case let .fetched(name, _):
            switch rhs {
            case let .fetched(value, _):
                return name == value
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
