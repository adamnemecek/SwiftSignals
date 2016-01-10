//
//  Signal.swift
//  SwiftGameEngine
//
//  Created by Danny van Swieten on 12/14/15.
//  Copyright © 2015 Danny van Swieten. All rights reserved.
//

import Foundation

/// Signal protocol.
protocol SignalBase
{
    typealias Value
    func generateSample(timestamp: Int) -> Void
    var sample: Value{set get}
}

/// Signal baseclass. Subclasses of this can take a type T that conforms to the Arithmetic protocol
class Signal<T: Arithmetic>: SignalBase
{
    var sample = T()
    var time: Int?
    
    init()
    {
        sample = T()
    }
    
    typealias Value = T
    func generateSample(timestamp: Int) -> Void
    {
        
    }
    
    subscript(timestamp: Int) -> T
    {
        if(timestamp > time)
        {
            time = timestamp
            generateSample(timestamp)
        }
        
        return sample
    }
}

func <<<T>(inout lhs: Signal<T>, rhs: T)
{
    lhs = DC<T>(value: rhs)
}