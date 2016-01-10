//
//  Sine.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/8/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

class Sine: Signal<Float32>
{
    var frequency:  Signal<Float32>?
    var phase:      Signal<Float32>?
    
    override func generateSample(timestamp: Int) {
        var phi: Double = 0.0
        var offset: Double = 0.0
        
        if frequency == nil
        {
            phi = 2 * M_PI / 44100.0 * 440.0
        }
        else
        {
            phi = 2 * M_PI / 44100.0 * Double(frequency![timestamp])
        }
        
        if phase != nil
        {
            offset = Double(phase![timestamp])
        }
        
        sample = sinf(Float32(phi * Double(timestamp)) + Float32(offset * 2 * M_PI))
    }
}