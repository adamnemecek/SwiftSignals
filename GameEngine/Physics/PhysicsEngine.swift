//
//  PhysicsEngine.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/12/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation
import simd

class PhysicsEngine {
    
    private var t   = 0.0
    private var dt  = 0.01
    private var currentTime = 0.0
    private var accumulator = 0.0
    private var thread: NSThread?
    
    var shouldRun = false
    
    private var gravityVector = float3(0.0, -9.81, 0.0)
    
    /// The integration function used for simulation. You can supply your own function. Defaults to Runge-Kutta fourth order algorithm.
    var integrationFunction: (RigidBody, Double, Double) -> Void = integrateWithRK4
    
    var bodies = [RigidBody]()
    
    /// Set the amount of gravity
    final func setGravity(force: Float) -> Void {
        gravityVector.y = force
    }
    
    /// Request a new body with a mass. You can give this to a game object to make it render at the right position.
    final func newBody(withMass: Double) -> RigidBody {
        let body = RigidBody(withMass: withMass)
        bodies.append(body)
        return body
    }
    
    /// Start the physics simulation.
    final func start() -> Void {
        shouldRun = true
        NSThread.detachNewThreadSelector("run", toTarget: self, withObject: nil)
    }
    
    @objc private final func run() -> Void {
        while(shouldRun) {
            update()
        }
    }
    
    final func update() {
        
        let newTime     = NSDate.timeIntervalSinceReferenceDate()
        var frameTime   = newTime - currentTime
        
        if frameTime > 0.25 {
            frameTime = 0.25
        }
        
        currentTime = newTime
        accumulator += frameTime
        
        while accumulator >= dt {
            for body in bodies {
                integrationFunction(body, t, dt)
            }
            
            t += dt;
            accumulator -= dt;
        }
    }
}