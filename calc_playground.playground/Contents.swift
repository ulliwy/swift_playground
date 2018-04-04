//: A UIKit based Playground for presenting user interface
  
import UIKit

var i = 27

func changeSign(operand: Double) -> Double {
    return -operand
}

var f: (Double) -> Double
f = changeSign
let x = f(81)

