//
//  MapViewController.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 27.10.2025.
//

import UIKit
import CoreLocation
import MapKit

final class MapViewController: UIViewController, LocationChangeEmitter {
    
    var viewModel: MapViewModel
    var locationDidChangeHandler: ((CLLocation) -> Void)?
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = .clear
        button.layer.cornerRadius = 22
        return button
    }()
    
    var mapView: MKMapView!
    var pointAnnotation: MKPointAnnotation?
    var actionButton: UIButton!
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetupViewController()
        bindViewModel()
    }
    
}
