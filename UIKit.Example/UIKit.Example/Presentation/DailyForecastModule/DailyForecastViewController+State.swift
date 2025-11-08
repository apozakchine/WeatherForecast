//
//  DailyForecastViewController+State.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 06.11.2025.
//

import Foundation

extension DailyForecastViewController {

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            apply(state: state)
        }
    }
    
    @MainActor
    func apply(state: DailyViewModelState) {
        switch state {
        case .initial:
            startLoading()
        case let .weatherFetched(name, viewModels):
            endLoading()
            titleLabel.text = name
            applySnapshot(viewModels: viewModels)
            if viewModels.isEmpty {
                collectionView.isHidden = true
            } else {
                collectionView.isHidden = false
                collectionView.scrollToItem(at: .init(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            }
            updatePageControl()
        case let .error(error):
            endLoading()
            displayError(error.localizedDescription)
        }
    }
    
    func startTask(_ operation: @escaping () async -> Void) {
        let task = Task {
            await operation()
        }
        tasks.append(task)
    }

}
