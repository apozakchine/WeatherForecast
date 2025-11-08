//
//  MapViewController+UI.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 27.10.2025.
//

import UIKit
import MapKit

extension MapViewController {
    
    func initialSetupViewController() {
        title = "Select Location"
        view.backgroundColor = .systemBackground
        backButton.addTarget(self, action: #selector(backButtonTouchUpInside), for: .touchUpInside)
        navigationItem.leftBarButtonItem = .init(customView: backButton)
        
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64.0),
        ])
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .darkGray
        
        actionButton = UIButton(configuration: configuration, primaryAction: nil)
        actionButton.configurationUpdateHandler = { instance in
            switch instance.state {
            case .disabled:
                instance.configuration?.baseBackgroundColor = .lightGray
                instance.configuration?.baseForegroundColor = .darkGray
            default:
                instance.configuration?.baseBackgroundColor = .systemBlue
                instance.configuration?.baseForegroundColor = .label
            }
        }
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.layer.cornerRadius = 6.0
        actionButton.layer.masksToBounds = true
        actionButton.isEnabled = false
        actionButton.setTitle("Change", for: .normal)
        actionButton.addTarget(self, action: #selector(actionButtonTouchUpInside), for: .touchUpInside)
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32.0),
            actionButton.heightAnchor.constraint(equalToConstant: 48.0),
            actionButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 12.0)
        ])
    }
    
    @objc
    func backButtonTouchUpInside() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func actionButtonTouchUpInside() {
        guard case let .changed(location) = viewModel.state else {
            return
        }
        locationDidChangeHandler?(location)
        navigationController?.popViewController(animated: true)
    }

}
