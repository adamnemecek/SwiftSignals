//
//  GameObject.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Metal

class GameObject
{
    var title   = "Untitled"
    
    var scene: Scene?
    var transform       = Transform()
    var meshRenderer: MeshRenderer?
    
    var state = PhysicsState()
    
    init(aScene: Scene, aTitle: String) {
        title = aTitle
        scene = aScene
    }
    
    func createMeshRenderer() {
        meshRenderer = MeshRenderer(aTransform: transform)
    }
    
    func update() {
         meshRenderer?.transform?.rotation = state.rotation()
    }
}