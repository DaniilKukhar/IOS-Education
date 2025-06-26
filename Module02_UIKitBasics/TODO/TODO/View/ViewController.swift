//
//  ViewController.swift
//  TODO
//
//  Created by Daniil Kukhar on 6/25/25.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Variables
    private var tasks: [Task] = [
        Task(title: "Upload 1099-R to TurboTax", category: "Finance", icon: "💰", isCompleted: false),
        Task(title: "Submit 2019 tax return", category: "Finance", icon: "💰", isCompleted: false),
        Task(title: "Print parking passes", category: "Wedding", icon: "💞", isCompleted: false),
        Task(title: "Sign contract, send back", category: "Freelance", icon: "💻", isCompleted: false),
        Task(title: "Hand sanitizer", category: "Shopping List", icon: "🛒", isCompleted: false),
        Task(title: "Check on FedEx Order", category: "Shopping List", icon: "🛒", isCompleted: true),
        Task(title: "Look at new plugins", category: "Freelance", icon: "💻", isCompleted: true),
        Task(title: "Respond to catering company", category: "Freelance", icon: "💻", isCompleted: true),
        Task(title: "Reschedule morning coffee", category: "Daily Routine", icon: "🧃", isCompleted: true),
        Task(title: "Check the latest on Community", category: "Freelance", icon: "💻", isCompleted: true)
    ]
    
    private var incompleteTasks: [Task] {
        tasks.filter { !$0.isCompleted }
    }

    private var completedTasks: [Task] {
        tasks.filter { $0.isCompleted }
    }
    
    
    //MARK: - UI Components
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "AddTask")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.delegate = self
        tableView.dataSource = self
    }

    //MARK: - Setup UI
    private func setupUI() {
        self.view.backgroundColor = .appBackground
        
        let tableViewHeader = TableViewHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 96))
        tableViewHeader.configure(with: Date(), description: "\(incompleteTasks.count) incomplete, \(completedTasks.count) completed")
        tableView.tableHeaderView = tableViewHeader
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(tableView)
        self.view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            addButton.widthAnchor.constraint(equalToConstant: 66),
            addButton.heightAnchor.constraint(equalToConstant: 66)
        ])
    }
    
    //MARK: - Actions
    @objc func addButtonTapped() {
        let modalVC = AddTaskViewController()
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        modalVC.onAddTask = { [weak self] title, category, icon in
            guard let self = self else { return }
            let newTask = Task(title: title, category: category, icon: icon, isCompleted: false)
            self.tasks.insert(newTask, at: 0)
            self.tableView.reloadData()
            
            if let header = self.tableView.tableHeaderView as? TableViewHeader {
                header.configure(with: Date(), description: "\(self.incompleteTasks.count) incomplete, \(self.completedTasks.count) completed")
            }
        }

        present(modalVC, animated: true)
    }

}

//MARK: - Helpers
extension ViewController {
    private func makeSectionHeader(title: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        
        let label = UILabel()
        label.text = title
        label.textColor = .section
        label.font = UIFont(name: "Inter-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])
        
        return container
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier) as? TaskCell else {
            return UITableViewCell()
        }
        
        let filteredTasks: [Task]
        if indexPath.section == 0 {
            filteredTasks = tasks.filter { !$0.isCompleted }
        } else {
            filteredTasks = tasks.filter { $0.isCompleted }
        }
        
        let task = filteredTasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let filteredTasks = indexPath.section == 0
            ? tasks.filter { !$0.isCompleted }
            : tasks.filter { $0.isCompleted }

        let task = filteredTasks[indexPath.row]

        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }

        tableView.reloadData()
        
        if let header = tableView.tableHeaderView as? TableViewHeader {
            header.configure(
                with: Date(),
                description: "\(incompleteTasks.count) incomplete, \(completedTasks.count) completed"
            )
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return incompleteTasks.count
        } else {
            return completedTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return makeSectionHeader(title: section == 0 ? "Incomplete" : "Completed")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let isIncomplete = indexPath.section == 0
        let filteredTasks = isIncomplete ? incompleteTasks : completedTasks
        let taskToDelete = filteredTasks[indexPath.row]
        
        if let index = tasks.firstIndex(where: { $0.id == taskToDelete.id }) {
            tasks.remove(at: index)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if let header = tableView.tableHeaderView as? TableViewHeader {
                header.configure(with: Date(), description: "\(incompleteTasks.count) incomplete, \(completedTasks.count) completed")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let isCompleted = section == 1
        return isCompleted ? 40 : 61
    }
}

#Preview {
    UINavigationController(rootViewController: ViewController())
}

