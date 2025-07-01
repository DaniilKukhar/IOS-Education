//
//  CalcButtonCell.swift
//  CalculatorUIKit
//
//  Created by Daniil Kukhar on 6/30/25.
//

import UIKit

class CalcButtonCell: UICollectionViewCell {
    
    static let identifier = "CalcButtonCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "WorkSans-Regular", size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .numberButtons
        self.layer.cornerRadius = 24
        
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configure(with button: CalcButton, backgroundColor: UIColor) {
        titleLabel.text = button.rawValue
        titleLabel.textColor = button.titleColor
        self.backgroundColor = backgroundColor
    }
}
