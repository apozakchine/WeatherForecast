//
//  ImageDownloaderService.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 08.11.2025.
//

import Foundation
import ServiceAPI

protocol IImageDownloaderService: ServiceProtocol {
    func data(for id: String) async throws(ServiceAPI.Error) -> Data
}

final class ImageDownloaderService: IImageDownloaderService {
    
    enum Source: Endpoint {
                
        case data(String)
        
        var serverURL: String {
            return "https://openweathermap.org/img/wn/"
        }
        
        var timeoutInterval: TimeInterval {
            return 10.0
        }
        
        var path: String {
            switch self {
            case let .data(id):
                return "/\(id)@2x.png"
            }
        }
        
        var method: HTTP.Method {
            return .get
        }
        
        func builder() -> URLRequest {
            return empty()
        }
    }
    
    func data(for id: String) async throws(ServiceAPI.Error) -> Data {
        let gateway = Gateway<Data>()
        let source = Source.data(id)
        return try await data(source, gateway: gateway)
    }
        
}
