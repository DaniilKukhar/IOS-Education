//
//  AddTaskViewController.swift
//  TODO
//
//  Created by Daniil Kukhar on 6/25/25.
//

import UIKit

final class AddTaskViewController: UIViewController {
    
    //MARK: - Variables
    var onAddTask: ((String, String, String) -> Void)?
    
    //MARK: - UI Components
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Task title"
        titleLabel.font = UIFont(name: "Inter-Medium", size: 18)
        titleLabel.textColor = .label
        return titleLabel
    }()
    
    let categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont(name: "Inter-Medium", size: 18)
        categoryLabel.textColor = .label
        return categoryLabel
    }()
    
    let iconLabel: UILabel = {
        let iconLabel = UILabel()
        iconLabel.text = "Icon"
        iconLabel.font = UIFont(name: "Inter-Medium", size: 18)
        iconLabel.textColor = .label
        return iconLabel
    }()
    
    let titleField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Enter task"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let categoryField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter category"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let iconField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter icon (e.g. 💻)"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Task", for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        titleField.delegate = self
        categoryField.delegate = self
        iconField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, titleField])
        titleStack.axis = .vertical
        titleStack.spacing = 4

        let categoryStack = UIStackView(arrangedSubviews: [categoryLabel, categoryField])
        categoryStack.axis = .vertical
        categoryStack.spacing = 4

        let iconStack = UIStackView(arrangedSubviews: [iconLabel, iconField])
        iconStack.axis = .vertical
        iconStack.spacing = 4

        let stack = UIStackView(arrangedSubviews: [titleStack, categoryStack, iconStack])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        
        view.addSubview(stack)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 24),
            addButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func addTaskTapped() {
        guard
            let title = titleField.text, !title.isEmpty,
            let category = categoryField.text, !category.isEmpty,
            let icon = iconField.text, !icon.isEmpty
        else {
            return
        }
        
        onAddTask?(title, category, icon)
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
