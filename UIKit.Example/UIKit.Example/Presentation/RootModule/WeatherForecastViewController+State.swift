//
//  WeatherForecastViewController+State.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 26.10.2025.
//

import Foundation

extension WeatherForecastViewController {
    
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            apply(state: state)
        }
    }
    
    @MainActor
    func apply(state: RootViewModelState) {
        switch state {
        case .initial:
            startTask { [weak self] in
                await self?.viewModel.startInitialState()
            }
        case let .locationFetched(instance):
            if let address = instance.address {
                locationView.textLabel.text = address
                locationView.isHidden = false
                startLoading()
                observers.forEach({
                    $0.observer?
                        .center(self,
                                emit: .locationChanged,
                                userInfo: ["location" : instance.location]
                    )
                })
                startTask { [weak self] in
                    await self?.viewModel.requestWeather()
                }
            } else {
                startTask { [weak self] in
                    await self?.viewModel.geocodeLocationState()
                }
            }
        case let .weatherFetched(weather):
            endLoading()
            applySnapshot(response: weather)
        case let .error(error):
            endLoading()
            displayError(error.localizedDescription)
        }
    }
    
    func startTask(_ operation: @escaping () async -> Void) {
        let task = Task {
            await operation()
        }
        tasks.append(task)
    }

}
