//
//  Vector.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/28/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Darwin

struct Vector4
{
    var x: Float32 = 0
    var y: Float32 = 0
    var z: Float32 = 0
    var w: Float32 = 0
    
    func length() -> Float32 {
        return sqrt(x * x + y * y + z * z + w * w)
    }
    
    mutating func normalize() -> Vector4 {
        let l = length()
        let constant = 1.0 / l
        x *= constant
        y *= constant
        z *= constant
        w *= constant
        
        return self
    }
    
    func normalized() -> Vector4 {
        let l = length()
        let constant = 1.0 / l
        let dx = x * constant
        let dy = y * constant
        let dz = z * constant
        let dw = w * constant
        
        return Vector4(x: dx, y: dy, z: dz, w: dw)
    }
}

struct Vector3{
    var x: Float32 = 0
    var y: Float32 = 0
    var z: Float32 = 0
    
    func length() -> Float32 {
        return sqrt(x * x + y * y + z * z)
    }
    
    mutating func normalize() {
        let l = length()
        let constant = 1.0 / l
        x *= constant
        y *= constant
        z *= constant
    }
    
    func normalized() -> Vector3 {
        let l = length()
        let constant = 1.0 / l
        let dx = x * constant
        let dy = y * constant
        let dz = z * constant
        
        return Vector3(x: dx, y: dy, z: dz)
    }
    
    static func cross(a: Vector3, b: Vector3) -> Vector3 {
        let x = a.y * b.z - a.z * b.y
        let y = a.z * b.x - a.x * b.z
        let z = a.x * b.y - a.y * b.x
        
        return Vector3(x: x, y: y, z: z)
    }
}

struct Vector2
{
    var x: Float32 = 0
    var y: Float32 = 0
    
    func length() -> Float32 {
        return sqrt(x * x + y * y)
    }
    
    mutating func normalize() {
        let l = length()
        let constant = 1.0 / l
        x *= constant
        y *= constant
    }
    
    mutating func normalized() -> Vector2 {
        let l = length()
        let constant = 1.0 / l
        let dx = x * constant
        let dy = y * constant
        
        return Vector2(x: dx, y: dy)
    }
}

typealias TextureCoordinates = Vector2