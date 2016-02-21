//
//  Material.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/12/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit

class Material {
    
    var shader: Shader?
    var vertexShader: MTLFunction?
    var fragmentShader: MTLFunction?
    var textures = [String: MTLTexture?]()
    
    init(aShader: Shader) {
        shader = aShader
        fragmentShader = GameEngine.instance.resourceManager?.getShader(shader!.fragmentFunction)
        
        for attribute in shader!.attributes {
            textures[attribute.name] = nil
        }
    }
}