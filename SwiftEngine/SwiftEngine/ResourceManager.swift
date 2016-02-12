//
//  ResourceManager.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/25/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import ModelIO
import MetalKit

class ResourceManager {
    
    private var models: [(path: String, asset: Mesh)]?
    private var textures: [(path: String, asset: MTLTexture)]?
    private var context = GameEngine.instance.graphicsContext
    private var textureLoader: MTKTextureLoader?
    
    init() {
        textureLoader = MTKTextureLoader(device: context!.device!)
    }
    
    private func loadTexture(path: String) {
        let url = NSURL(fileURLWithPath: path)
        textureLoader?.newTextureWithContentsOfURL(url, options: nil, completionHandler: {_, _ in })
    }
    
    func getTexture(path: String) -> MTLTexture? {
        for texture in textures! {
            if texture.path == path {
                return texture.asset
            }
        }
        
        loadTexture(path)
        return getTexture(path)
    }
    
    func getModel(path: String) -> Mesh? {
        for model in models! {
            if model.path == path {
                return model.asset
            }
        }
        
        let succes = loadModel(path)
        if succes {
            return getModel(path)
        } else {
            return nil
        }
    }
    
    private func loadModel(path: String) -> Bool {
        let asset = Mesh(filePath: path, vertexDescriptor: nil, context: context!)
        models?.append((path, asset))
        return true
    }
}