//
//  TableViewHeader.swift
//  TODO
//
//  Created by Daniil Kukhar on 6/25/25.
//

import UIKit

class TableViewHeader: UIView {
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .title
         label.font = .systemFont(ofSize: 34, weight: .bold)
         label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.textColor = .description
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .divider
        view.layer.cornerRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.verticalStackView.addArrangedSubview(titleLabel)
        self.verticalStackView.addArrangedSubview(descriptionLabel)
        self.addSubview(verticalStackView)
        self.addSubview(divider)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            divider.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 2)
        ])
        
    }
    
    func configure(with date: Date, description: String? = nil) {
        titleLabel.text = formatter.string(from: date)
        descriptionLabel.text = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
