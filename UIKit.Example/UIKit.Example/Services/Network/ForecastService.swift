//
//  ForecastService.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 30.10.2025.
//

import Foundation
import ServiceAPI

protocol IForecastService: ServiceProtocol {
    func forecast(_ request: ForecastRequest) async throws(ServiceAPI.Error) -> ForecastResponse
    func daily(_ request: ForecastRequest) async throws(ServiceAPI.Error) -> DailyForecastResponse
}

final class ForecastService: IForecastService {
    
    enum Source: Endpoint {
                
        case weather(ForecastRequest)
        case daily(ForecastRequest)
        
        var serverURL: String {
            return "https://api.openweathermap.org/data/2.5"
        }
        
        var timeoutInterval: TimeInterval {
            return 10.0
        }
        
        var defaultQueryItems: [URLQueryItem] {
            return [.init(name: "appid", value: "3795acd1601cd78da54160ae0cdae52e")]
        }

        var path: String {
            switch self {
            case .weather:
                return "/weather"
            case .daily:
                return "/forecast"
            }
        }
        
        var method: HTTP.Method {
            return .get
        }
        
        func builder() -> URLRequest {
            switch self {
            case let .weather(request):
                return get(from: request)
            case let .daily(request):
                return get(from: request)
            }
        }
    }
    
    func forecast(_ request: ForecastRequest) async throws(ServiceAPI.Error) -> ForecastResponse {
        let gateway = Gateway<ForecastResponse>()
        let source = Source.weather(request)
        return try await metha(source, gateway: gateway)
    }
    
    func daily(_ request: ForecastRequest) async throws(ServiceAPI.Error) -> DailyForecastResponse {
        let gateway = Gateway<DailyForecastResponse>()
        let source = Source.daily(request)
        return try await metha(source, gateway: gateway)
    }
        
}
