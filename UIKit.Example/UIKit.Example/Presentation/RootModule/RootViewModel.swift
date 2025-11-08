//
//  RootViewModel.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 26.10.2025.
//

import Foundation
import CoreLocation
import ServiceAPI

extension CLLocation {
    static let `default`: CLLocation = .init(latitude: 55.731490, longitude: 37.637772)
}

final class RootViewModel {
    
    typealias LocationRequest = () async throws -> CLLocation
    typealias GeocodeRequest = (CLLocation) async throws -> String
    typealias WeatherRequest = (CLLocation) async throws -> ForecastResponse
    
    private var stateStorage: RootViewModelState = .initial
    
    private let requestLocationHandler: LocationRequest
    private let geocodeLocationHandler: GeocodeRequest
    private let weatherRequestHandler: WeatherRequest

    var state: RootViewModelState { stateStorage }
    var location: CLLocation?

    var onStateChange: ((RootViewModelState) -> Void)? {
        didSet {
            guard let observer = onStateChange else { return }
            observer(stateStorage)
        }
    }
    
    init(
        requestLocationHandler: @escaping LocationRequest,
        geocodeLocationHandler: @escaping GeocodeRequest,
        weatherRequestHandler: @escaping WeatherRequest
    ) {
        self.requestLocationHandler = requestLocationHandler
        self.geocodeLocationHandler = geocodeLocationHandler
        self.weatherRequestHandler = weatherRequestHandler
    }
    
    deinit {
        onStateChange = nil
    }
    
    func startInitialState() async {
        await requestLocation(using: requestLocationHandler, fallbackContent: .default)
    }
    
    func geocodeLocationState() async {
        guard case let .locationFetched(instance) = state else {
            return
        }
        await geocode(
            location: instance.location,
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
    
    private func fetchWeather(
        using request: @escaping WeatherRequest,
        at location: CLLocation
    ) async {
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
    
    private func requestLocation(
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
    
    private func geocode(
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
    private func resolve(location: CLLocation) {
        self.location = location
        emit(.locationFetched((location, nil)))
    }

    @MainActor
    private func geocode(location: CLLocation, to address: String) {
        emit(.locationFetched((location, address)))
    }

    @MainActor
    private func emit(_ state: RootViewModelState) {
        stateStorage = state
        onStateChange?(state)
    }

}
