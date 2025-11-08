//
//  WeatherForecastTableViewCells.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 31.10.2025.
//

import UIKit

struct WeatherForecastTableViewCells {
    
    final class Weather: UITableViewCell {
        
        final private class CollectionCell: UICollectionViewCell {
            
            private lazy var textLabel: UILabel = {
                let instance = UILabel()
                instance.translatesAutoresizingMaskIntoConstraints = false
                instance.font = .preferredFont(forTextStyle: .headline)
                instance.textColor = .label
                return instance
            }()

            private lazy var descriptionLabel: UILabel = {
                let instance = UILabel()
                instance.translatesAutoresizingMaskIntoConstraints = false
                instance.font = .preferredFont(forTextStyle: .subheadline)
                instance.textColor = .label
                return instance
            }()

            override init(frame: CGRect) {
                super.init(frame: frame)
                contentView.backgroundColor = .secondarySystemBackground
                contentView.layer.cornerRadius = 8.0
                contentView.layer.masksToBounds = true
                
                let stackView = UIStackView(arrangedSubviews: [textLabel, descriptionLabel])
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.axis = .vertical
                stackView.alignment = .leading
                stackView.distribution = .fill
                
                contentView.addSubview(stackView)
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
                    stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
                    stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0)
                ])
            }
            
            @available(*, unavailable)
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            func configure(item: ForecastResponse.Weather) {
                textLabel.text = item.main
                descriptionLabel.text = item.description
            }
        }
        
        struct ViewModel {
            let items: [ForecastResponse.Weather]
        }
        
        private var collectionView: UICollectionView!
        private var dataSource: UICollectionViewDiffableDataSource<Int, ForecastResponse.Weather>!
        
        private var viewModel: ViewModel = .init(items: [])
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(items: [ForecastResponse.Weather]) {
            viewModel = .init(items: items)
            var snapshot = NSDiffableDataSourceSnapshot<Int, ForecastResponse.Weather>()
            snapshot.appendSections([0])
            snapshot.appendItems(viewModel.items, toSection: 0)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
        
        private func setup() {
            selectionStyle = .none
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumLineSpacing = 8.0
            flowLayout.minimumInteritemSpacing = 8.0
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = .init(
                width: UIScreen.main.bounds.width * 0.75,
                height: 64.0
            )

            collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.alwaysBounceHorizontal = true
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(cell: CollectionCell.self)
            
            dataSource = UICollectionViewDiffableDataSource(
                collectionView: collectionView,
                cellProvider: { collectionView, indexPath, identifier in
                    let cell = collectionView.dequeueReusableCell(for: CollectionCell.self, at: indexPath)
                    cell.configure(item: identifier)
                    return cell
                }
            )
            
            contentView.addSubview(collectionView)
            NSLayoutConstraint.activate([
                collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                collectionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                collectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
                contentView.heightAnchor.constraint(equalToConstant: 64.0)
            ])
        }

    }

    final class Main: UITableViewCell {
        
        private lazy var cellImageView: UIImageView = {
            let instance = UIImageView(image: .init(systemName: "thermometer.variable"))
            instance.translatesAutoresizingMaskIntoConstraints = false
            return instance
        }()
        
        private lazy var temperatureLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.font = .preferredFont(forTextStyle: .headline)
            instance.textColor = .label
            return instance
        }()

        private lazy var minimumLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.font = .preferredFont(forTextStyle: .footnote)
            instance.textColor = .label
            return instance
        }()

        private lazy var maximumLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.font = .preferredFont(forTextStyle: .footnote)
            instance.textColor = .label
            return instance
        }()

        private lazy var feelslikeLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.font = .preferredFont(forTextStyle: .footnote)
            instance.textColor = .label
            return instance
        }()
        
        private lazy var formatter: NumberFormatter = {
            let instance = NumberFormatter()
            instance.numberStyle = .decimal
            instance.maximumFractionDigits = 0
            return instance
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(value: ForecastResponse.Main) {
            temperatureLabel.text = "\(formatter.string(from: NSNumber(value: value.temp)) ?? " - ")º"
            minimumLabel.text = "min: \(formatter.string(from: NSNumber(value: value.temp_min)) ?? " - ")º"
            maximumLabel.text = "max: \(formatter.string(from: NSNumber(value: value.temp_max)) ?? " - ")º"
            feelslikeLabel.text = "Feels like: \(formatter.string(from: NSNumber(value: value.feels_like)) ?? " - ")º"
        }
        
        private func setup() {
            selectionStyle = .none
            contentView.backgroundColor = .secondarySystemBackground
            contentView.layer.cornerRadius = 8.0
            contentView.layer.masksToBounds = true
            
            let topStackView = UIStackView(arrangedSubviews: [minimumLabel, temperatureLabel, maximumLabel])
            topStackView.translatesAutoresizingMaskIntoConstraints = false
            topStackView.axis = .horizontal
            topStackView.spacing = 12.0
            topStackView.alignment = .center
            topStackView.distribution = .equalCentering
            
            let textStackView = UIStackView(arrangedSubviews: [topStackView, feelslikeLabel])
            textStackView.translatesAutoresizingMaskIntoConstraints = false
            textStackView.axis = .vertical
            textStackView.spacing = 2.0
            textStackView.alignment = .center
            textStackView.distribution = .fill
            
            let contentStackView = UIStackView(arrangedSubviews: [cellImageView, textStackView])
            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.axis = .horizontal
            contentStackView.spacing = 8.0
            contentStackView.alignment = .center
            contentStackView.distribution = .fill

            contentView.addSubview(contentStackView)
            NSLayoutConstraint.activate([
                contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
                contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
                contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                contentView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, constant: 32.0)
            ])
        }

    }

    final class Wind: UITableViewCell {
        
        private lazy var cellImageView: UIImageView = {
            let instance = UIImageView(image: .init(systemName: "wind"))
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return instance
        }()
        
        private lazy var speedLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.setContentHuggingPriority(.defaultLow, for: .horizontal)
            instance.textAlignment = .center
            instance.font = .preferredFont(forTextStyle: .headline)
            instance.textColor = .label
            return instance
        }()

        private lazy var degreesLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.textAlignment = .right
            instance.font = .preferredFont(forTextStyle: .footnote)
            instance.textColor = .label
            return instance
        }()

        private lazy var gustLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.textAlignment = .right
            instance.font = .preferredFont(forTextStyle: .footnote)
            instance.textColor = .label
            return instance
        }()

        private lazy var formatter: NumberFormatter = {
            let instance = NumberFormatter()
            instance.numberStyle = .decimal
            instance.maximumFractionDigits = 0
            return instance
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(value: ForecastResponse.Wind) {
            speedLabel.text = "Speed: \(formatter.string(from: NSNumber(value: value.speed)) ?? " - ")m/s"
            degreesLabel.text = "direction: \(formatter.string(from: NSNumber(value: value.deg)) ?? " - ")º"
            gustLabel.text = "gust: \(formatter.string(from: NSNumber(value: value.gust)) ?? " - ")m/s"
        }
        
        private func setup() {
            selectionStyle = .none
            contentView.backgroundColor = .secondarySystemBackground
            contentView.layer.cornerRadius = 8.0
            contentView.layer.masksToBounds = true
            
            let rightStackView = UIStackView(arrangedSubviews: [degreesLabel, gustLabel])
            rightStackView.translatesAutoresizingMaskIntoConstraints = false
            rightStackView.axis = .vertical
            rightStackView.spacing = 2.0
            rightStackView.alignment = .fill
            rightStackView.distribution = .fill
            
            let contentStackView = UIStackView(arrangedSubviews: [cellImageView, speedLabel, rightStackView])
            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.axis = .horizontal
            contentStackView.spacing = 8.0
            contentStackView.alignment = .center
            contentStackView.distribution = .fill

            contentView.addSubview(contentStackView)
            NSLayoutConstraint.activate([
                contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
                contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
                contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                contentView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, constant: 32.0)
            ])
        }

    }

    final class Clouds: UITableViewCell {
        
        private lazy var cellImageView: UIImageView = {
            let instance = UIImageView(image: .init(systemName: "cloud"))
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return instance
        }()
        
        private lazy var titleLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.setContentHuggingPriority(.defaultLow, for: .horizontal)
            instance.textAlignment = .center
            instance.font = .preferredFont(forTextStyle: .headline)
            instance.textColor = .label
            return instance
        }()

        private lazy var formatter: NumberFormatter = {
            let instance = NumberFormatter()
            instance.numberStyle = .decimal
            instance.maximumFractionDigits = 0
            return instance
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(value: ForecastResponse.Clouds) {
            titleLabel.text = "Cloudness: \(formatter.string(from: NSNumber(value: value.all)) ?? " - ")%"
        }
        
        private func setup() {
            selectionStyle = .none
            contentView.backgroundColor = .secondarySystemBackground
            contentView.layer.cornerRadius = 8.0
            contentView.layer.masksToBounds = true
            
            let contentStackView = UIStackView(arrangedSubviews: [cellImageView, titleLabel])
            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.axis = .horizontal
            contentStackView.alignment = .center
            contentStackView.distribution = .fill
            
            contentView.addSubview(contentStackView)
            NSLayoutConstraint.activate([
                contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
                contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
                contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                contentView.heightAnchor.constraint(equalToConstant: 64.0)
            ])
        }

    }

    final class System: UITableViewCell {
        
        private lazy var cellImageView: UIImageView = {
            let instance = UIImageView(image: .init(systemName: "sun.horizon"))
            instance.translatesAutoresizingMaskIntoConstraints = false
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

        private lazy var sunriseImageView: UIImageView = {
            let instance = UIImageView(image: .init(systemName: "sunrise"))
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.tintColor = .label
            instance.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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

        private lazy var sunriseLabel: UILabel = {
            let instance = UILabel()
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.setContentHuggingPriority(.defaultLow, for: .horizontal)
            instance.font = .preferredFont(forTextStyle: .footnote)
            instance.textAlignment = .right
            instance.textColor = .label
            return instance
        }()

        private let formatter: DateFormatter = .custom(timezone: .current, format: "HH:mm")

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(value: ForecastResponse.System) {
            sunsetLabel.text = formatter.string(from: Date(timeIntervalSince1970: value.sunset))
            sunriseLabel.text = formatter.string(from: Date(timeIntervalSince1970: value.sunrise))
        }
        
        private func setup() {
            selectionStyle = .none
            contentView.backgroundColor = .secondarySystemBackground
            contentView.layer.cornerRadius = 8.0
            contentView.layer.masksToBounds = true
            
            let elementsStackView = UIStackView(arrangedSubviews: [
                elementStackView(imageView: sunriseImageView, label: sunriseLabel),
                elementStackView(imageView: sunsetImageView, label: sunsetLabel)
            ])
            elementsStackView.translatesAutoresizingMaskIntoConstraints = false
            elementsStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            elementsStackView.spacing = 4.0
            elementsStackView.axis = .vertical
            elementsStackView.alignment = .leading
            elementsStackView.distribution = .fill
            
            let contentStackView = UIStackView(arrangedSubviews: [cellImageView, UIView(), elementsStackView])
            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.axis = .horizontal
            contentStackView.alignment = .center
            contentStackView.distribution = .fill
            
            contentView.addSubview(contentStackView)
            NSLayoutConstraint.activate([
                contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
                contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
                contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                contentView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, constant: 32.0)
            ])
        }
        
        private func elementStackView(imageView: UIImageView, label: UILabel) -> UIStackView {
            let instance = UIStackView(arrangedSubviews: [label, imageView])
            instance.translatesAutoresizingMaskIntoConstraints = false
            instance.axis = .horizontal
            instance.spacing = 12.0
            instance.alignment = .bottom
            instance.distribution = .fill
            return instance
        }

    }

}
