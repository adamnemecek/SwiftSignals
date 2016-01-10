//
//  Artithmetic.swift
//  Signals
//
//  Created by Danny van Swieten on 12/14/15.
//  Copyright © 2015 Danny van Swieten. All rights reserved.
//

/// This protocol is used for arithmetic operations done by signals. If you need a signal of type T, then T has to conform to this protocol.
protocol Arithmetic {
    init()
    mutating func add(rhs: Self) -> Self
    mutating func sub(rhs: Self) -> Self
    mutating func div(rhs: Self) -> Self
    mutating func mult(rhs: Self) -> Self
    
    mutating func negate()
    mutating func increment()
    mutating func decrement()
}

/// This extends type Double to conform to Arithmetic
extension Double: Arithmetic {
    
    mutating func add(rhs: Double) -> Double {
        return self + rhs
    }
    
    mutating func sub(rhs: Double) -> Double {
        return self - rhs
    }
    
    mutating func div(rhs: Double) -> Double {
        return self / rhs
    }
    
    mutating func mult(rhs: Double) -> Double {
        return self * rhs
    }
    
    mutating func increment() {
        self++
    }
    
    mutating func decrement() {
        self--
    }
    
    mutating func negate() {
        self = -self
    }
}

/// This extends type Float to conform to Arithmetic
extension Float: Arithmetic {
    
    mutating func add(rhs: Float) -> Float {
        return self + rhs
    }
    
    mutating func sub(rhs: Float) -> Float {
        return self - rhs
    }
    
    mutating func div(rhs: Float) -> Float {
        return self / rhs
    }
    
    mutating func mult(rhs: Float) -> Float {
        return self * rhs
    }
    
    mutating func increment() {
        self++
    }
    
    mutating func decrement() {
        self--
    }
    
    mutating func negate(){
        self = -self
    }
}

/// A summing signal. The output of this signal is the sum of it's two inputs.
class Add<T:Arithmetic>: Signal<T> {
    
    override func generateSample(timestamp: Int) -> Void {
        sample = lhs![timestamp] + rhs![timestamp]
    }
    
    var lhs: Signal<T>?
    var rhs: Signal<T>?
}

class Sum<T: Arithmetic>: Signal<T> {
    
    var inputs = [Signal<T>]()
    
    init(signals: Signal<T>...) {
        
    }
    
    override func generateSample(timestamp: Int) {
        sample = T()
        for signal in inputs
        {
            sample! = sample! + signal[timestamp]
        }
    }
}

class Gain<T: Arithmetic>: Signal<T> {
    
    var lhs: Signal<T>?
    var rhs: Signal<T>?
    
    override func generateSample(timestamp: Int) -> Void {
            sample = lhs![timestamp] * rhs![timestamp]
    }
}

/// A negating signal. The output of this signal is the negated version of it's input.
class Negator<T: Arithmetic>: Signal<T> {
    
    override func generateSample(timestamp: Int) {
        sample = input![timestamp]
        sample?.negate()
    }
    
    var input: Signal<T>?
}

// Signal Arithmetic
/// This construct a Sum object by taking two signals and returning one. This ensures it is chainable.
func +<T>(lhs: Signal<T>, rhs: Signal<T>) -> Add<T> {
    
    let sum = Add<T>()
    sum.lhs = lhs
    sum.rhs = rhs
    return sum
}

/// This function is prefix minus function which takes a signal and returns a negator signal with the original as it's input
prefix func -<T: Arithmetic>(signal: Signal<T>) -> Signal<T> {
    
    let negatedSignal = Negator<T>()
    negatedSignal.input = signal
    return negatedSignal
}

func *<T>(lhs: Signal<T>, rhs: Signal<T>) -> Gain<T> {
    
    let product = Gain<T>()
    product.lhs = lhs
    product.rhs = rhs
    return product
}

// Arithmetic operator overloading for Arithmetic Type
func +<T: Arithmetic>(var lhs: T, rhs: T) -> T {
    return lhs.add(rhs)
}

func -<T: Arithmetic>(var lhs: T, rhs: T) -> T {
    return lhs.sub(rhs)
}

func /<T: Arithmetic>(var lhs: T, rhs: T) -> T {
    return lhs.div(rhs)
}

func *<T: Arithmetic>(var lhs: T, rhs: T) -> T {
    return lhs.mult(rhs)
}

postfix func ++<T: Arithmetic>(inout oldValue: DC<T>) {
    oldValue.value?.increment()
}

postfix func --<T: Arithmetic>(inout oldValue: DC<T>) {
    oldValue.value?.decrement()
}

prefix func -<T: Arithmetic>(inout oldValue: DC<T>) {
    oldValue.value?.negate()
}