//
//  PhysicsState.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Darwin

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
        spin            = (Quaternion(w: 0, x: angularVelocity.x, y: angularVelocity.y, z: angularVelocity.z) * Float32(0.5)) * orientation
    }
    
    mutating func applyForce(forceVector: Vector3) -> Void {
        force = forceVector
    }
    
    mutating func addForce(forceVector: Vector3) -> Void {
        force += forceVector
    }
    
    func rotation() -> Matrix4x4 {
        return orientation.toMatrix()
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
    state.orientation = state.orientation + derivative.spin * Float(dt)
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

func forces(state: PhysicsState, time: Double, inout force: Vector3, inout torque: Vector3) {
    
    force   = Vector3(x: 0, y: -10, z: 0) * Float(state.mass)
    
    torque  = Vector3(  x: Float(10 * sin(time * 0.1 + 0.5)),
                        y: Float(11 * sin(time * 0.1 + 0.4)),
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
    let rkFactor: Float = 1.0 / 6.0 * Float(dt)
    
    /// Delta position from waited sum of derivatives
    
    var sum = a.velocity + ((b.velocity + c.velocity) * Float(2.0)) + d.velocity
    
    /// Delta velocity from waited sum of derivatives
    let velocity = sum * rkFactor
    
    /// Delta force from waited sum of derivatives
    sum = a.force + ((b.force + c.force) * Float(2.0)) + d.force
    let force = sum * rkFactor
    
    /// Delta position from waited sum of derivatives
    let qsum = a.spin + ((b.spin + c.spin) * Float(2.0)) + d.spin
    let spin = qsum * rkFactor

    /// Delta velocity from waited sum of derivatives
    sum = a.torque + ((b.torque + c.torque) * Float(2.0))
    sum = sum + d.torque
    let torque = sum * rkFactor
    
    /// Update state position and velocity with waited sums corrected by timestep
    state.position = state.position + velocity
    state.momentum = state.momentum + force
    state.orientation = state.orientation + spin
    state.angularMomentum = state.angularMomentum + torque
    
    state.update()
}