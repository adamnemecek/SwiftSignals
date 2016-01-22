//
//  Transform.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import GLKit

class Transform
{
    var translation = GLKMatrix4()
    var scaling     = GLKMatrix4()
    var rotation    = GLKMatrix4()
    
    func translate(x: Float, y: Float, z: Float) {
        GLKMatrix4Translate(translation, x, y, z)
    }
    
    func scale(x: Float, y: Float, z: Float) {
        GLKMatrix4Scale(rotation, x, y, z)
    }
    
    func rotate(radians: Float, x: Float, y: Float, z: Float) {
        GLKMatrix4Rotate(rotation, radians, x, y, z)
    }
}

func *(lhs: GLKMatrix4, rhs: GLKMatrix4) -> GLKMatrix4 {
    return GLKMatrix4Multiply(lhs, rhs)
}

func -(lhs: GLKMatrix4, rhs: GLKMatrix4) -> GLKMatrix4 {
    return GLKMatrix4Subtract(lhs, rhs)
}

func +(lhs: GLKMatrix4, rhs: GLKMatrix4) -> GLKMatrix4 {
    return GLKMatrix4Add(lhs, rhs)
}