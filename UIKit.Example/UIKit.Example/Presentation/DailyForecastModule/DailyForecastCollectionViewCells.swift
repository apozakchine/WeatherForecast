//
//  DailyForecastCollectionViewCells.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 07.11.2025.
//

import UIKit

extension CGFloat {
    static let tableViewRowHeight: CGFloat = 48.0
}

// MARK: - Cells for Daily CollectionView
struct DailyForecastCollectionViewCells {

    // MARK: - Main Cell
    final class Main: UICollectionViewCell {
        
        var imageLoader = ImageDownloaderService()
        
        private lazy var dateLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.textAlignment = .center
            instance.font = .preferredFont(forTextStyle: .headline)
            instance.textColor = .label
            return instance
        }()
        
        private lazy var sunriseImageView: UIImageView = {
            let instance = UIImageView(image: .init(systemName: "sunrise"))
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.tintColor = .label
            instance.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return instance
        }()

        private lazy var sunsetImageView: UIImageView = {
            let instance = UIImageView(image: .init(systemName: "sunset"))
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.tintColor = .label
            instance.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return instance
        }()

        private lazy var sunriseLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.setContentHuggingPriority(.defaultLow, for: .horizontal)
            instance.font = .preferredFont(forTextStyle: .footnote)
            instance.textColor = .label
            return instance
        }()

        private lazy var sunsetLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.setContentHuggingPriority(.defaultLow, for: .horizontal)
            instance.font = .preferredFont(forTextStyle: .footnote)
            instance.textAlignment = .right
            instance.textColor = .label
            return instance
        }()

        private lazy var fullDateFormatter: DateFormatter = {
            let instance = DateFormatter()
            instance.timeZone = .current
            instance.dateStyle = .long
            return instance
        }()

        private let shortTimeFormatter: DateFormatter = .custom(timezone: .current, format: "HH:mm")
        
        private lazy var tableView: UITableView = {
            let instance = UITableView()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.backgroundColor = .secondarySystemBackground
            instance.separatorStyle = .singleLine
            instance.separatorInset = .zero
            instance.layoutMargins = .zero
            instance.rowHeight = .tableViewRowHeight
            instance.tableFooterView = UIView()
            instance.delegate = self
            if #available(iOS 15.0, *) {
                instance.sectionHeaderTopPadding = 0.0
            }
            instance.register(cell: Cell.self)
            return instance
        }()
        
        fileprivate lazy var dataSource: UITableViewDiffableDataSource<Int, DailyCollectionViewModel.Item> = {
            return UITableViewDiffableDataSource(
                tableView: tableView) { tableView, indexPath, viewModel in
                    let cell = tableView.dequeueReusableCell(for: Cell.self, at: indexPath)
                    cell.layout(viewModel: viewModel)
                    return cell
                }
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func layout(viewModel: DailyCollectionViewModel) {
            dateLabel.text = fullDateFormatter.string(from: viewModel.date)
            sunriseLabel.text = shortTimeFormatter.string(from: viewModel.sunrise)
            sunsetLabel.text = shortTimeFormatter.string(from: viewModel.sunset)
            applySnapshot(items: viewModel.items)
        }
        
        private func setup() {
            let contentBackgroundView = UIView()
            contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            contentBackgroundView.layer.cornerRadius = 12.0
            contentBackgroundView.layer.masksToBounds = true
            contentBackgroundView.backgroundColor = .secondarySystemBackground
            contentView.addSubview(contentBackgroundView)
            NSLayoutConstraint.activate([
                contentBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                contentBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32.0),
                contentBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                contentBackgroundView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -16.0),
            ])
            
            let leftStackView = UIStackView(arrangedSubviews: [sunriseImageView, sunriseLabel])
            leftStackView.translatesAutoresizingMaskIntoConstraints = false
            leftStackView.axis = .horizontal
            leftStackView.spacing = 12.0
            leftStackView.alignment = .bottom
            leftStackView.distribution = .fill

            let rightStackView = UIStackView(arrangedSubviews: [sunsetLabel, sunsetImageView])
            rightStackView.translatesAutoresizingMaskIntoConstraints = false
            rightStackView.axis = .horizontal
            rightStackView.spacing = 12.0
            rightStackView.alignment = .bottom
            rightStackView.distribution = .fill
            
            let sunStackView = UIStackView(arrangedSubviews: [leftStackView, UIView(), rightStackView])
            sunStackView.translatesAutoresizingMaskIntoConstraints = false
            sunStackView.axis = .horizontal
            sunStackView.alignment = .center
            sunStackView.distribution = .fill
            
            let contentStackView = UIStackView(arrangedSubviews: [dateLabel, sunStackView])
            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.axis = .vertical
            contentStackView.alignment = .fill
            contentStackView.distribution = .fill
            contentStackView.spacing = 8.0
            contentBackgroundView.addSubview(contentStackView)
            NSLayoutConstraint.activate([
                contentStackView.centerXAnchor.constraint(equalTo: contentBackgroundView.centerXAnchor),
                contentStackView.widthAnchor.constraint(equalTo: contentBackgroundView.widthAnchor, constant: -32.0),
                contentStackView.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: 16.0)
            ])
            
            contentBackgroundView.addSubview(tableView)
            NSLayoutConstraint.activate([
                tableView.centerXAnchor.constraint(equalTo: contentBackgroundView.centerXAnchor),
                tableView.widthAnchor.constraint(equalTo: contentBackgroundView.widthAnchor),
                tableView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 32.0),
                tableView.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor)
            ])
        }
        
        private func applySnapshot(items: [DailyCollectionViewModel.Item]) {
            var snapshot = NSDiffableDataSourceSnapshot<Int, DailyCollectionViewModel.Item>()
            snapshot.appendSections([0])
            snapshot.appendItems(items, toSection: 0)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
        
    }
    
    // MARK: - Hour TableView Cell
    private final class Cell: UITableViewCell {
        
        // MARK: - Parameter View
        //         Shown parameters:
        //            - temperature
        //            - wind
        //            - clouds
        private final class ParameterView: UIView {
            
            var keyPath: KeyPath<DailyCollectionViewModel.Item, Double>
            
            var measureDescription: String
            
            lazy var imageView: UIImageView = {
                let instance = UIImageView()
                instance.translatesAutoresizingMaskIntoConstraints = false
                instance.contentMode = .scaleAspectFit
                return instance
            }()
            
            private lazy var textLabel: UILabel = {
                let instance = UILabel()
                instance.translatesAutoresizingMaskIntoConstraints = false
                instance.textAlignment = .center
                instance.textColor = .label
                instance.font = .preferredFont(forTextStyle: .footnote)
                return instance
            }()
            
            private lazy var formatter: NumberFormatter = {
                let instance = NumberFormatter()
                instance.numberStyle = .decimal
                instance.maximumFractionDigits = 0
                return instance
            }()

            override var intrinsicContentSize: CGSize {
                return .init(width: .tableViewRowHeight, height: .tableViewRowHeight)
            }
            
            init(keyPath: KeyPath<DailyCollectionViewModel.Item, Double>, measureDescription: String = "") {
                self.keyPath = keyPath
                self.measureDescription = measureDescription
                super.init(frame: .zero)
                setup()
            }
            
            @available(*, unavailable)
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            func layout(viewModel: DailyCollectionViewModel.Item) {
                if let text = formatter.string(from: NSNumber(value: viewModel[keyPath: keyPath])) {
                    textLabel.text = "\(text)\(measureDescription)"
                } else {
                    textLabel.text = "-"
                }
            }
            
            private func setup() {
                let contentStackView = UIStackView(arrangedSubviews: [imageView, textLabel])
                contentStackView.translatesAutoresizingMaskIntoConstraints = false
                contentStackView.axis = .vertical
                contentStackView.spacing = 2.0
                contentStackView.alignment = .center
                contentStackView.distribution = .fill
                addSubview(contentStackView)
                NSLayoutConstraint.activate([
                    contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
            }
            
        }
        
        // MARK: - Weather View
        //         (title and description)
        private final class WeatherView: UIView {
            
            private lazy var textLabel: UILabel = {
                let instance = UILabel()
                instance.translatesAutoresizingMaskIntoConstraints = false
                instance.textAlignment = .center
                instance.font = .preferredFont(forTextStyle: .footnote)
                instance.textColor = .label
                return instance
            }()

            private var descriptionLabel: UILabel = {
                let instance = UILabel()
                instance.translatesAutoresizingMaskIntoConstraints = false
                instance.textAlignment = .center
                instance.font = .preferredFont(forTextStyle: .footnote)
                instance.textColor = .label
                return instance
            }()
            
            override init(frame: CGRect) {
                super.init(frame: frame)
                setup()
            }
            
            @available(*, unavailable)
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            func layout(viewModel: DailyCollectionViewModel.Item) {
                textLabel.text = viewModel.name
                descriptionLabel.text = viewModel.description == nil ? nil : "(\(viewModel.description!))"
            }

            private func setup() {
                let contentStackView = UIStackView(arrangedSubviews: [textLabel, descriptionLabel])
                contentStackView.translatesAutoresizingMaskIntoConstraints = false
                contentStackView.axis = .vertical
                contentStackView.alignment = .center
                contentStackView.distribution = .fill
                addSubview(contentStackView)
                NSLayoutConstraint.activate([
                    contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    heightAnchor.constraint(equalTo: contentStackView.heightAnchor, constant: 16.0)
                ])
            }

        }
        
        // MARK: - Time View
        //         Time and weather icon
        private final class TimeView: UIView {
            
            private lazy var imageView: UIImageView = {
                let instance = UIImageView()
                instance.translatesAutoresizingMaskIntoConstraints = false
                instance.widthAnchor.constraint(equalToConstant: .tableViewRowHeight * 0.4).isActive = true
                instance.heightAnchor.constraint(equalToConstant: .tableViewRowHeight * 0.4).isActive = true
                instance.contentMode = .scaleAspectFit
                return instance
            }()
            
            private lazy var textLabel: UILabel = {
                let instance = UILabel()
                instance.translatesAutoresizingMaskIntoConstraints = false
                instance.font = .preferredFont(forTextStyle: .subheadline)
                instance.textColor = .label
                return instance
            }()

            private let formatter: DateFormatter = .custom(timezone: .current, format: "HH:mm")

            override init(frame: CGRect) {
                super.init(frame: frame)
                setup()
            }
            
            @available(*, unavailable)
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            func layout(viewModel: DailyCollectionViewModel.Item) {
                textLabel.text = formatter.string(from: viewModel.time)
            }
            
            func layout(image: UIImage) {
                imageView.image = image
            }

            private func setup() {
                let contentStackView = UIStackView(arrangedSubviews: [imageView, textLabel])
                contentStackView.translatesAutoresizingMaskIntoConstraints = false
                contentStackView.spacing = 4.0
                contentStackView.axis = .vertical
                contentStackView.alignment = .center
                contentStackView.distribution = .fill
                addSubview(contentStackView)
                NSLayoutConstraint.activate([
                    contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    widthAnchor.constraint(equalTo: contentStackView.widthAnchor, constant: 16.0),
                    heightAnchor.constraint(equalTo: contentStackView.heightAnchor)
                ])
            }

        }
        
        private lazy var timeView: TimeView = {
            let instance = TimeView()
            instance.translatesAutoresizingMaskIntoConstraints = false
            return instance
        }()
        
        private lazy var weatherView: WeatherView = {
            let instance = WeatherView()
            instance.translatesAutoresizingMaskIntoConstraints = false
            return instance
        }()
        
        private lazy var cloudParameter: ParameterView = {
            let instance = ParameterView(keyPath: \.cloud, measureDescription: "%")
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.imageView.image = .init(systemName: "cloud")
            return instance
        }()

        private lazy var windParameter: ParameterView = {
            let instance = ParameterView(keyPath: \.wind, measureDescription: "m/s")
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.imageView.image = .init(systemName: "wind")
            return instance
        }()

        private lazy var temperatureParameter: ParameterView = {
            let instance = ParameterView(keyPath: \.temperature, measureDescription: "%")
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.imageView.image = .init(systemName: "thermometer.variable")
            return instance
        }()
        
        private var parameters: [ParameterView] {
            return [cloudParameter, windParameter, temperatureParameter]
        }
        
        private var arrangedViews: [UIView] {
            return [timeView, weatherView] + parameters
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func layout(viewModel: DailyCollectionViewModel.Item) {
            timeView.layout(viewModel: viewModel)
            weatherView.layout(viewModel: viewModel)
            parameters.forEach({ $0.layout(viewModel: viewModel) })
        }
        
        func layout(image: UIImage) {
            timeView.layout(image: image)
        }
        
        private func setup() {
            selectionStyle = .none
            contentView.backgroundColor = .secondarySystemBackground
            
            let contentStackView = UIStackView(arrangedSubviews: arrangedViews)
            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.axis = .horizontal
            contentStackView.spacing = 4.0
            contentStackView.alignment = .center
            contentStackView.distribution = .fill
            contentView.addSubview(contentStackView)
            NSLayoutConstraint.activate([
                contentStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                contentStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32.0),
                contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
        
    }
    
}

extension DailyForecastCollectionViewCells.Main: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath)
    {
        guard let identificator = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        guard let imageId = identificator.imageId else {
            return
        }
        guard let cell = cell as? DailyForecastCollectionViewCells.Cell else {
            return
        }
        Task {
            if let data = try? await imageLoader.data(for: imageId), let image = UIImage(data: data) {
                await MainActor.run {
                    cell.layout(image: image)
                }
            }
        }
    }
    
}
