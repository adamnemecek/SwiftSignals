//
//  Neuron.swift
//  SwiftSignals
//
//  Created by Danny van Swieten on 12/31/15.
//  Copyright © 2015 Danny van Swieten. All rights reserved.
//

import Foundation

typealias NeuronInput   = [Float]
typealias Weights       = [Float]

class Neuron: Signal<Float> {
    var input   =   NeuronInput()
    var weights =   Weights()
    var size:       Int?
    var fb      =   Float()
    
    init(size: Int) {
        super.init()
        self.size = size
        input = [Float].init(count: size, repeatedValue: Float())
        for _ in 0...size {
            let v: Float = Float(Float(rand()) / Float(RAND_MAX)) - 0.5
            weights.append(v)
            sample = Float()
        }
        
        let v: Float = Float(Float(rand()) / Float(RAND_MAX)) - 0.5
        weights.append(v)
    }
    
    override func generateSample(timestamp: Int) {
        
        sample = 0.0
        for index in 0 ... input.count - 1 {
            sample! += input[index] * weights[index]
        }
        
        sample! += weights.last! * fb
        
        sample = activate()
        fb = sample!
    }
    
    func activate() -> Float {
        return 1.0 / 1.0 - expf(-sample!)
    }
}