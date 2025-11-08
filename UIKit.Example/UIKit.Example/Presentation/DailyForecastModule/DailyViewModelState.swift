//
//  DailyViewModelState.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 06.11.2025.
//

import Foundation
import ServiceAPI

enum DailyViewModelState {
    
    case initial
    case weatherFetched(String, [DailyCollectionViewModel])
    case error(ServiceAPI.Error)
    
}
