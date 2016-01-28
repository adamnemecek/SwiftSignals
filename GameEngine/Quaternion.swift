//
//  Quaternion.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/28/16.
//  Copybright © 2016 Danny van Swieten. All rights reserved.
//

import Darwin

struct Quaternion {
    var a: Float32 = 1.0
    var b: Float32 = 0
    var c: Float32 = 0
    var d: Float32 = 0
    
    func length() -> Float32 {
        return sqrt(a * a + b * b + c * c + d * d)
    }
    
    mutating func normalize() {
        let l = length()
        
        a /= l
        b /= l
        c /= l
        d /= l
    }
    
    func normalized() -> Quaternion {
        let l = length()
        let constant = 1.0 / l
        
        return Quaternion(a: a * constant, b: b * constant, c: c * constant, d: d * constant)
    }
    
    static func fromRotation(angle: Float32, axis: Vector3) -> Quaternion {
        
        let an = axis.normalized()
        let a = cos(angle / 2.0)
        let b = an.x * sin(angle / 2.0)
        let c = an.y * sin(angle / 2.0)
        let d = an.z * sin(angle / 2.0)
        
        return Quaternion(a: a, b: b, c: c, d: d)

    }
}

func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
    
    let a = lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d
    let b = lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c
    let c = lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a - lhs.d * rhs.b
    let d = lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a
    
    return Quaternion(a: a, b: b, c: c, d: d)
}