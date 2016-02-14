//
//  RigidBody.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Darwin
import simd

/// This struct keeps track of an objects state in the real world. The scene class updates this for every game object.
class RigidBody
{
    /// Current Position
    var position            = float3()
    
    /// Current momentum
    var momentum            = float3()
    
    /// Current angular momentum
    var angularMomentum     = float3()
    
    /// Current velocity
    var velocity            = float3()
    
    /// Current angular velocity
    var angularVelocity     = float3()
    
    /// Current spin
    var spin                = Quaternion.identity()
    
    /// The current orientation
    var orientation         = Quaternion.identity()
    
    /// Mass, which is assumed to be static
    var mass                = 100.0
    
    /// Inverse mass. Avoids division
    var inverseMass         = 0.0
    
    /// Size of the object (we're assuming cubes here)
    var size                = 1.0
    
    /// Inertiatensor. Normally this would be a vector, but assuming cubes it can be a scalar.
    var inertiaTensor       = 0.0
    
    /// Inverse inertiatensor.
    var inverseInertiaTensor = 0.0
    
    /// Force applied to  this body.
    var force           = float3()
    
    init(withMass: Double) {
        mass = withMass
        inverseMass             = 1.0 / mass
        inertiaTensor           = mass * size * size * 1.0/6.0
        inverseInertiaTensor    = 1.0 / inertiaTensor
        orientation             = Quaternion.identity()
    }
    
    func transform() -> float4x4 {
        return  Matrix4x4.matrix_translation(position)
    }
    
    /// This is called whenever momentum and/or angular momentum is changed.
    func update() -> Void {
        velocity        = momentum * Float32(inverseMass)
        angularVelocity = angularMomentum * Float32(inverseInertiaTensor)
        orientation.normalize()
        spin            = (Quaternion(w: 0, x: angularVelocity.x, y: angularVelocity.y, z: angularVelocity.z) * Float32(0.5)) * orientation
    }
    
    /// Apply a one time force to an object
    func applyForce(forceVector: float3) -> Void {
        force = forceVector
    }
    
    /// Add a constant force to an object.
    func addForce(forceVector: float3) -> Void {
        force += forceVector
    }
    
    /// Get the rotation matrix from the orientation quaternion.
    func rotation() -> float4x4 {
        return orientation.toMatrix()
    }
}