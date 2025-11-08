//
//  RootModuleFactory.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 26.10.2025.
//

import UIKit

struct RootModuleFactory {
    
    let locationService: LocationService
    
    func makeRootViewController() -> UIViewController {
        let rootViewModel = RootViewModel(
            requestLocationHandler: {
                try await locationService.requestLocation()
            },
            geocodeLocationHandler: {
                location in try await locationService.reverseGeoocode(location: location)
            },
            weatherRequestHandler: {
                location in try await API.shared.weatherService.forecast(.init(location: location))
            }
        )
        let mainController = WeatherForecastViewController(viewModel: rootViewModel)
        
        let dailyViewModel = DailyViewModel(requestHandler: {
                location in try await API.shared.weatherService.daily(.init(location: location))
        })
        let dailyForecastViewController = DailyForecastViewController(viewModel: dailyViewModel, center: mainController)
        
        let tabBarController = UITabBarController(tabs: [
            .init(
                title: "Main",
                image: .init(systemName: "network"),
                identifier: "ru.weather.forecast.tabbar.item.main",
                viewControllerProvider: { _ in
                    return mainController
            }),
            .init(
                title: "Daily Forecast",
                image: .init(systemName: "calendar"),
                identifier: "ru.weather.forecast.tabbar.item.daily",
                viewControllerProvider: { _ in
                    return dailyForecastViewController
            })
        ])
        
        return UINavigationController(rootViewController: tabBarController)
    }
    
}
