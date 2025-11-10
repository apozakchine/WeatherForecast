//
//  ErrorAlert.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import SwiftUI

struct ErrorAlertModifier<T: LocalizedError>: ViewModifier {
    
    @Binding var error: T?
    
    let isPresented: Bool
    let title: String
    let action: () -> Void
    
    init(error: Binding<T?>, title: String, action: @escaping () -> Void) {
        self._error = error
        self.title = title
        self.isPresented = error.wrappedValue != nil
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.alert(isPresented: .constant(isPresented)) {
            alert()
        }
    }
    
    private func alert() -> Alert {
        return Alert(
            title: Text(title),
            message: Text(error?.errorDescription ?? ""),
            dismissButton: .default(Text("OK"), action: action)
        )
    }
}

extension View {
    func onError<T: LocalizedError>(
        when error: Binding<T?>,
        withTitle title: String,
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(ErrorAlertModifier(error: error, title: title, action: action))
    }
}
