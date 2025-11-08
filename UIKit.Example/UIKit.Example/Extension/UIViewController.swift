//
//  UIViewController.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 06.11.2025.
//

import UIKit

extension UIViewController {
    
    func displayError(_ message: String) {
        let alertViewController = UIAlertController(title: "Error:", message: message, preferredStyle: .alert)
        alertViewController.addAction(
            UIAlertAction(title: "OK", style: .default)
        )
        present(alertViewController, animated: true)
    }
    
}
