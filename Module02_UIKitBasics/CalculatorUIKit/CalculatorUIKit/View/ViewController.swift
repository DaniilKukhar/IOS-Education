//
//  ViewController.swift
//  CalculatorUIKit
//
//  Created by Daniil Kukhar on 6/28/25.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    private var currentInput: String = "0"
    private var expression: String = ""
    private var result: Double?
    private var currentOperator: CalcButton?
    private var shouldResetInput: Bool = false
    private var hasCalculatedResult: Bool = false
    private let buttons: [CalcButton] = [
        .clear, .negate, .percent, .divide,
        .seven, .eight, .nine, .multiply,
        .four, .five, .six, .minus,
        .one, .two, .three, .plus,
        .dot, .zero, .delete, .equal
    ]
    
    // MARK: - NumberFormatter
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = ","
        return formatter
    }()
    
    // MARK: - UI Components
    private let expressionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "WorkSans-Light", size: 40)
        label.textColor = .gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "WorkSans-Light", size: 96)
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scrollSubviewDisplayLabel: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceHorizontal = false
        scroll.alwaysBounceVertical = false
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.bounces = false
        return scroll
    }()
    
    private let scrollSubviewExpressionLabel: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceHorizontal = false
        scroll.alwaysBounceVertical = false
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.bounces = false
        return scroll
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(CalcButtonCell.self, forCellWithReuseIdentifier: CalcButtonCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Display Value with didSet
    private var displayValue: String = "0" {
        didSet {
            let cleaned = displayValue.replacingOccurrences(of: ",", with: "")
            if let doubleValue = Double(cleaned) {
                displayLabel.text = formatNumber(doubleValue)
            } else {
                displayLabel.text = displayValue
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    func setupUI() {
        self.view.backgroundColor = .appBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        mainStack.addArrangedSubview(scrollSubviewExpressionLabel)
        mainStack.addArrangedSubview(scrollSubviewDisplayLabel)
        scrollSubviewExpressionLabel.addSubview(expressionLabel)
        scrollSubviewDisplayLabel.addSubview(displayLabel)
        mainStack.addArrangedSubview(collectionView)
        
        self.view.addSubview(mainStack)
        
        let collectionViewHeight = calculateCollectionViewHeight()
        
        let hConst1 = displayLabel.heightAnchor.constraint(equalTo: scrollSubviewDisplayLabel.heightAnchor)
        hConst1.isActive = true
        hConst1.priority = UILayoutPriority(rawValue: 999)
        
        let hConst2 = expressionLabel.heightAnchor.constraint(equalTo: scrollSubviewExpressionLabel.heightAnchor)
        hConst2.isActive = true
        hConst2.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            scrollSubviewExpressionLabel.heightAnchor.constraint(equalToConstant: 47),
            scrollSubviewExpressionLabel.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            scrollSubviewExpressionLabel.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            expressionLabel.topAnchor.constraint(equalTo: scrollSubviewExpressionLabel.topAnchor),
            expressionLabel.bottomAnchor.constraint(equalTo: scrollSubviewExpressionLabel.bottomAnchor),
            expressionLabel.leadingAnchor.constraint(equalTo: scrollSubviewExpressionLabel.leadingAnchor),
            expressionLabel.trailingAnchor.constraint(equalTo: scrollSubviewExpressionLabel.trailingAnchor),
            expressionLabel.widthAnchor.constraint(greaterThanOrEqualTo: scrollSubviewExpressionLabel.widthAnchor),
            
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
            
            scrollSubviewDisplayLabel.heightAnchor.constraint(equalToConstant: 96),
            scrollSubviewDisplayLabel.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            scrollSubviewDisplayLabel.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            displayLabel.topAnchor.constraint(equalTo: scrollSubviewDisplayLabel.topAnchor),
            displayLabel.bottomAnchor.constraint(equalTo: scrollSubviewDisplayLabel.bottomAnchor),
            displayLabel.leadingAnchor.constraint(equalTo: scrollSubviewDisplayLabel.leadingAnchor),
            displayLabel.trailingAnchor.constraint(equalTo: scrollSubviewDisplayLabel.trailingAnchor),
            displayLabel.widthAnchor.constraint(greaterThanOrEqualTo: scrollSubviewDisplayLabel.widthAnchor),
            
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            mainStack.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
}

// MARK: - Collection View Delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalcButtonCell.identifier, for: indexPath) as? CalcButtonCell else {
            return UICollectionViewCell()
        }
        let button = buttons[indexPath.item]
        cell.configure(with: button, backgroundColor: button.backgroundColor)
        return cell
    }
}

// MARK: - Collection View Layout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let button = buttons[indexPath.item]
        handleInput(button)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let spacing: CGFloat = 16
        
        let totalSpacing = (itemsPerRow - 1) * spacing
        let availableWidth = collectionView.frame.width - totalSpacing
        let buttonWidth = availableWidth / itemsPerRow
        
        let buttonHeight: CGFloat = 72
        
        return CGSize(width: buttonWidth, height: buttonHeight)
    }
}

// MARK: - Logic
extension ViewController {
    private func handleInput(_ button: CalcButton) {
        print("Handling input: \(button.rawValue)")
        
        switch button {
        case .clear:
            clearAll()
        case .delete:
            deleteLast()
        case .negate:
            negateValue()
        case .percent:
            percentValue()
        case .equal:
            calculate()
        case .plus, .minus, .multiply, .divide:
            applyOperator(button)
        case .dot:
            addDot()
        default:
            appendNumber(button.rawValue)
        }
        
        if button != .clear && button != .delete {
            updateDisplay()
        } else if button == .delete {
            updateDisplayText()
        }
    }
    
    private func appendToExpression(_ value: String) {
        expression += value
        
        let tokens = tokenizeExpression(expression)
        
        let formattedTokens = tokens.map { token -> String in
            if let number = Double(token.replacingOccurrences(of: ",", with: "")) {
                return numberFormatter.string(from: NSNumber(value: number)) ?? token
            }
            return token
        }
      
        displayValue = formattedTokens.joined()
    }

    private func tokenizeExpression(_ expression: String) -> [String] {
        // Патерн шукає числа з плаваючою точкою або оператори
        let pattern = #"(\d+(?:\.\d+)?|[+\-×÷])"#
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: expression, range: NSRange(expression.startIndex..., in: expression))
            return matches.map { String(expression[Range($0.range, in: expression)!]) }
        } catch {
            print("Invalid regex: \(error)")
            return []
        }
    }
    
    private func clearAll() {
        currentInput = "0"
        expression = ""
        currentOperator = nil
        result = nil
        hasCalculatedResult = false
        updateDisplayImmediate()
    }
    
    private func clearAllSilent() {
        currentInput = "0"
        expression = ""
        currentOperator = nil
        result = nil
        hasCalculatedResult = false
    }
    
    private func updateDisplayImmediate() {
        displayValue = "0"
        expressionLabel.text = ""
        scrollSubviewDisplayLabel.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    private func deleteLast() {
        if hasCalculatedResult {
            if currentInput != "0" {
                clearAll()
            }
            return
        }
        
        if !currentInput.isEmpty && currentInput != "0" {
            currentInput = String(currentInput.dropLast())
            if currentInput.isEmpty {
                currentInput = "0"
            }
        } else {
            currentInput = "0"
        }
        
        if !expression.isEmpty {
            let lastChar = String(expression.last!)
            let operators = ["+", "-", "×", "÷", "*", "/"]
            
            if operators.contains(lastChar) {
                expression = String(expression.dropLast())
                currentOperator = nil
            } else {
                expression = String(expression.dropLast())
            }
        }
    }
    
    private func percentValue() {
        let cleanedInput = currentInput.replacingOccurrences(of: ",", with: "")
        if let value = Double(cleanedInput) {
            let percent = value / 100
            let formattedPercent = formatNumber(percent)
            
            currentInput = formattedPercent
            
            let cleanedExpression = expression.replacingOccurrences(of: ",", with: "")
            if cleanedExpression.hasSuffix(cleanedInput) {
                expression = String(expression.dropLast(cleanedInput.count))
            }
            appendToExpression(formattedPercent)
            
            updateDisplayText()
            
            if hasCalculatedResult {
                result = percent
            }
        }
    }

    private func negateValue() {
        let cleanedInput = currentInput.replacingOccurrences(of: ",", with: "")
        if let doubleValue = Double(cleanedInput) {
            let negatedResult = -doubleValue
            let formattedNegated = formatNumber(negatedResult)
            currentInput = formattedNegated
            
            if hasCalculatedResult {
                result = negatedResult
                currentInput = formattedNegated
                expression = formattedNegated
                displayValue = currentInput
                hasCalculatedResult = false
            } else {
                let cleanedExpression = expression.replacingOccurrences(of: ",", with: "")
                if cleanedExpression.hasSuffix(cleanedInput) {
                    expression = String(expression.dropLast(cleanedInput.count))
                }
                appendToExpression(currentInput)
            }
        }
    }
    
    private func addDot() {
        if hasCalculatedResult {
            startNewCalculation()
            currentInput = "0."
            appendToExpression("0.")
        } else if !currentInput.contains(".") {
            currentInput += "."
            appendToExpression(".")
        }
    }
    
    private func appendNumber(_ value: String) {
        if hasCalculatedResult {
            startNewCalculation()
            currentInput = value
        } else if currentInput == "0" {
            currentInput = value
        } else {
            currentInput += value
        }
        
        appendToExpression(value)
    }
    
    private func applyOperator(_ newOperator: CalcButton) {
        if hasCalculatedResult {
            if let resultValue = result {
                let rawValue = String(resultValue)
                currentInput = rawValue
                expression = formatNumber(resultValue)
                hasCalculatedResult = false
                expressionLabel.text = ""
            }
        }

        let cleanedInput = currentInput.replacingOccurrences(of: ",", with: "")
        
        if let value = Double(cleanedInput) {
            if result == nil {
                result = value
            } else if let currentOperator = self.currentOperator, let currentResult = result {
                let cleanedCurrentInput = currentInput.replacingOccurrences(of: ",", with: "")
                result = perform(currentOperator, currentResult, Double(cleanedCurrentInput) ?? 0)
                currentInput = String(result!)
            }

            currentOperator = newOperator
            appendToExpression(newOperator.rawValue)
            currentInput = "0"
        }
    }
    
    private func calculate() {
        let cleanedInput = currentInput.replacingOccurrences(of: ",", with: "")
        guard let lhs = result,
              let rhs = Double(cleanedInput),
              let currentOperator = self.currentOperator else { return }
        
        let final = perform(currentOperator, lhs, rhs)
        
        expressionLabel.text = expression
        
        result = final
        currentInput = final.formatted()
        displayValue = currentInput
        self.currentOperator = nil
        hasCalculatedResult = true
    }
    
    private func startNewCalculation() {
        expression = ""
        result = nil
        currentOperator = nil
        hasCalculatedResult = false
        expressionLabel.text = ""
    }
    
    private func perform(_ currentOperator: CalcButton, _ lhs: Double, _ rhs: Double) -> Double {
        switch currentOperator {
        case .plus: return lhs + rhs
        case .minus: return lhs - rhs
        case .multiply: return lhs * rhs
        case .divide: return rhs != 0 ? lhs / rhs : 0
        default: return rhs
        }
    }
    
    private func updateDisplayText() {
        displayValue = currentInput
    }
    
    private func updateDisplay(scrollToStart: Bool = false) {
        scrollSubviewDisplayLabel.layoutIfNeeded()
        let offsetX = scrollToStart ? 0 : max(0, scrollSubviewDisplayLabel.contentSize.width - scrollSubviewDisplayLabel.bounds.width)
        scrollSubviewDisplayLabel.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
    private func formatNumber(_ value: Double) -> String {
        return numberFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

// MARK: - Helpers
extension ViewController {
    func calculateCollectionViewHeight() -> CGFloat {
        let itemsPerRow: CGFloat = 4
        let spacing: CGFloat = 16
        let numberOfItems = CGFloat(buttons.count)
        let rows = ceil(numberOfItems / itemsPerRow)
        
        let buttonHeight: CGFloat = 72
        
        return rows * buttonHeight + (rows - 1) * spacing
    }
}

#Preview {
    ViewController()
}
