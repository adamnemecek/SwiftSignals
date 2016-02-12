//
//  Scene.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation
import simd

/// Scene class. This updates the physics states and calls te render functions of the game objects. It also contains the view matrix and a custom implementable integration closure. It defaults to Runge-Kutta fourth order integration. See typesignature
class Scene
{
    var t   = 0.0
    var dt  = 0.01
    
    var currentTime = 0.0
    var accumulator = 0.0
    
    var objects = [GameObject]()
    var gravity = Vector3(x: 0.0, y: -9.8, z: 0.0)
    
    var integrationFunction: (RigidBody, Double, Double) -> Void = {_,_,_ in}
    
    var viewMatrix = Matrix4x4.matrix_translation(0, y: 0, z: 2)
    
    var title = ""
    
    init(aTitle: String = ""){
        title = aTitle
    }
    
    /// Creates an empty object and adds it to the scene.
    final func createObject() {
        let object = GameObject(aTitle: "Object " + String(objects.count + 1))
        objects.append(object)
    }
    
    /// updates the scene and all object's physics states
    final func update(ctx: MetalContext) {
        
        let newTime     = NSDate.timeIntervalSinceReferenceDate()
        var frameTime   = newTime - currentTime
        
        if frameTime > 0.25 {
            frameTime = 0.25
        }
        
        currentTime = newTime
        accumulator += frameTime
        
        while accumulator >= dt {
            ctx.setViewMatrix(viewMatrix)
            for object in objects {
                integrationFunction(object.body, t, dt)
                object.update()
                let translation = Matrix4x4.matrix_translation(object.body.position)
                ctx.setModelMatrix(translation * object.transform.scaling.matrix * object.body.rotation())
                ctx.pushMatrix()
                object.meshRenderer?.render(ctx.renderCommandEncoder!)
            }
            
            t += dt;
            accumulator -= dt;
        }
    }
}