//
//  GameObject.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Metal

/// GameObject. A game object has a behaviour, mesh renderer and in the future a soundsource. All of the object's properties can be accessed from it's behaviour. Adopt the BehaviourProtocol to define custom behaviour. All properties are optional, because a object can play as an actor in a scene without having an apearance.

class GameObject
{
    var title   = "Untitled"
    var transform       = Transform()
    var meshRenderer: MeshRenderer?
    var behaviour: BehaviourProtocol?
    
    var body: RigidBody?
    
    ///init function takes the scene it is rendered in. A gameobject always belongs to a scene.
    init(aTitle: String = "") {
        title = aTitle
        
        behaviour = Behaviour(object: self)
        behaviour?.setup()
        
        createMeshRenderer()
    }
    
    /// Create a meshrenderer
    func createMeshRenderer() {
        meshRenderer = MeshRenderer()
    }
}