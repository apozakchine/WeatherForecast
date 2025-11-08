//
//  API.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 30.10.2025.
//

import Foundation
import ServiceAPI

final class API {
    static let shared = API()
    
    private(set) var weatherService: IForecastService = ForecastService()
    private let connector = Connector.shared
    
    init() {
        connector.customErrorHandler = CustomErrorHandlerDefault(classes: [OpenWeatherError.self])
    }
}
