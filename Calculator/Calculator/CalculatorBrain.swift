//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Furaha Damien on 2018-05-30.
//  Copyright © 2018 curtesy of damien. All rights reserved.
// This creates an API that whose functinality we use in our program

import Foundation // the model is UI independent. we dont import UI into a model class

class CalculatorBrain {

    //enum similar to class, can have functions. no inheritance
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double) //takes a string and a function that returns a double
        case BinaryOperation(String, (Double,Double) -> Double)
        
        var description: String {
            get{
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
            
        }
    }
    
    private var OpStack = [Op]() //array of operations and operands
    
    //dictionary that holds all the opeartions that we know where the key is the symbol for the operation and the value is the actual operation
    private var knowOperations = Dictionary<String,Op>()
    
    //initializing our knownOps, using the enums
    init() {
        knowOperations["×"] = Op.BinaryOperation("×", * )
        knowOperations["÷"] = Op.BinaryOperation("÷", {$1 / $0})
        knowOperations["+"] = Op.BinaryOperation("+",  +) //Swift ApI allows us t use sqrt, * and + as functions
        knowOperations["−"] = Op.BinaryOperation("−", {$1 - $0})
        knowOperations["√"] = Op.UnaryOperation("√", sqrt)
        
    }
    //recursive function to evaluate our expression. Takes in a stack of Op returns a tuple
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return(operand,remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(ops: remainingOps)
                if let operand = operandEvaluation.result{ //check if it is a double
                    return(operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(ops: remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(ops: op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return(operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return(nil,ops)
    }
    
    func evaluate() -> Double? {//retun optional in case no input given
        let (result, remainder) = evaluate(ops: OpStack)
        print("\(OpStack) = \(String(describing: result)) with \(remainder) left over ")
        return result
    }
    
    //a function to push operands on the stack
    func PushOperand(operand: Double) -> Double {
        OpStack.append(Op.Operand(operand)) //creating an enum and associate a value with it
        return evaluate()!
    }
    
    //function for performing operation
    func performOperation(symbol: String) -> Double {
        //push to the stack if we get the operation
        if let operation = knowOperations[symbol]{
            OpStack.append(operation)
        }
        return evaluate()!
    }
}
