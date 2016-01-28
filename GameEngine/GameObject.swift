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
        let rotate = state.rotation()
        let X = Vector4(x: rotate.m00, y: rotate.m01, z: rotate.m02, w: rotate.m03)
        let Y = Vector4(x: rotate.m10, y: rotate.m11, z: rotate.m12, w: rotate.m13)
        let Z = Vector4(x: rotate.m20, y: rotate.m21, z: rotate.m22, w: rotate.m23)
        let W = Vector4(x: rotate.m30, y: rotate.m31, z: rotate.m32, w: rotate.m33)
        
        transform.rotation.X    = X
        transform.rotation.Y    = Y
        transform.rotation.Z    = Z
        transform.rotation.W    = W
        
        meshRenderer?.transform = transform
    }
}