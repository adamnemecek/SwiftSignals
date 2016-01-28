//
//  PhysicsState.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//
import GLKit

/// This struct keeps track of an objects state in the real world
struct PhysicsState
{
    /// Current Position
    var position            = Vector3()
    
    /// Current momentum
    var momentum            = Vector3()
    
    /// Current angular momentum
    var angularMomentum     = Vector3()
    
    /// Current velocity
    var velocity            = Vector3()
    
    /// Current angular velocity
    var angularVelocity     = Vector3()
    
    /// Current spin
    var spin                = Quaternion()
    
    /// The current orientation
    var orientation         = Quaternion()
    
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
    var force           = Vector3()
    
    /// Body-to-world matrix
    var bodyToWorld     = GLKMatrix4()
    
    /// World-to-body matrix
    var worldToBody     = GLKMatrix4()
    
    init() {
        inverseMass             = 1.0 / mass
        inertiaTensor           = mass * size * size * 1.0/6.0
        inverseInertiaTensor    = 1.0 / inertiaTensor
        orientation             = Quaternion()
    }
    
    mutating func update() -> Void {
        velocity        = momentum * Float32(inverseMass)
        angularVelocity = angularMomentum * Float32(inverseInertiaTensor)
        orientation.normalize()
        spin            = Float32(0.5) * Quaternion(a: 0, b: angularVelocity.x, c: angularVelocity.y, d: angularVelocity.z) * orientation
    }
    
    mutating func applyForce(forceVector: GLKVector3) -> Void {
        force = forceVector
    }
    
    mutating func addForce(forceVector: GLKVector3) -> Void {
        force = force + forceVector
    }
    
    func rotation() -> GLKMatrix4 {
        return GLKMatrix4MakeWithQuaternion(orientation)
    }
}

struct Derivative
{
    var velocity    = Vector3()
    var force       = Vector3()
    var spin        = Quaternion()
    var torque      = Vector3()
}

func evaluate(var state: PhysicsState, t: Double, dt: Double, derivative: Derivative) -> Derivative {
    
    /// Update position with derivative (velocity)
    state.position = state.position + derivative.velocity * Float(dt)
    /// Update velocity with derivative (acceleration)
    state.momentum = state.momentum + derivative.force * Float(dt)
    /// Update orientation with derivative (angular velocity)
    state.orientation = state.orientation + Float(dt) * derivative.spin
    /// Update the angular momentum
    state.angularMomentum = state.angularMomentum + derivative.torque * Float(dt)
    /// Update secondary values.
    state.update()
    
    /// Create a new Derivative
    var output = Derivative()
    /// Update position derivative (velocity)
    output.velocity = state.velocity
    /// Update velocity derivative by calculating acceleration.
    forces(state, time: t + dt, force: &output.force, torque: &output.torque)
    /// Return this derivative for RK4 evaluation.
    return output
}

func evaluate(state: PhysicsState, t: Double) -> Derivative {
    /// Create a new Derivative
    var output = Derivative()
    /// Update position derivative (velocity)
    output.velocity = state.velocity
    /// Update velocity derivative by calculating acceleration.
    output.spin     = state.spin
    
    forces(state, time: t, force: &output.force, torque: &output.torque)
    /// Return this derivative for RK4 evaluation.
    return output
}

func forces(state: PhysicsState, time: Double, inout force: GLKVector3, inout torque: GLKVector3) {
    
    force   = Vector3(x: 0, y: -10, z: 0) * Float(state.mass)
    
    torque  = Vector3(  x: Float(10 * sin(time * 0.1 + 0.5)),
                        y: Float(11 * (time * 0.1 + 0.4)),
                        z: Float(12 * sin(time * 0.1 + 0.9)))
}

func integrateWithRK4(inout state: PhysicsState, t: Double, dt: Double) -> Void {
    var a, b, c, d: Derivative
    
    /// Calculate derivative based on current state.
    a = evaluate(state, t: t)
    /// Use that derivative to calculate a new derivative with a smaller timestep
    b = evaluate(state, t: t, dt: dt * 0.5, derivative: a)
    /// Use that derivative to calculate a new derivative with a smaller timestep
    c = evaluate(state, t: t, dt: dt * 0.5, derivative: b)
    /// Use that derivative to calculate a new derivative with a smaller timestep
    d = evaluate(state, t: t, dt: dt, derivative: c)
    
    /// Multiplication factor from taylor series.
    let rkFactor: Float = 1.0 / 6.0
    
    /// Delta position from waited sum of derivatives
    let velocity = rkFactor * (a.velocity + 2.0 * (b.velocity + c.velocity) + d.velocity)
    /// Delta velocity from waited sum of derivatives
    let force = rkFactor * (a.force + 2.0 * (b.force + c.force) + d.force)
    /// Delta position from waited sum of derivatives
    let spin = rkFactor * (a.spin + 2.0 * (b.spin + c.spin) + d.spin)
    /// Delta velocity from waited sum of derivatives
    let torque = rkFactor * (a.torque + 2.0 * (b.torque + c.torque) + d.torque)
    
    /// Update state position and velocity with waited sums corrected by timestep
    state.position = state.position + velocity * Float(dt)
    state.momentum = state.momentum + force * Float(dt)
    state.orientation = state.orientation + Float(dt) * spin
    state.angularMomentum = state.angularMomentum + Float(dt) * torque
    
    state.update()
}

func +(lhs: GLKVector3, rhs: GLKVector3) -> GLKVector3 {
    return GLKVector3Add(lhs, rhs)
}

func +(lhs: GLKVector3, rhs: Float) -> GLKVector3 {
    return GLKVector3AddScalar(lhs, rhs)
}

func +(lhs: GLKQuaternion, rhs: GLKQuaternion) -> GLKQuaternion {
    return GLKQuaternionAdd(lhs, rhs)
}

func -(lhs: GLKVector3, rhs: GLKVector3) -> GLKVector3 {
    return GLKVector3Subtract(lhs, rhs)
}

func -(lhs: GLKVector3, rhs: Float) -> GLKVector3 {
    return GLKVector3SubtractScalar(lhs, rhs)
}

func *(lhs: GLKVector3, rhs: GLKVector3) -> GLKVector3 {
    return GLKVector3Multiply(lhs, rhs)
}

func *(lhs: Float, rhs: GLKVector3) -> GLKVector3 {
    return GLKVector3MultiplyScalar(rhs, lhs)
}

func *(lhs: Float, rhs: GLKQuaternion) -> GLKQuaternion {
    return GLKQuaternionMake(rhs.w * lhs, rhs.x * lhs, rhs.y * lhs, rhs.z * lhs)
}

func *(lhs: GLKQuaternion, rhs: GLKQuaternion) -> GLKQuaternion {
    return GLKQuaternionMultiply(lhs, rhs)
}

func *(lhs: GLKVector3, rhs: Float) -> GLKVector3 {
    return GLKVector3MultiplyScalar(lhs, rhs)
}

func /(lhs: GLKVector3, rhs: Float) -> GLKVector3 {
    return GLKVector3MultiplyScalar(lhs, 1.0 / rhs)
}