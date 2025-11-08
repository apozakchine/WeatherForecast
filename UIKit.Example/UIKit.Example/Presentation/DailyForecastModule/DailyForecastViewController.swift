//
//  DailyForecastViewController.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 06.11.2025.
//

import UIKit

final class DailyForecastViewController: UIViewController {
    
    let viewModel: DailyViewModel
    var tasks: [Task<Void, Never>] = []
    
    var token: ObservationToken!
    var center: ObservationCenter?
    
    var dataSource: UICollectionViewDiffableDataSource<Int, DailyCollectionViewModel>!
    
    // MARK: UI Elements
    var activityIndicator: UIActivityIndicatorView!
    var titleLabel: UILabel!
    var collectionView: UICollectionView!
    var pageControl: UIPageControl!

    init(viewModel: DailyViewModel, center: ObservationCenter?) {
        self.viewModel = viewModel
        self.center = center
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stop()
        tasks.forEach({ $0.cancel() })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetupViewController()
        updatePageControl()
        createDataSource()
        bindViewModel()
        start()
    }

}
