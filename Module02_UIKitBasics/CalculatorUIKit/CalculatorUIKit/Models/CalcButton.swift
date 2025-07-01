//
//  CalcButton.swift
//  CalculatorUIKit
//
//  Created by Daniil Kukhar on 6/30/25.
//

import UIKit

enum CalcButton: String, CaseIterable {
    case clear = "C", negate = "+/-", percent = "%"
    case divide = "÷", multiply = "×", minus = "−", plus = "+"
    case equal = "="
    case dot = ".", delete = "⌫"
    case zero = "0", one = "1", two = "2", three = "3"
    case four = "4", five = "5", six = "6"
    case seven = "7", eight = "8", nine = "9"
    
    var backgroundColor: UIColor {
        switch self {
        case .clear, .negate, .percent:
            return .binaryOperators
        case .divide, .multiply, .minus, .plus, .equal:
            return .unaryOperators
        default:
            return .numberButtons
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .clear, .negate, .percent:
            return .black
        case .divide, .multiply, .minus, .plus, .equal:
            return .white
        default:
            return .black
        }
    }
}
