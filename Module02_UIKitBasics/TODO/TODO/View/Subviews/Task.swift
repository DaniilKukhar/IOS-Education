//
//  Task.swift
//  TODO
//
//  Created by Daniil Kukhar on 6/25/25.
//

import UIKit

enum TaskStatus {
    case incomplete
    case completed
}

struct Task: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let icon: String
    var isCompleted: Bool
}
