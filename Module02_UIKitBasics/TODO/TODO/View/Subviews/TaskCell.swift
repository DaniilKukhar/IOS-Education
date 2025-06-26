//
//  TaskCell.swift
//  TODO
//
//  Created by Daniil Kukhar on 6/25/25.
//

import UIKit

class TaskCell: UITableViewCell {
    static let identifier = "TaskCell"
    
    private let checkbox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Completed"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Medium", size: 18)
        label.textColor = .white
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-SemiBold", size: 14)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        let stack = UIStackView(arrangedSubviews: [titleLabel, categoryLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        
        let container = UIStackView(arrangedSubviews: [checkbox, stack])
        container.axis = .horizontal
        container.alignment = .leading
        container.spacing = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with task: Task) {
        titleLabel.text = task.title
        checkbox.setImage(task.isCompleted ? .selectedCheckbox : .checkbox, for: .normal)
        checkbox.tintColor = task.isCompleted ? .systemBlue : .white
        titleLabel.textColor = task.isCompleted ? .completedRowTitle : .incompleteRowTitle
        
        if task.isCompleted {
            categoryLabel.isHidden = true
        } else {
            categoryLabel.isHidden = false
            categoryLabel.text = "\(task.icon) \(task.category)"
            categoryLabel.textColor = .rowDescription
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
