//
//  MetalContext.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/16/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit

struct Projection {
    var model       = float4x4()
    var view        = float4x4()
    var projection  = float4x4()
    
    var modelView   = float4x4()
}

func defaultVertexDescriptor() -> MTLVertexDescriptor {
    
    let vertexDescriptor = MTLVertexDescriptor()
    
    // Positions.
    vertexDescriptor.attributes[0].format = .Float3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    
    // Normals.
    vertexDescriptor.attributes[1].format = .Float3;
    vertexDescriptor.attributes[1].offset = 12;
    vertexDescriptor.attributes[1].bufferIndex = 0;
    
    // Texture coordinates.
    vertexDescriptor.attributes[2].format = .Float2;
    vertexDescriptor.attributes[2].offset = 24;
    vertexDescriptor.attributes[2].bufferIndex = 0;
    
    // Single interleaved buffer.
    vertexDescriptor.layouts[0].stride = 32;
    vertexDescriptor.layouts[0].stepRate = 1;
    vertexDescriptor.layouts[0].stepFunction = .PerVertex;
    
    return vertexDescriptor
}

class MetalContext: GpuGraphicsContext
{
    /// This is the device that is used for rendering. Initialized to system default device
    var device  = MTLCreateSystemDefaultDevice()
    /// The library used to load shaders. This is initialized to default library provided by the currently used device.
    var library: MTLLibrary?
    /// Describes pipeline parameters.
    var pipelineState: MTLRenderPipelineState?
    
    var commandQueue: MTLCommandQueue?
    
    var pipelineStateDescriptor = MTLRenderPipelineDescriptor()
    
    var vertexDescriptor = MTLVertexDescriptor()
    
    var renderPassDescriptor    = MTLRenderPassDescriptor()
    
    var pipelineIsDirty = true
    
    var commandBuffer: MTLCommandBuffer?
    var renderCommandEncoder: MTLRenderCommandEncoder?
    
    var vertexShader: MTLFunction?
    var fragmentShader: MTLFunction?
    
    var depthStateDescriptor = MTLDepthStencilDescriptor()
    var depthState: MTLDepthStencilState?
    
    var metalView: MetalView?
    
    var projection = Projection()
    var uniformBuffer: MTLBuffer?
    
    var clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0)
    
    init(view: MetalView) {
        
        metalView = view
        metalView!.device = device!
        metalView?.depthStencilPixelFormat = .Depth32Float_Stencil8
        metalView?.sampleCount = 4
        commandQueue = device?.newCommandQueue()
        library = device?.newDefaultLibrary()
    }
    
    func prepareToRender() {
        renderPassDescriptor = (metalView?.currentRenderPassDescriptor)!
        renderPassDescriptor.colorAttachments[0].clearColor = clearColor
        renderPassDescriptor.depthAttachment.storeAction = .Store
        renderPassDescriptor.depthAttachment.loadAction = .Clear
    }
    
    func render() {

    }
}