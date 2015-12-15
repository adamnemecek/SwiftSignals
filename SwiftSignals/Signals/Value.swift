//
//  Value.swift
//  Signals
//
//  Created by Danny van Swieten on 12/14/15.
//  Copyright © 2015 Danny van Swieten. All rights reserved.
//

/// Value signal. Is a constant valued signal (DC) of type T
class Value<T: Arithmetic>: Signal<T>
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