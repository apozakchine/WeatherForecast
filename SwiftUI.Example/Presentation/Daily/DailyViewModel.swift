//
//  DailyViewModel.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import Foundation
import CoreLocation
import ServiceAPI

final class DailyViewModel: ObservableObject {
    
    typealias WeatherRequest = (CLLocation) async throws -> DailyForecastResponse
    
    private let requestHandler: WeatherRequest
    
    @Published var state: DailyViewModelState = .initial
    
    var location: CLLocation? {
        didSet {
            guard let location else { return }
            Task {
                await fetchWeather(using: requestHandler, at: location)
            }
        }
    }
    
    var totalImagesCount: Int = 0
    
    init(requestHandler: @escaping WeatherRequest) {
        self.requestHandler = requestHandler
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
                emit(.fetched(response.city.name, viewModels))
            }
        } catch {
            await MainActor.run {
                emit(.error(error as! ServiceAPI.Error))
            }
        }
    }
    
    @MainActor
    private func emit(_ state: DailyViewModelState) {
        self.state = state
    }

}
