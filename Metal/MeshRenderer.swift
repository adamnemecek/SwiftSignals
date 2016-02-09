//
//  MeshRenderer.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit
import ModelIO

class SubMesh
{
    var name        = ""
    var indexCount  = 0
    var byteSize    = 0
    var indexBuffer = UnsafeMutablePointer<Void>()
    var indexType:MTLIndexType?
    
    init() {
        
    }
    
    init(aName: String, anIndexCount: Int, indexType: MDLIndexBitDepth, data: UnsafeMutablePointer<Void>) {
        name        = aName
        indexCount  = anIndexCount
        indexBuffer = data
        switch(indexType) {
        case .UInt16:
            byteSize    = indexCount * sizeof(UInt16)
            self.indexType = .UInt16
            break
            
        case .UInt32:
            byteSize    = indexCount * sizeof(UInt32)
            self.indexType = .UInt32
            break
            
        default:
            break
        }
    }
}

class MeshRenderer
{
    var transform:  Transform?
    var initialized     = false

    init(aTransform: Transform) {
        transform = aTransform
    }
    
    var mesh: Mesh?
    
    func initializeResources(context: MetalContext) {
        mesh = Mesh(filePath: "/Users/dannyvanswieten/Documents/Model/realship.obj", context: context)
    }
    
    func render(encoder: MTLRenderCommandEncoder) {
        mesh?.renderWithEncoder(encoder)
    }
}
