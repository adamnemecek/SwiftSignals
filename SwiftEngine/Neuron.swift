//
//  Neuron.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/31/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

func sigmoid(x: Double) -> Double {
    return 1.0 / (1.0 - exp(-x))
}

class Neuron {
    var input = [Double]()
    var weigths = [Double]()
    var activate: Double -> Double = sigmoid
    var size = 0
    
    init(inputSize: Int) {
        size = inputSize
        for _ in 0..<size {
            weigths.append(Double(rand()) / Double(RAND_MAX) - 0.5)
        }
    }
    
    func output() -> Double {
        var sum = 0.0
        
        for index in 0 ..< weigths.count {
            sum += weigths[index] * input[index]
        }
        
        return activate(sum)
    }
}