//
//  Runge-Kutta.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/12/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import simd

/// These function and Derivative struct belong the the Runge-Kutta fourth order integration algorithm.
struct Derivative
{
    var velocity    = float3()
    var force       = float3()
    var spin        = Quaternion.identity()
    var torque      = float3()
}

/// Evaluate next derivative
func evaluate(state: RigidBody, t: Double, dt: Double, derivative: Derivative) -> Derivative {
    
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

/// Evaluate first derivative.
func evaluate(state: RigidBody, t: Double) -> Derivative {
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

func forces(state: RigidBody, time: Double, inout force: float3, inout torque: float3) {
    
    //    force   = float3(x: 0, y: -10, z: 0) * Float(state.mass)
    
    //    torque  = float3(x: Float(10 * sin(time * 0.1 + 0.5)),
    //                    y: Float(11 * sin(time * 0.1 + 0.4)),
    //                    z: Float(12 * sin(time * 0.1 + 0.9)))
}

/// Integrate using Runge-Kutta fourth order.
func integrateWithRK4(state: RigidBody, t: Double, dt: Double) -> Void {
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