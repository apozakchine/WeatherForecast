//
//  UICollectionView.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 02.11.2025.
//

import UIKit

extension UICollectionView {
    func reuseIndentifier<T>(for type: T.Type) -> String {
        return String(describing: type)
    }

    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: reuseIndentifier(for: cell))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for type: T.Type, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIndentifier(for: type), for: indexPath) as? T else {
            fatalError("Failed to dequeue cell.")
        }
        return cell
    }
}

