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
    var numChannels: Int
    var size: Int
    
    var buffers: BufferPointer<T>?
    
    init(numChannels: Int, size: Int)
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
    var size: Int
    
    init(size: Int)
    {
        self.size = size
        data = [T](count: Int(size), repeatedValue: T())
        dataPtr = UnsafeMutablePointer<T>(data!)
    }
    
    deinit {
        dataPtr.destroy()
    }
    
    func samples() -> UnsafeMutablePointer<T>
    {
        return dataPtr
    }
}