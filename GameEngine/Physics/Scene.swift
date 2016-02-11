//
//  Scene.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation
import simd

class Scene
{
    var t   = 0.0
    var dt  = 0.01
    
    var currentTime = 0.0
    var accumulator = 0.0
    
    var objects = [GameObject]()
    var gravity = Vector3(x: 0.0, y: -9.8, z: 0.0)
    
    var integrationFunction: (inout PhysicsState, Double, Double) -> Void = {_,_,_ in}
    
    var viewMatrix = Matrix4x4.matrix_translation(0, y: 0, z: 0)
    
    func createObject() {
        let object = GameObject(aScene: self, aTitle: "Object " + String(objects.count + 1))
        objects.append(object)
    }
        
    func update(ctx: MetalContext) {
        
        let newTime     = NSDate.timeIntervalSinceReferenceDate()
        var frameTime   = newTime - currentTime
        
        if frameTime > 0.25 {
            frameTime = 0.25
        }
        
        currentTime = newTime
        accumulator += frameTime
        
        while accumulator >= dt {
            for object in objects {
                ctx.setViewMatrix(viewMatrix)
                integrationFunction(&object.state, t, dt)
                object.update()
                let translation = Matrix4x4.matrix_translation(0, y: 0.0, z: 2.0)
                
                ctx.setModelMatrix(translation * object.transform.scaling.matrix * object.state.rotation())
                ctx.pushMatrix()
                object.meshRenderer?.render(ctx.renderCommandEncoder!)
            }
            
            t += dt;
            accumulator -= dt;
        }
    }
}