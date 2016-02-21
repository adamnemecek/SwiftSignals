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
    
    private var models = [(path: String, asset: Renderable)]()
    private var textures = [(path: String, asset: MTLTexture)]()
    private var textureLoader: MTKTextureLoader?
    private var device: MTLDevice?
    private var library: MTLLibrary?
    
    init(device: MTLDevice) {
        self.device = device
        library = device.newDefaultLibrary()
        textureLoader = MTKTextureLoader(device: device)
    }
    
    func getShader(name: String) -> MTLFunction? {
        return library?.newFunctionWithName(name)
    }
    
    private func loadTexture(path: String) -> Bool {
        let url = NSURL(fileURLWithPath: path)
        do{
            let t = try textureLoader?.newTextureWithContentsOfURL(url, options: nil)
            textures.append((path, t!))
            return true
        } catch { return false }
    }
    
    func getTexture(path: String) -> MTLTexture? {
        for texture in textures {
            if texture.path == path {
                return texture.asset
            }
        }
        
        if loadTexture(path) {
            return getTexture(path)
        }
        
        return nil
    }
    
//    func getModel(path: String) -> Renderable? {
//        
//        for model in models {
//            if model.path == path {
//                return model.asset
//            }
//        }
//        
//        let succes = loadModel(path)
//        if succes {
//            return getModel(path)
//        } else {
//            return nil
//        }
//    }
//    
//    private func loadModel(path: String) -> Bool {
//        let asset = SkinnedMesh2(pathToFile: path)
//        models.append((path, asset))
//        return true
//    }
}