//
//  LocationView.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 09.11.2025.
//

import SwiftUI
import CoreLocation

extension CLLocation {
    static let `default`: CLLocation = .init(latitude: 55.731490, longitude: 37.637772)
}

struct LocationView: View {
    
    @EnvironmentObject var place: Place

    var onButtonTap: () -> Void
    
    var body: some View {
        if place.location == nil {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.primary))
                    .padding()
            } else {
                VStack(spacing: 8.0) {
                    Text(place.address ?? "")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 8.0)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    Button(action: onButtonTap) {
                        HStack {
                            Text("Change")
                                .font(.headline)
                            Image(systemName: "location.circle")
                                .font(.headline)
                        }
                        .padding(.horizontal, 12.0)
                        .padding(.vertical, 8.0)
                        .background(.link)
                        .foregroundColor(Color.primary)
                        .cornerRadius(16.0)
                    }
                }
                .padding(.horizontal, 16.0)
            }
        }
}

#Preview {
    LocationView(onButtonTap: {})
        .environmentObject(Place.default)
}
