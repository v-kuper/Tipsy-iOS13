//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    var calculatorBrain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billTextField.delegate = self
        billTextField.keyboardType = .decimalPad
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
        guard string.rangeOfCharacter(from: allowedCharacters.inverted) == nil else {
            return false
        }
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let textWithDot = newText.replacingOccurrences(of: ",", with: ".")
        let components = textWithDot.components(separatedBy: ".")
        let filteredText = components.prefix(2).joined(separator: ".")
        
        textField.text = filteredText
        return false
    }
    
    @IBAction func tipChanged(_ sender: UIButton) {
        // Deselect all buttons
        [zeroPctButton, tenPctButton, twentyPctButton].forEach { $0?.isSelected = false }
        
        // Select the pressed one
        sender.isSelected = true
        billTextField.endEditing(true)
        
        if let buttonTitle = sender.currentTitle {
            calculatorBrain.setTip(buttonTitle)
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        billTextField.endEditing(true)
        let value = sender.value
        splitNumberLabel.text = String(format: "%.0f", value)
        calculatorBrain.setNumberOfPeople(value)
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        guard let bill = billTextField.text, !bill.isEmpty else { return }
        calculatorBrain.calculate(bill: bill)
        performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult",
           let destinationVC = segue.destination as? ResultsViewController {
            destinationVC.total = calculatorBrain.getTotal()
            destinationVC.settings = calculatorBrain.getCalculationSummary()
        }
    }
}

