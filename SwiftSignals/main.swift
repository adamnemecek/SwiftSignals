//
//  main.swift
//  SwiftSignals
//
//  Created by Danny van Swieten on 12/15/15.
//  Copyright © 2015 Danny van Swieten. All rights reserved.
//

import Foundation

var value   = Value<Float>(value: 30)
var sum     = value + -Value<Float>(value: 50)

var integrator = Integrator<Float>()
integrator.input = sum

print(integrator[0])