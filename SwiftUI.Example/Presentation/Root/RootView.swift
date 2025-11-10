//
//  RootView.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 08.11.2025.
//

import SwiftUI
import CoreLocation
import ServiceAPI

extension CGFloat {
    static let itemSideSize: CGFloat = 150.0
}

struct RootView: View {
    
    enum Destination {
        case map
    }
    
    @EnvironmentObject var place: Place
    @StateObject var viewModel: RootViewModel
    
    @State var response: ForecastResponse?
    @State var error: ServiceAPI.Error?
    
    @State private var navigationPath = NavigationPath()
    
    private var isDataLoading: Bool {
        if response == nil && error == nil {
            return viewModel.state != .initial
        } else {
            return false
        }
    }

    private var columns: [GridItem] {
        guard let _ = response else {
            return []
        }
        return [GridItem(.fixed(.itemSideSize)), GridItem(.fixed(.itemSideSize))]
    }
    
    private var items: [RootTableViewModel] {
        guard let response else {
            return []
        }
        var result = [RootTableViewModel]()
        if let weather = response.weather.first {
            result.append(.weather(weather))
        }
        return result + [
            .main(response.main),
            .wind(response.wind),
            .clouds(response.clouds),
            .sunrise(response.sys.sunrise),
            .sunset(response.sys.sunset)
        ]
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                LocationView(onButtonTap: {
                    navigationPath.append(Destination.map)
                })
                ScrollView {
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.primary))
                            .controlSize(.large)
                            .opacity(isDataLoading ? 1.0 : 0.0)
                    }
                    
                    LazyVGrid(columns: columns, alignment: .center, spacing: 8.0) {
                        ForEach(items, id: \.self) { item in
                            viewFor(item: item)
                        }
                    }
                    .padding(.vertical, 16.0)
                }
                .background(.background)
            }
            .navigationTitle("Weather Forecast")
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .map:
                    MapModuleFactory(location: place.location ?? .default)
                        .makeView()
                }
            }
        }
        .onError(when: $error, withTitle: "Attention", action: {
            error = nil
            viewModel.state = .initial
        })
        .onAppear {
            Task {
                await viewModel.startInitialState()
            }
        }
        .onChange(of: viewModel.state) { _, _ in
            onViewModelStateChange()
        }.onChange(of: place.location) { _, location in
            if let location {
                Task {
                    await viewModel.setNewLocation(location)
                }
            } else {
                Task {
                    await viewModel.startInitialState()
                }
            }
        }
    }
    
    @ViewBuilder
    private func viewFor(item: RootTableViewModel) -> some View {
        switch item {
        case let .weather(instance):
            WeatherCell(value: instance)
        case let .main(instance):
            MainCell(value: instance)
        case let .wind(instance):
            WindCell(value: instance)
        case let .clouds(instance):
            CloudCell(value: instance)
        case let .sunrise(value):
            SunCell(value: value, isUp: true)
        case let .sunset(value):
            SunCell(value: value, isUp: false)
        }
    }
    
}

#Preview {
    RootView(viewModel: PreviewModels.rootViewModel)
        .environmentObject(Place.default)
}
