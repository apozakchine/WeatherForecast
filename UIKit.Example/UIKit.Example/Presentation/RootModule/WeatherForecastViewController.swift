//
//  WeatherForecastViewController.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 25.10.2025.
//

import UIKit

final class WeatherForecastViewController: UIViewController {
    
    let viewModel: RootViewModel
    var tableViewModels = [RootTableViewModel]()
    
    var tasks: [Task<Void, Never>] = []
    lazy var dataSource: UITableViewDiffableDataSource<Int, RootTableViewModel> = createDataSource()
    
    var observers = [ObservationToken]()
    
    // MARK: UI Elements
    var locationView: LocationView!
    var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        tasks.forEach({ $0.cancel() })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetupViewController()
        bindViewModel()
    }
    
}
