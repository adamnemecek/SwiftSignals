//
//  Utility.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/8/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

func toVoid<T: AnyObject>(obj: T) -> UnsafeMutablePointer<Void>
{
    return UnsafeMutablePointer(Unmanaged.passRetained(obj).toOpaque())
}

func fromVoid<T: AnyObject>(ptr: UnsafeMutablePointer<Void>) -> T
{
    return Unmanaged<T>.fromOpaque(COpaquePointer(ptr)).takeUnretainedValue()
}

func toPointer<T>(data: T) -> UnsafeMutablePointer<T> {
    let ptr = UnsafeMutablePointer<T>.alloc(1)
    ptr.initialize(data)
    return ptr
}