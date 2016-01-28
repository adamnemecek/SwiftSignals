//
//  VectorMath.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/28/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

func +(lhs: Vector4, rhs: Vector4) -> Vector4 {
    return Vector4(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w)
}

func -(lhs: Vector4, rhs: Vector4) -> Vector4 {
    return Vector4(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z, w: lhs.w - rhs.w)
}

func *(lhs: Vector4, rhs: Vector4) -> Vector4 {
    return Vector4(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z, w: lhs.w * rhs.w)
}

func +=(inout lhs: Vector4, rhs: Vector4) -> Vector4 {
    lhs.x += rhs.x
    lhs.y += rhs.y
    lhs.z += rhs.z
    lhs.w += rhs.w
    return lhs
}

func -=(inout lhs: Vector4, rhs: Vector4) -> Vector4 {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
    lhs.z -= rhs.z
    lhs.w -= rhs.w
    return lhs
}

func *=(inout lhs: Vector4, rhs: Vector4) -> Vector4 {
    lhs.x *= rhs.x
    lhs.y *= rhs.y
    lhs.z *= rhs.z
    lhs.w *= rhs.w
    return lhs
}

func *(lhs: Vector4, rhs: Float32) -> Vector4 {
    let x = lhs.x * rhs
    let y = lhs.y * rhs
    let z = lhs.z * rhs
    let w = lhs.w * rhs
    
    return Vector4(x: x, y: y, z: z, w: w)
}

func *=(inout lhs: Vector4, rhs: Float32) -> Vector4 {
    lhs.x *= rhs
    lhs.y *= rhs
    lhs.z *= rhs
    lhs.w *= rhs
    return lhs
}

//-----------------------------------------------------

func +(lhs: Vector3, rhs: Vector3) -> Vector3 {
    return Vector3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}

func -(lhs: Vector3, rhs: Vector3) -> Vector3 {
    return Vector3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
}

func *(lhs: Vector3, rhs: Vector3) -> Vector3 {
    return Vector3(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
}

func +=(inout lhs: Vector3, rhs: Vector3) -> Vector3 {
    lhs.x += rhs.x
    lhs.y += rhs.y
    lhs.z += rhs.z
    return lhs
}

func -=(inout lhs: Vector3, rhs: Vector3) -> Vector3 {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
    lhs.z -= rhs.z
    return lhs
}

func *=(inout lhs: Vector3, rhs: Vector3) -> Vector3 {
    lhs.x *= rhs.x
    lhs.y *= rhs.y
    lhs.z *= rhs.z
    return lhs
}

func *(lhs: Vector3, rhs: Float32) -> Vector3 {
    let x = lhs.x * rhs
    let y = lhs.y * rhs
    let z = lhs.z * rhs
    
    return Vector3(x: x, y: y, z: z)
}

func *=(inout lhs: Vector3, rhs: Float32) -> Vector3 {
    lhs.x *= rhs
    lhs.y *= rhs
    lhs.z *= rhs

    return lhs
}

//-----------------------------------------------------

func +(lhs: Vector2, rhs: Vector2) -> Vector2 {
    return Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func -(lhs: Vector2, rhs: Vector2) -> Vector2 {
    return Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func *(lhs: Vector2, rhs: Vector2) -> Vector2 {
    return Vector2(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
}

func +=(inout lhs: Vector2, rhs: Vector2) -> Vector2 {
    lhs.x += rhs.x
    lhs.y += rhs.y
    return lhs
}

func -=(inout lhs: Vector2, rhs: Vector2) -> Vector2 {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
    return lhs
}

func *=(inout lhs: Vector2, rhs: Vector2) -> Vector2 {
    lhs.x *= rhs.x
    lhs.y *= rhs.y
    return lhs
}