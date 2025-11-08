//
//  ObservationCenter.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 06.11.2025.
//

import Foundation

struct ObserverEvent: OptionSet {

    static let locationChanged: ObserverEvent = .init(rawValue: 0b0001 << 24)
    
    let rawValue : UInt

}

struct ObservationToken: Equatable {
    
    let uuid: UUID
    weak var observer: Observer?
    
    static func == (lhs: ObservationToken, rhs: ObservationToken) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
}
        
protocol ObservationCenter: AnyObject {
    
    func add(observerWith token: ObservationToken)
    func remove(observerWith token: ObservationToken)
    
}

protocol Observer: AnyObject {
    
    func center(_ center: ObservationCenter, emit event: ObserverEvent, userInfo: [String:Any]?)
    
}
