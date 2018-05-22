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
        
        switch operation {
            case "×":performOperation(operation: {$0 * $1})
            
            case "÷":performOperation(operation: {$1 / $0})

            case "+":performOperation(operation: {$0 + $1})

            case "−":performOperation(operation: {$1 - $0})
            
            case "√":performOperation(operation: {sqrt($0)})
            
            default: break
        }
    }
    
    //function to perform our operations depending on the operation given
    func performOperation(operation: (Double,Double)->Double){ //operation is a function that takes two doubles and returns a double
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast() , operandStack.removeLast())
            enter() //gets the values of the operation automatically
        }
    }
    
    func performOperation(operation: (Double)->Double){ //operation is a function that takes two doubles and returns a double
        if operandStack.count >= 1{
            displayValue = operation(operandStack.removeLast())
            enter() //gets the values of the operation automatically
        }
    }
    
    
   
    
    var operandStack = Array<Double>() //stack to keep our numbers
    
    @IBAction func enter() {
        userIsInTheMiddleOfTyping = false
        operandStack.append(displayValue)
        print("operand Stack = \(operandStack)")
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

