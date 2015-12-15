//
//  Integrator.swift
//  Signals
//
//  Created by Danny van Swieten on 12/14/15.
//  Copyright © 2015 Danny van Swieten. All rights reserved.
//

/// Integrator signal. The output of this signal is the running sum of it's input.
class Integrator<T: Arithmetic>: Filter<T>
{
    override init() {
        prevSample  = T()
    }
    
    override func generateSample(timestamp: Int) {
        sample = input![timestamp] + prevSample
        prevSample = sample!
    }
    
    var prevSample: T
}