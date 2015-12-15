//
//  Filter.swift
//  SwiftSignals
//
//  Created by Danny van Swieten on 12/15/15.
//  Copyright © 2015 Danny van Swieten. All rights reserved.
//

class Filter<T: Arithmetic>: Signal<T>
{
    var input: Signal<T>?
}

infix operator >> {}
func >><T: Arithmetic>(lhs: Signal<T>, rhs: Filter<T>) {
    rhs.input = lhs
}