//
//  MeshRenderer.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit
import ModelIO

class MeshRenderer
{
    var initialized     = false
    
    var mesh: Mesh?
    
    func initializeResources(context: MetalContext) {
        mesh = Mesh(filePath: "/Users/dannyvanswieten/Documents/Model/teapot.obj", vertexDescriptor: nil, context: context)
    }
    
    func render(encoder: MTLRenderCommandEncoder) {
        mesh?.renderWithEncoder(encoder)
    }
}
