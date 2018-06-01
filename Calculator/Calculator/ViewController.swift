//
//  ViewController.swift
//  Calculator
//
//  Created by Furaha Damien on 2018-05-21.
//  Copyright © 2018 curtesy of damien. All rights reserved.
//

import UIKit  //iOS UI impoorts

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTyping: Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping{
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
        
        
    }
    
    @IBAction func operate(_ sender: UIButton) {
        let operation  = sender.currentTitle!
        
        //we want to give the user an automatic enter when typing
        if userIsInTheMiddleOfTyping{
            enter()
        }
        if let operation = sender.currentTitle {
            if let result: Double = brain.performOperation(symbol: operation) {
                displayValue = result
            }
            else{
                displayValue = 0
            }
        }
    }
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTyping = false
        if let result:  Double = brain.PushOperand(operand: displayValue) {
            displayValue = result
        }else{
            displayValue = 0
        }
    }
    
    //getting the value of the operand
    var displayValue: Double {
        get{
            //casting the display variable from an optional to a double
            return NumberFormatter().number(from: display.text!) as! Double
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTyping = false
        }
    }
}

