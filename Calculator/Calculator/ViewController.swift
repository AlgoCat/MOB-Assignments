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
    var operationResult:Double = 0
    
    var firstNumber:Double = 0
    var secondNumber:Double = 0
    
    var display:String = "0"
    
    var isTypingNumber:Bool = false
    var isFirstOperand:Bool = true;
    var previousOperation = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        displayResult()
        
    }
    
    
    func displayResult()
    {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.locale = NSLocale.currentLocale()
        
        ResultLabel.text = formatter.stringFromNumber(currentResult)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var clear: UIButton!
    
    @IBOutlet weak var ResultLabel: UILabel!
    
    @IBAction func Clear(sender: AnyObject) {
        currentResult = 0
        operationResult = 0
        display = "0"
        previousOperation = ""
        displayResult()
        clear.setTitle("AC", forState: .Normal)
    }

    @IBAction func changeSign(sender: AnyObject) {
        currentResult = currentResult * -1
        
        println(display)
        displayResult()
    }
    
    @IBAction func percentage(sender: AnyObject) {
        currentResult = currentResult / 100
        display = String(format: "%f", currentResult)
        println(display)
        displayResult()
        
    }
    
    
    @IBAction func divide(sender: AnyObject) {
        
        /*var temp = display.toDouble()!
        
        operationResult = operationResult / temp
        
        currentResult = operationResult
        display = ""
        
        displayResult()*/
        
    }
    
    
    @IBAction func multiply(sender: AnyObject) {
        
        /*var temp = display.toDouble()!
        
        operationResult = operationResult * temp
        
        currentResult = operationResult
        display = ""
        
        displayResult()*/
    }
    
    var temp:Double = 0
    
    @IBAction func subtract(sender: AnyObject) {
        

        
        temp = display.toDouble()!
        
        
        doOperation(temp)
        currentResult = operationResult
        previousOperation = "-"
        display = ""
        displayResult()


    }
    
    
    func doOperation(newNumber:Double)
    {
        switch previousOperation {
            case "+":
                operationResult = operationResult + newNumber
            case "-":
                operationResult = operationResult - newNumber
            default:
                operationResult = newNumber
        }
        
        
    }
    
    
    
    @IBAction func addition(sender: AnyObject) {
        
        
        temp = display.toDouble()!
        
        
        doOperation(temp)
        currentResult = operationResult
           
        
        previousOperation = "+"
        display = ""
        displayResult()
    
    }
    
    @IBAction func equals(sender: AnyObject) {
        
        temp = display.toDouble()!
        doOperation(temp)
        currentResult = operationResult

        display = ""
        displayResult()

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
        currentResult = display.toDouble()!
        displayResult()
        
        
        clear.setTitle("C", forState: .Normal)
    }
}

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

