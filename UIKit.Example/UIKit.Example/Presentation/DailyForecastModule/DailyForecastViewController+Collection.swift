//
//  DailyForecastViewController+Collection.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 07.11.2025.
//

import UIKit

extension DailyForecastViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, viewModel in
                let cell = collectionView.dequeueReusableCell(
                    for: DailyForecastCollectionViewCells.Main.self,
                    at: indexPath
                )
                cell.layout(viewModel: viewModel)
                return cell
            })
    }
    
    func applySnapshot(viewModels: [DailyCollectionViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DailyCollectionViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModels, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        let width = scrollView.bounds.width
        guard width > 0, width.isFinite else { return }
        let rawPage = scrollView.contentOffset.x / width
        let page = Int(round(rawPage))
        guard page >= 0, page < viewModel.totalImagesCount, pageControl.currentPage != page else { return }
        pageControl.currentPage = page
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return collectionView.bounds.size
    }
    
}
