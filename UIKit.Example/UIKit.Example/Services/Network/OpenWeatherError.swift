//
//  OpenWeatherError.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 30.10.2025.
//

import Foundation
import ServiceAPI

struct OpenWeatherError: CustomError {
    
    typealias T = Response
    
    public struct Response: Codable, CoderProvider {
        let cod: String
        let message: String?
    }
    
    public var instance: Response
    
    public var localizedDescription: String {
        return "\(instance.message ?? "")"
    }
    
    public init(from data: Data) throws {
        do {
            self.instance = try Response.decoder().decode(Response.self, from: data)
        }
        catch let error {
            throw error
        }
    }
    
}
