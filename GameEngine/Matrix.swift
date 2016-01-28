//
//  Matrix.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/28/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Darwin

struct Matrix4x4
{
    var X: Vector4
    var Y: Vector4
    var Z: Vector4
    var W: Vector4
    
    init()
    {
        X = Vector4(x: 1, y: 0, z: 0, w: 0)
        Y = Vector4(x: 0, y: 1, z: 0, w: 0)
        Z = Vector4(x: 0, y: 0, z: 1, w: 0)
        W = Vector4(x: 0, y: 0, z: 0, w: 1)
    }
    
    static func rotationMatrix(axis: Vector4, byAngle angle: Float32) -> Matrix4x4
    {
        var mat = Matrix4x4()
        
        let c = cos(angle)
        let s = sin(angle)
        
        mat.X.x = axis.x * axis.x + (1 - axis.x * axis.x) * c
        mat.X.y = axis.x * axis.y * (1 - c) - axis.z * s
        mat.X.z = axis.x * axis.z * (1 - c) + axis.y * s
        
        mat.Y.x = axis.x * axis.y * (1 - c) + axis.z * s
        mat.Y.y = axis.y * axis.y + (1 - axis.y * axis.y) * c
        mat.Y.z = axis.y * axis.z * (1 - c) - axis.x * s
        
        mat.Z.x = axis.x * axis.z * (1 - c) - axis.y * s
        mat.Z.y = axis.y * axis.z * (1 - c) + axis.x * s
        mat.Z.z = axis.z * axis.z + (1 - axis.z * axis.z) * c
        
        return mat
    }
    
    static func translationMatrix(translation: Vector4) -> Matrix4x4
    {
        var mat = Matrix4x4()

        mat.X.w = translation.x
        mat.Y.w = translation.y
        mat.Z.w = translation.z
        mat.W.w = translation.w
        
        return mat
    }
    
    static func scalingMatrix(scaling: Vector4) -> Matrix4x4
    {
        var mat = Matrix4x4()
        
        mat.X.x *= scaling.x
        mat.Y.y *= scaling.y
        mat.Z.z *= scaling.z
        mat.W.w *= scaling.w
        
        return mat
    }
    
    static func perspectiveProjection(aspect: Float32, fieldOfViewY: Float32, near: Float32, far: Float32) -> Matrix4x4
    {
        var mat = Matrix4x4()
        
        let fovRadians = fieldOfViewY * Float32(M_PI / 180.0)
        
        let yScale = 1 / tan(fovRadians * 0.5)
        let xScale = yScale / aspect
        let zRange = far - near
        let zScale = -(far + near) / zRange
        let wzScale = -2 * far * near / zRange
        
        mat.X.x = xScale
        mat.Y.y = yScale
        mat.Z.z = zScale
        mat.Z.w = -1
        mat.W.z = wzScale
        
        return mat;
    }
}

func *(lhs: Matrix4x4, rhs: Vector4) -> Vector4 {
    let x = lhs.X.x * rhs.x + lhs.X.y * rhs.y + lhs.X.z * rhs.z + lhs.X.w * rhs.w
    let y = lhs.Y.x * rhs.x + lhs.Y.y * rhs.y + lhs.Y.z * rhs.z + lhs.Y.w * rhs.w
    let z = lhs.Z.x * rhs.x + lhs.Z.y * rhs.y + lhs.Z.z * rhs.z + lhs.Z.w * rhs.w
    let w = lhs.W.x * rhs.x + lhs.W.y * rhs.y + lhs.W.z * rhs.z + lhs.W.w * rhs.w
    
    return Vector4(x: x, y: y, z: z, w: w)
}

func *=(lhs: Matrix4x4, rhs: Vector4) -> Vector4 {
    return lhs * rhs
}