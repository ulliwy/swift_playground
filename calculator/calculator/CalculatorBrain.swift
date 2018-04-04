//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Inessa Turovtseva on 4/3/18.
//  Copyright © 2018 IP. All rights reserved.
//

import Foundation

func changeSign(operand: Double) -> Double {
    return -operand
}

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

// struct has initializer for all its properties

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double) // assosiated value
        case unaryOperation((Double) -> Double) // function that takes a double and returns a double
        case binaryOperation((Double, Double) -> Double)
        case equals
//        case floatingValue
    }

    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation(changeSign),
        "×" : Operation.binaryOperation({$0 * $1}), // closure
        "÷" : Operation.binaryOperation({$0 / $1}),
        "−" : Operation.binaryOperation({$0 - $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "=" : Operation.equals,
//        "." : Operation.floatingValue
        //"×" : Operation.binaryOperation({(op1: Double, op2: Double) -> Double in
        //    return op1 * op2
        //    }),
    ]
    
    //private var enteringFloatingValue = false
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let f):
                if accumulator != nil {
                    accumulator = f(accumulator!)
                }
            case .binaryOperation(let f):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: f, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performBinaryOperation()
//            case .floatingValue:
//                break
            }
        }
    }
    
    private mutating func performBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // this function changes the propertie of this struct
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
         return accumulator
        }
    }
}
