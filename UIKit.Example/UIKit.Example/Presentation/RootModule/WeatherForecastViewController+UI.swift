//
//  WeatherForecastViewController+UI.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 26.10.2025.
//

import UIKit

extension WeatherForecastViewController {
    
    func initialSetupViewController() {
        title = "Weather Forecast"
        view.backgroundColor = .systemBackground
        locationView = LocationView()
        locationView.translatesAutoresizingMaskIntoConstraints = false
        locationView.isHidden = true
        locationView.changeButton.addTarget(
            self,
            action: #selector(locationChangeTouchUpInside),
            for: .touchUpInside
        )
        view.addSubview(locationView)
        NSLayoutConstraint.activate([
            locationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24.0)
        ])
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 16.0
        tableView.contentInset.top = 8.0
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        tableView.register(cell: WeatherForecastTableViewCells.Weather.self)
        tableView.register(cell: WeatherForecastTableViewCells.Main.self)
        tableView.register(cell: WeatherForecastTableViewCells.Wind.self)
        tableView.register(cell: WeatherForecastTableViewCells.Clouds.self)
        tableView.register(cell: WeatherForecastTableViewCells.System.self)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 16.0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tintColor = .label
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func startLoading() {
        tableView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func endLoading() {
        tableView.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func createDataSource() -> UITableViewDiffableDataSource<Int, RootTableViewModel> {
        return UITableViewDiffableDataSource(
            tableView: tableView) { tableView, indexPath, identifier in
                switch identifier {
                case let .weather(value):
                    let cell = tableView.dequeueReusableCell(
                        for: WeatherForecastTableViewCells.Weather.self,
                        at: indexPath
                    )
                    cell.configure(items: value)
                    return cell
                case let .main(value):
                    let cell = tableView.dequeueReusableCell(
                        for: WeatherForecastTableViewCells.Main.self,
                        at: indexPath
                    )
                    cell.configure(value: value)
                    return cell
                case let .clouds(value):
                    let cell = tableView.dequeueReusableCell(
                        for: WeatherForecastTableViewCells.Clouds.self,
                        at: indexPath
                    )
                    cell.configure(value: value)
                    return cell
                case let .wind(value):
                    let cell = tableView.dequeueReusableCell(
                        for: WeatherForecastTableViewCells.Wind.self,
                        at: indexPath
                    )
                    cell.configure(value: value)
                    return cell
                case let .system(value):
                    let cell = tableView.dequeueReusableCell(
                        for: WeatherForecastTableViewCells.System.self,
                        at: indexPath
                    )
                    cell.configure(value: value)
                    return cell
                }
            }
    }
    
    func applySnapshot(response: ForecastResponse) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RootTableViewModel>()
        snapshot.appendSections([0, 1, 2, 3, 4])
        snapshot.appendItems([.weather(response.weather)], toSection: 0)
        snapshot.appendItems([.main(response.main)], toSection: 1)
        snapshot.appendItems([.wind(response.wind)], toSection: 2)
        snapshot.appendItems([.clouds(response.clouds)], toSection: 3)
        snapshot.appendItems([.system(response.sys)], toSection: 4)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    @objc
    func locationChangeTouchUpInside() {
        guard let location = viewModel.location else { return }
        let moduleFactory = MapModuleFactory(location: location)
        let viewController = moduleFactory.makeViewController()
        viewController.locationDidChangeHandler = { [weak self] location in
            self?.startTask {
                await self?.viewModel.setNewLocation(location)
            }
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension WeatherForecastViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
