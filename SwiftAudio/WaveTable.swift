//
//  WaveTable.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/9/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

class WaveTable
{
    var table = [Float32]()
    var tableSize = 0
    
    init(size: Int)
    {
        tableSize = size
        table = [Float32](count: tableSize, repeatedValue: 0)
    }
    
    subscript (index: Float32) -> Float32
    {
        let trueIndex   = index * Float32(tableSize)
        let floorIndex  = Int(trueIndex) % tableSize
        let nextIndex    = (floorIndex + 1) % tableSize
        let frac        = trueIndex - Float32(floorIndex)
        
        return (1 - frac) * table[floorIndex] + frac * table[nextIndex]
    }
    
    func createSpectrum(spectrum: [Float32])
    {
        table.removeAll()
        for sample in 0..<tableSize
        {
            var sum = 0.0
            
            for channel in 0..<spectrum.count
            {
                let phinc = 2.0 * M_PI / Double(tableSize) * Double(channel + 1)
                sum += sin(phinc * Double(sample)) * Double(spectrum[channel])
            }
            
            table.append(Float32(sum))
        }
    }
}