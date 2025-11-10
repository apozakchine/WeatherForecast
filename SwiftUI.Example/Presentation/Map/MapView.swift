//
//  MapView.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 09.11.2025.
//

import SwiftUI

struct MapView: View {
     
    @EnvironmentObject var place: Place
    @StateObject var viewModel: MapViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State var isButtonDisabled: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                MKMapViewWrapper(location: viewModel.initialLocation) { location in
                    viewModel.state = .changed(location)
                }
                ActionButton(geometry: geometry,
                             inset: 0.0,
                             title: "Select",
                             isDisabled: isButtonDisabled) {
                    updateLocationIfNeededAndDismiss()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.background)
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .onChange(of: viewModel.state) { _, _ in
            onViewModelStateChange()
        }
    }
    
    private func updateLocationIfNeededAndDismiss() {
        if let location = viewModel.updatedLocation {
            let newPlace = Place(location: location)
            place.update(newPlace)
        }
        dismiss()
    }
}

#Preview {
    MapView(viewModel: PreviewModels.mapViewModel)
        .environmentObject(Place.default)
}
