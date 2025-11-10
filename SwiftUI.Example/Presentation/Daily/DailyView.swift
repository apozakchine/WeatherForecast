//
//  DailyView.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 09.11.2025.
//

import SwiftUI
import ServiceAPI

struct DailyView: View {
    
    @EnvironmentObject var place: Place
    
    @StateObject var viewModel: DailyViewModel
    
    @State var city: String?
    @State var items: [DailyCollectionViewModel]?
    @State var error: ServiceAPI.Error?
    
    @State private var navigationPath = NavigationPath()
    
    private var isDataLoading: Bool {
        if items?.isEmpty == true && error == nil {
            return viewModel.state == .initial
        } else {
            return false
        }
    }
    
    private var itemsStorage: [DailyCollectionViewModel] {
        guard let items else { return [] }
        return items
    }
    

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.primary))
                            .controlSize(.large)
                            .opacity(isDataLoading ? 1.0 : 0.0)
                    }
                    HStack(spacing: 8.0) {
                        ForEach(itemsStorage, id: \.self) { item in
                            DailyItemView(geometry: geometry,
                                          name: city ?? "",
                                          item: item)
                        }
                    }
                }
                .background(.background)
                .padding(8.0)
            }
        }
        .onError(when: $error, withTitle: "Attention", action: {
            error = nil
            viewModel.state = .initial
        })
        .onAppear {
            guard let location = place.location else { return }
            viewModel.state = .initial
            viewModel.location = location
        }
        .onChange(of: viewModel.state) { _, _ in
            onViewModelStateChange()
        }.onChange(of: place.location) { _, location in
            guard let location else { return }
            viewModel.location = location
        }
    }
    
}

#Preview {
    DailyView(viewModel: PreviewModels.dailyViewModel)
        .environmentObject(Place.default)
}
