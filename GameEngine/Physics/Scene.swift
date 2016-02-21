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
class Scene: Renderable
{
    var objects = [GameObject]()
    var view    = float4x4()
    
    var perspectiveMatrix: float4x4?
    
    var uniformBuffer: MTLBuffer?
    var uniforms: UnsafeMutablePointer<float4x4>?
    
    var title = ""
    
    var camera = FPSCameraBehaviour()
    
    init(aTitle: String = ""){
        title = aTitle
        let size = GameEngine.instance.view?.drawableSize
        let aspect = (size?.width)! / (size?.height)!
        perspectiveMatrix = Matrix4x4.matrix_from_perspective_fov_aspectLH(65.0 * Float((M_PI / 180.0)), aspect: Float(aspect), nearZ: 0.01, farZ: 100)

        uniforms = UnsafeMutablePointer<float4x4>((uniformBuffer?.contents())!)
        uniforms![1] = view
        uniforms![2] = perspectiveMatrix!
        uniforms![3] = float4x4()
    }
    
    func renderWithEncoder(commandEncoder: MTLRenderCommandEncoder) {
        for object in objects {
            object.update()
            
            object.renderer?.prepareToRender()
            object.renderer?.renderWithEncoder(commandEncoder)
        }
    }
    
    /// Creates an empty object and adds it to the scene.
    final func createObject() {
        let object = GameObject(aTitle: "Object " + String(objects.count + 1))
        objects.append(object)
    }
    
    final func addObject(object: GameObject) {
        objects.append(object)
    }
}