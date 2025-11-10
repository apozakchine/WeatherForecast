//
//  Date+TimeInterval.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import Foundation

extension TimeInterval {
    
    var date: Date {
        return Date(timeIntervalSince1970: self)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: date)
    }
    
}

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
}
