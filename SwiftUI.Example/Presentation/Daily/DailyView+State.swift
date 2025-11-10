//
//  DailyView+State.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import Foundation

extension DailyView {
    
    func onViewModelStateChange() {
        switch viewModel.state {
        case .initial:
            break
        case let .fetched(newCity, newItems):
            city = newCity
            items = newItems
        case let .error(error):
            self.error = error
        }
    }

}
