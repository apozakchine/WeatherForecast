//
//  ActionButton.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import SwiftUI

struct ActionButton: View {
    
    let geometry: GeometryProxy
    let inset: CGFloat
    let title: String
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isDisabled ? Color.gray : Color.blue)
                .foregroundColor(isDisabled ? Color.black.opacity(0.5) : Color.white)
                .cornerRadius(10.0)
                .disabled(isDisabled)
        }
        .frame(width: geometry.size.width - inset)
    }
}
