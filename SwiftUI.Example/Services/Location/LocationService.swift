//
//  LocationService.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 09.11.2025.
//

import CoreLocation

enum LocationError: Error {
    case status(CLAuthorizationStatus)
    case geocodeFail
    case unknown
}

final class LocationService: NSObject {
    
    var addressConverter: IPlacemarkConverter = PostalAddressConverter()
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    private var authorizationStatusContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var requestLocationContinuation: CheckedContinuation<CLLocation, Error>?
    
    private var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorization() async -> CLAuthorizationStatus {
        await withCheckedContinuation { [weak self] continuation in
            self?.authorizationStatusContinuation = continuation
            self?.manager.requestWhenInUseAuthorization()
        }
    }
    
    func requestLocation() async throws -> CLLocation {
        if authorizationStatus == nil || authorizationStatus == .notDetermined {
            authorizationStatus = await requestAuthorization()
        }
        switch authorizationStatus {
        case .notDetermined, .restricted, .denied:
            throw LocationError.status(authorizationStatus ?? .denied )
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            return try await withCheckedThrowingContinuation { [weak self] continuation in
                self?.manager.requestLocation()
                self?.requestLocationContinuation = continuation
            }
        case .none:
            throw LocationError.unknown
        @unknown default:
            throw LocationError.unknown
        }
    }
    
    func reverseGeoocode(location: CLLocation) async throws -> String {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            return addressConverter.address(from: placemarks)
        } catch {
            throw error
        }
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        authorizationStatusContinuation?.resume(returning: status)
        authorizationStatusContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        manager.stopUpdatingLocation()
        requestLocationContinuation?.resume(returning: location)
        requestLocationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        requestLocationContinuation?.resume(throwing: error)
        requestLocationContinuation = nil
    }
    
}
