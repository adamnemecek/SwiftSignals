//
//  Phasor.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/9/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

class Phasor: Signal<Float32>
{
    var frequency:  Signal<Float32>?
    var phase:      Signal<Float32>?
    var phinc: Float32 = 0.0
    init(frequency: Signal<Float32> = DC(value: 440.0)) {
        super.init()
        self.frequency = frequency
        sample = 0.0
    }
    
    override func generateSample(timestamp: Int) {
        
        phinc = 1.0 / 44100.0 * frequency![timestamp]
        var offset: Float32 = 0.0
        if phase != nil
        {
            offset = phase![timestamp]
        }
        
        sample = sample + phinc + offset
        
        while sample > 1.0
        {
            sample = sample - 1.0
        }
    }
}