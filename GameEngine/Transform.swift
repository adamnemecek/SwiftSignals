//
//  Transform.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import GLKit

struct Transform
{
    var translation     = Matrix4x4()
    var scaling         = Matrix4x4()
    var rotation        = Matrix4x4()
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