//
//  AudioBuffer.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/8/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

class AudioBuffer<T: Arithmetic>
{
    var numChannels: UInt32
    var size: UInt32
    
    var buffers: BufferPointer<T>?
    
    init(numChannels: UInt32, size: UInt32)
    {
        self.numChannels    = numChannels
        self.size           = size
        
        buffers = BufferPointer<T>(size: numChannels * size)
    }
    
    subscript(index: Int) -> UnsafeMutablePointer<T>
    {
        return buffers!.samples().advancedBy(index * Int(size))
    }
}

class BufferPointer<T: Arithmetic>
{
    var data: [T]?
    let dataPtr: UnsafeMutablePointer<T>
    var size: UInt32
    
    init(size: UInt32)
    {
        self.size = size
        data = [T](count: Int(size), repeatedValue: T())
        dataPtr = UnsafeMutablePointer<T>(data!)
    }
    
    func samples() -> UnsafeMutablePointer<T>
    {
        return dataPtr
    }
}