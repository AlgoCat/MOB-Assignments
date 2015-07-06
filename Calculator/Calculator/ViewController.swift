//
//  ViewController.swift
//  Calculator
//
//  Created by Kitty Wu on 6/7/15.
//  Copyright (c) 2015 Kitty Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var currentResult:Double = 0
    
    
    
    var previousNumber:Double = 0
    var operationResult:Double = 0
    var previousOperation = ""
    var isLastOperationEqual = false
    var isACMode = true
    
    var display:String = "0"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        displayResult()
    }
    
    func displayError()
    {
        display = ""
        ResultLabel.text = "Error"
    }
    
    func displayResult()
    {
        var number = display.toDouble()!
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.locale = NSLocale.currentLocale()
        
        ResultLabel.text = formatter.stringFromNumber(number)
    }
    
    func displayCalcResult()
    {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.locale = NSLocale.currentLocale()
        
        ResultLabel.text = formatter.stringFromNumber(operationResult)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var clear: UIButton!
    
    @IBOutlet weak var ResultLabel: UILabel!
    
    @IBAction func Clear(sender: AnyObject) {
        previousNumber = 0
        display = "0"
        if (isACMode) {
            operationResult = 0
            previousNumber = 0
            display = "0"
            previousOperation = ""
        }
        else {
            clear.setTitle("AC", forState: .Normal)
            isACMode = true;
        }
    
        displayResult()
    }

    @IBAction func changeSign(sender: AnyObject) {
        operationResult = operationResult * -1
        
        println(display)
        displayCalcResult()
    }
    
    @IBAction func percentage(sender: AnyObject) {
        operationResult = operationResult / 100
        display = String(format: "%f", operationResult)
        println(display)
        displayCalcResult()
    }
    
    func doOperation() -> Bool
    {
        switch previousOperation {
        case "+":
            operationResult = operationResult + previousNumber
        case "-":
            operationResult = operationResult - previousNumber
        case "*":
            operationResult = operationResult * previousNumber
        case "/":
            if (previousNumber != 0) {
                operationResult = operationResult / previousNumber
            }
            else {
                return false // return fail
            }
        default:
            operationResult = previousNumber
        }
        
        return true // return sucess
    }
    
    
    @IBAction func divide(sender: AnyObject) {
        
        if display.toDouble() != nil {
            previousNumber = display.toDouble()!
        }
        var success = false
        if (!isLastOperationEqual) {
            success = doOperation()
        }
        if (success) {
            isLastOperationEqual = false
            previousOperation = "/"
            display = ""
            displayCalcResult()
        }
        else {
            displayError()
        }
    }
    
    
    @IBAction func multiply(sender: AnyObject) {
        
        if display.toDouble() != nil {
            previousNumber = display.toDouble()!
        }
        var success = false
        if (!isLastOperationEqual) {
            success = doOperation()
        }
        if (success) {
            isLastOperationEqual = false
            previousOperation = "*"
            display = ""
            displayCalcResult()
        }
        else {
            displayError()
        }
    }
    
    var temp:Double = 0
    
    @IBAction func subtract(sender: AnyObject) {
        

        if display.toDouble() != nil {
            previousNumber = display.toDouble()!
        }
        var success = false
        if (!isLastOperationEqual) {
            success = doOperation()
        }
        if (success) {
            isLastOperationEqual = false
            previousOperation = "-"
            display = ""
            displayCalcResult()
        }
        else {
            displayError()
        }    }
    
    
    
    
    @IBAction func addition(sender: AnyObject) {

        if display.toDouble() != nil {
            previousNumber = display.toDouble()!
        }
        var success = false
        if (!isLastOperationEqual) {
            success = doOperation()
        }
        if (success) {
            isLastOperationEqual = false
            previousOperation = "+"
            display = ""
            displayCalcResult()
        }
        else {
            displayError()
        }
    }
    
    @IBAction func equals(sender: AnyObject) {
        
        if display.toDouble() != nil {
            previousNumber = display.toDouble()!
        }
        // repeat last operation if possible
        var success = doOperation()
        if (success) {
            isLastOperationEqual = true
            display = ""
            displayCalcResult()
        }
        else {
            displayError()
        }

    }
    
    
    @IBAction func dot(sender: AnyObject) {
    }
    
    
    @IBAction func zero(sender: AnyObject) {
        updateDisplay("0")
    }

    
    @IBAction func one(sender: AnyObject) {
        updateDisplay("1")
        
    }
    
    
    @IBAction func two(sender: AnyObject) {
        updateDisplay("2")
    }
    
    @IBAction func three(sender: AnyObject) {
        updateDisplay("3")
    }
    
    
    @IBAction func four(sender: AnyObject) {
        updateDisplay("4")
    }
    
    @IBAction func five(sender: AnyObject) {
        updateDisplay("5")
    }
    
    @IBAction func six(sender: AnyObject) {
        updateDisplay("6")
    }
    
    
    @IBAction func seven(sender: AnyObject) {
        updateDisplay("7")
    }
    
    @IBAction func eight(sender: AnyObject) {
        updateDisplay("8")
    }
    
    @IBAction func nine(sender: AnyObject) {
       updateDisplay("9")
    }
    
    func updateDisplay(num:String) {
        display += num
        displayResult()
        isACMode = false
    
        clear.setTitle("C", forState: .Normal)
    }
}

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

