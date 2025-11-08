//
//  LocationView.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 26.10.2025.
//

import UIKit

final class LocationView: UIView {

    lazy var textLabel: UILabel = {
        let instance = UILabel()
        instance.translatesAutoresizingMaskIntoConstraints = false
        instance.font = .systemFont(ofSize: 13.0, weight: .regular)
        instance.textColor = .label
        instance.textAlignment = .center
        instance.numberOfLines = 0
        return instance
    }()
    
    lazy var changeButton: UIButton = {
        let instance = UIButton()
        instance.translatesAutoresizingMaskIntoConstraints = false
        instance.backgroundColor = .systemBlue
        instance.setImage(.init(systemName: "location.circle"), for: .normal)
        instance.tintColor = .label
        instance.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        instance.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        instance.layer.cornerRadius = 6.0
        instance.layer.masksToBounds = true
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
    
}

private extension LocationView {
    
    func setup() {
        let contentStack = UIStackView(arrangedSubviews: [textLabel, changeButton])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        contentStack.alignment = .fill
        contentStack.distribution = .fill
        contentStack.spacing = 8.0
        addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            widthAnchor.constraint(equalTo: contentStack.widthAnchor, constant: 32.0),
            heightAnchor.constraint(equalTo: contentStack.heightAnchor, constant: 16.0),
        ])
    }
    
}
