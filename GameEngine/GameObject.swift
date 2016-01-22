//
//  GameObject.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

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
    
    func size() -> Float {
        return transform.scaling[0] * transform.scaling[1] * transform.scaling[3]
    }
    
    func update() {
        print("x:\(state.position[0]) y: \(state.position[1]) z: \(state.position[2])")
    }
}