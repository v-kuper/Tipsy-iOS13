//
//  CalculatorBrain.swift
//  Tipsy
//
//  Created by Vitali Kupratsevich on 25.03.25.
//  Copyright © 2025 The App Brewery. All rights reserved.
//
import UIKit

struct CalculatorBrain {
    private var tip: Double = 0.10
    private var numberOfPeople: Int = 2
    private var billTotal: Double = 0.0
    
    private(set) var total: String = "0.00"
    private(set) var calculationSummary: String = ""
    
    func getTotal() -> String {
        total
    }

    func getCalculationSummary() -> String {
        calculationSummary
    }

    mutating func setTip(_ buttonTitle: String) {
        let tipString = String(buttonTitle.dropLast()) // remove '%'
        guard let tipValue = Double(tipString) else { return }
        tip = tipValue / 100
    }

    mutating func setNumberOfPeople(_ value: Double) {
        numberOfPeople = max(1, Int(value)) // safeguard against zero or negative
    }

    mutating func calculate(bill: String) {
        guard let billAmount = Double(bill) else {
            total = "0.00"
            calculationSummary = "Invalid bill amount."
            return
        }

        billTotal = billAmount
        let result = billTotal * (1 + tip) / Double(numberOfPeople)
        total = String(format: "%.2f", result)

        let tipPercent = String(format: "%.0f", tip * 100)
        calculationSummary = "Split between \(numberOfPeople) people, with \(tipPercent)% tip."
    }
}
