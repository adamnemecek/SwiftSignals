//
//  Scene.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import GLKit

class Scene
{
    var t   = 0.0
    var dt  = 0.01
    
    var currentTime = 0.0
    var accumulator = 0.0
    
    var objects = [GameObject]()
    var gravity = GLKVector3(v: (Float(0.0), Float(-9.8), Float(0.0)))
    
    var integrationFunction: (inout PhysicsState, Double, Double) -> Void = {_,_,_ in}
    
    func createObject() {
        let object = GameObject(aScene: self, aTitle: "Object " + String(objects.count + 1))
        objects.append(object)
    }
    
    func update() {
        
        let newTime     = NSDate.timeIntervalSinceReferenceDate()
        var frameTime   = newTime - currentTime
        
        if frameTime > 0.25 {
            frameTime = 0.25
        }
        
        currentTime = newTime
        accumulator += frameTime
        
        while accumulator >= dt {
            
            for object in objects {
                integrationFunction(&object.state, t, dt)
                object.update()
            }
            
            t += dt;
            accumulator -= dt;
        }
    }
}