//
//  URLImageView.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import SwiftUI

struct URLImageView: View {
    
    @State private var image: UIImage? = nil
    let id: String?
    
    private let imageLoader = ImageDownloaderService()

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear(perform: load)
    }

    private func load() {
        guard let id else { return }
        Task {
            if let data = try? await imageLoader.data(for: id), let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        }
    }
}
