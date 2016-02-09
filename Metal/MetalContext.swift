//
//  MetalContext.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/16/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Cocoa
import MetalKit

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
    
    let vertexDescriptor = MTLVertexDescriptor()
    
    var renderPassDescriptor    = MTLRenderPassDescriptor()
    
    var pipelineIsDirty = true
    
    var commandBuffer: MTLCommandBuffer?
    var renderCommandEncoder: MTLRenderCommandEncoder?
    
    var vertexShader: MTLFunction?
    var fragmentShader: MTLFunction?
    
    var depthStateDescriptor = MTLDepthStencilDescriptor()
    var depthState: MTLDepthStencilState?
    
    var metalView: MTKView?
    
    init(view: MTKView) {
        
        metalView = view
        metalView!.device       = device!
        library                 = device?.newDefaultLibrary()
        commandQueue            = device?.newCommandQueue()
        
        vertexShader    = library?.newFunctionWithName("basic_vertex")
        fragmentShader  = library?.newFunctionWithName("basic_fragment")
        
        pipelineStateDescriptor.vertexFunction      = vertexShader
        pipelineStateDescriptor.fragmentFunction    = fragmentShader
        
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
        
        pipelineStateDescriptor.sampleCount = view.sampleCount;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat;
        pipelineStateDescriptor.depthAttachmentPixelFormat      = view.depthStencilPixelFormat;
        pipelineStateDescriptor.stencilAttachmentPixelFormat    = view.depthStencilPixelFormat;
        
        depthStateDescriptor.depthCompareFunction = .Less;
        depthStateDescriptor.depthWriteEnabled = true;
        depthState = device?.newDepthStencilStateWithDescriptor(depthStateDescriptor)
        
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
//
        // Single interleaved buffer.
        vertexDescriptor.layouts[0].stride = 32;
        vertexDescriptor.layouts[0].stepRate = 1;
        vertexDescriptor.layouts[0].stepFunction = .PerVertex;
        
        pipelineStateDescriptor.vertexDescriptor = vertexDescriptor;
    }
    
    func prepareToRender() {
        
        renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture    = metalView?.currentDrawable?.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .Clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.3, 0.0, 1.0)
        
        let err = AutoreleasingUnsafeMutablePointer<MTLAutoreleasedRenderPipelineReflection?>()
        do {
            pipelineState = try device!.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor , options: MTLPipelineOption.None, reflection: err)
        } catch {
            print("Failed to initialize new pipeline state")
            print(err)
            return
        }
        
        commandBuffer           = commandQueue?.commandBuffer()
        renderCommandEncoder    = commandBuffer?.renderCommandEncoderWithDescriptor(renderPassDescriptor)
        
        let vp = MTLViewport(originX: 0, originY: 0, width: Double((metalView?.drawableSize.width)!), height: Double((metalView?.drawableSize.height)!), znear: 0, zfar: 1)
        
        renderCommandEncoder?.setViewport(vp)
        
        renderCommandEncoder?.setRenderPipelineState(pipelineState!)
        renderCommandEncoder?.setDepthStencilState(depthState!)
        
        renderCommandEncoder?.setCullMode(.Back)
        renderCommandEncoder?.setFrontFacingWinding(.CounterClockwise)
    }
    
    func render() {
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.presentDrawable(metalView!.currentDrawable!)
        commandBuffer?.commit()
    }
}