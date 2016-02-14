//
//  Scene.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit
import simd

/// Scene class. This renders al object's meshrenderer.
class Scene
{
    var objects = [GameObject]()
    var viewMatrix = Matrix4x4.matrix_translation(0, y: 0, z: 2)
    var perspectiveMatrix: float4x4?
    
    var uniformBuffer: MTLBuffer?
    var uniforms: UnsafeMutablePointer<float4x4>?
    
    var title = ""
    
    init(aTitle: String = ""){
        title = aTitle
        let size = GameEngine.instance.graphicsContext?.metalView?.drawableSize
        let aspect = (size?.width)! / (size?.height)!
        perspectiveMatrix = Matrix4x4.matrix_from_perspective_fov_aspectLH(65.0 * Float((M_PI / 180.0)), aspect: Float(aspect), nearZ: 0.01, farZ: 100)
        
        uniformBuffer = GameEngine.instance.graphicsContext?.device?.newBufferWithLength(sizeof(Projection), options: .CPUCacheModeDefaultCache)
        uniforms = UnsafeMutablePointer<float4x4>((uniformBuffer?.contents())!)
        uniforms![1] = viewMatrix
        uniforms![2] = perspectiveMatrix!
    }
    
    /// Creates an empty object and adds it to the scene.
    final func createObject() {
        let object = GameObject(aTitle: "Object " + String(objects.count + 1))
        objects.append(object)
    }
    
    final func addObject(object: GameObject) {
        objects.append(object)
    }
    
    /// Renders all object's meshes if they have them.
    final func render() -> Void {
        
        GameEngine.instance.graphicsContext?.prepareToRender()
        
        for object in objects {
            object.behaviour?.update()
            uniforms![0] = (object.body?.transform())!
            memcpy(uniformBuffer!.contents(), uniforms!, sizeof(Projection))
            object.meshRenderer?.render()
        }
        
        GameEngine.instance.graphicsContext?.commandBuffer?.presentDrawable((GameEngine.instance.graphicsContext?.metalView!.currentDrawable!)!)
        
        GameEngine.instance.graphicsContext?.commandBuffer?.commit()
    }
}