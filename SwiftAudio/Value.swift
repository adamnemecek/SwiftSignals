//
//  DC.swift
//  Signals
//
//  Created by Danny van Swieten on 12/14/15.
//  Copyright © 2015 Danny van Swieten. All rights reserved.
//

/// DC signal. Is a constant DCd signal (DC) of type T
class DC<T: Arithmetic>: Signal<T>
{
    init(value: T)
    {
        self.value = value
    }
    
    override init()
    {
        
    }
    
    override func generateSample(timestamp: Int) -> Void
    {
        sample = value
    }
    
    var value: T?
}

func <<<T>(inout lhs: DC<T>, rhs: T)
{
    lhs.value = rhs
}

func <<<T>(inout lhs: DC<T>, rhs: DC<T>)
{
    lhs.value = rhs.value
}