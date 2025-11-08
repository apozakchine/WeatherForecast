//
//  DailyViewModel.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 06.11.2025.
//

import Foundation
import CoreLocation
import ServiceAPI

final class DailyViewModel {
    
    typealias WeatherRequest = (CLLocation) async throws -> DailyForecastResponse
    
    private var stateStorage: DailyViewModelState = .initial
    private let requestHandler: WeatherRequest
    var state: DailyViewModelState { stateStorage }
    
    var location: CLLocation? {
        didSet {
            guard let location else { return }
            Task {
                await fetchWeather(using: requestHandler, at: location)
            }
        }
    }
    
    var totalImagesCount: Int = 0
    
    var onStateChange: ((DailyViewModelState) -> Void)? {
        didSet {
            guard let observer = onStateChange else { return }
            observer(stateStorage)
        }
    }
    
    init(requestHandler: @escaping WeatherRequest) {
        self.requestHandler = requestHandler
    }
    
    deinit {
        onStateChange = nil
    }
    
    private func fetchWeather(
        using request: @escaping WeatherRequest,
        at location: CLLocation
    ) async {
        do {
            let response = try await request(location)
            
            var viewModels = [DailyCollectionViewModel]()
            response.list.sorted(by: { $0.dt < $1.dt }).forEach({
                let currentStartOfDay = $0.dt.startOfDay
                let item: DailyCollectionViewModel.Item = .init(time: $0.dt.date,
                                                                imageId: $0.weather.first?.icon,
                                                                name: $0.weather.first?.main,
                                                                description: $0.weather.first?.description,
                                                                temperature: $0.main.temp,
                                                                wind: $0.wind.speed,
                                                                cloud: $0.clouds.all)
                if let index = viewModels.firstIndex(where: { $0.date.startOfDay == currentStartOfDay }) {
                    viewModels[index].items.append(item)
                } else {
                    let element = DailyCollectionViewModel(
                        date: currentStartOfDay,
                        sunrise: response.city.sunrise.date,
                        sunset: response.city.sunset.date,
                        items: [item]
                    )
                    viewModels.append(element)
                }
            })
            totalImagesCount = viewModels.count
            
            await MainActor.run { [viewModels] in
                emit(.weatherFetched(response.city.name, viewModels))
            }
        } catch {
            await MainActor.run {
                emit(.error(error as! ServiceAPI.Error))
            }
        }
    }
    
    @MainActor
    private func emit(_ state: DailyViewModelState) {
        stateStorage = state
        onStateChange?(state)
    }

}
