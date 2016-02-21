//
//  GameObject.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import simd
import Metal

/// GameObject. A game object has a behaviour, mesh renderer and in the future a soundsource. All of the object's properties can be accessed from it's behaviour. Adopt the BehaviourProtocol to define custom behaviour. All properties are optional, because a object can play as an actor in a scene without having an apearance.

class GameObject
{
    var title           = "Untitled"
    var transform       = Transform()
    
    var behaviour:      Behaviour?
    var body:           RigidBody?
    
    var renderer:       MeshRenderer?
    
    init(aTitle: String = "") {
        title = aTitle
    }
    
    /// Updates the behaviour
    func update() {
        behaviour?.update()
        
        /// Sets the renderer's model matrix
        renderer?.setTransform(transform.transform() * body!.transform())
    }
}