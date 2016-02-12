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
    
    var context: MetalContext?
    var mesh: Mesh?
    
    init(aContext: MetalContext) {
        context = aContext
    }
    
    func render(encoder: MTLRenderCommandEncoder) {
        mesh?.renderWithEncoder(encoder)
    }
}
