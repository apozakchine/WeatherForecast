//
//  RootViewModel.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 09.11.2025.
//

import Foundation
import CoreLocation
import ServiceAPI

final class RootViewModel: ObservableObject {
    
    typealias LocationRequest = () async throws -> CLLocation
    typealias GeocodeRequest = (CLLocation) async throws -> String
    typealias WeatherRequest = (CLLocation) async throws -> ForecastResponse

    @Published var state: RootViewModelState = .initial
    
    private let requestLocationHandler: LocationRequest
    private let geocodeLocationHandler: GeocodeRequest
    private let weatherRequestHandler: WeatherRequest
    
    private var location: CLLocation?
    
    init(
        requestLocationHandler: @escaping LocationRequest,
        geocodeLocationHandler: @escaping GeocodeRequest,
        weatherRequestHandler: @escaping WeatherRequest
    ) {
        self.requestLocationHandler = requestLocationHandler
        self.geocodeLocationHandler = geocodeLocationHandler
        self.weatherRequestHandler = weatherRequestHandler
    }
    
    func startInitialState() async {
        await requestLocation(using: requestLocationHandler, fallbackContent: .default)
    }
    
    func geocodeLocationState() async {
        guard case let .locationFetched(instance) = state else {
            return
        }
        guard let location = instance.location else {
            return
        }
        await geocode(
            location: location,
            using: geocodeLocationHandler,
            fallbackContent: "Cant recognize location"
        )
    }
    
    func setNewLocation(_ location: CLLocation) async {
        await MainActor.run {
            resolve(location: location)
        }
    }
    
    func requestWeather() async {
        guard let location else { return }
        await fetchWeather(using: weatherRequestHandler, at: location)
    }

}

private extension RootViewModel {
    
    func fetchWeather(using request: @escaping WeatherRequest, at location: CLLocation) async {
        do {
            let weather = try await request(location)
            await MainActor.run {
                emit(.weatherFetched(weather))
            }
        } catch {
            await MainActor.run {
                emit(.error(error as! ServiceAPI.Error))
            }
        }
    }
    
    func requestLocation(
        using request: @escaping LocationRequest,
        fallbackContent: CLLocation,
        failureMessage: String? = nil
    ) async {
        do {
            let location = try await request()
            await MainActor.run {
                resolve(location: location)
            }
        } catch is LocationError {
            await MainActor.run {
                resolve(location: .default)
            }
        } catch {
            await MainActor.run {
                resolve(location: .default)
            }
        }
    }
    
    func geocode(
        location: CLLocation,
        using request: @escaping GeocodeRequest,
        fallbackContent: String
    ) async {
        do {
            let address = try await request(location)
            await MainActor.run {
                geocode(location: location, to: address)
            }
        } catch {
            await MainActor.run {
                geocode(location: location, to: fallbackContent)
            }
        }
    }
    
    @MainActor
    func resolve(location: CLLocation) {
        self.location = location
        emit(.locationFetched(Place(location: location)))
    }

    @MainActor
    func geocode(location: CLLocation, to address: String) {
        emit(.locationFetched(Place(location: location, address: address)))
    }

    @MainActor
    func emit(_ state: RootViewModelState) {
        self.state = state
    }

}
