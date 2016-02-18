//
//  Matrix.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/28/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Darwin
import simd

struct Matrix4x4 {
    
    var matrix = float4x4(matrix_identity_float4x4)
    
    static func matrix_from_perspective_fov_aspectLH(fovY: Float, aspect: Float, nearZ: Float, farZ: Float) ->float4x4 {

        let yscale = Float(1.0 / tanf(fovY * 0.5));
        let xscale = Float(yscale / aspect);
        let q = Float(farZ / (farZ - nearZ));
    
        let coll = (float4(xscale, 0.0,    0.0,    0.0),
                    float4(0.0,    yscale, 0.0,    0.0),
                    float4(0.0,    0.0,    q,      1.0),
                    float4(0.0,    0.0,    q * -nearZ, 0.0))
        
        
        
        
        let m   = matrix_float4x4(columns: coll)
    
        return float4x4(m)
    }
    
    static func matrix_translation(x: Float, y: Float, z: Float) ->float4x4 {
        
        var m = matrix_identity_float4x4
        m.columns.3 = float4(x, y, z, 1.0)
        return float4x4(m)
    }
    
    static func matrix_translation(row: float3) ->float4x4 {
        
        var m = matrix_identity_float4x4
        m.columns.3 = float4(row.x, row.y, row.z, 1.0)
        return float4x4(m)
    }
    
    static func lookAt(target: Vector3, position: Vector3, up: Vector3) -> float4x4 {
        let direction = (position - target).normalized()
        let right = Vector3.cross(up, b: direction).normalized()
        let cameraUp = Vector3.cross(direction, b: right)
        
        let coll = (float4(right.x,     right.y,    right.z,    0),
            float4(        cameraUp.x,  cameraUp.y, cameraUp.z,    0.0),
            float4(direction.x,    direction.y,    direction.z,      0),
            float4(0.0,    0.0,    0, 1.0))
        
        let m   = matrix_float4x4(columns: coll)
        
        return float4x4(m)
    }
}