//
//  MetalContext.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/16/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Cocoa
import Metal
import QuartzCore

class MetalContext: GpuGraphicsContext
{
    /// This is the device that is used for rendering. Initialized to system default device
    var device  = MTLCreateSystemDefaultDevice()
    /// Special subclass of CALayer to render on.
    var layer   = CAMetalLayer()
    /// The library used to load shaders. This is initialized to default library provided by the currently used device.
    var library: MTLLibrary?
    /// Describes pipeline parameters.
    var pipelineState: MTLRenderPipelineState?
    
    var commandQueue: MTLCommandQueue?
    
    var pipelineStateDescriptor = MTLRenderPipelineDescriptor()
    
    var renderPassDescriptor    = MTLRenderPassDescriptor()
    
    var pipelineIsDirty = true
    
    var commandBuffer: MTLCommandBuffer?
    var renderCommandEncoder: MTLRenderCommandEncoder?
    var commandEncoder = CommandEncoder()
    
    var vertexShader: MetalShader?
    var fragmentShader: MetalShader?
    
    init(view: NSView) {
        layer.device            = device
        layer.pixelFormat       = .BGRA8Unorm
        layer.framebufferOnly   = true
        layer.frame             = view.frame
        view.layer              = layer
        
        library                 = device?.newDefaultLibrary()
        commandQueue            = device?.newCommandQueue()
        
        vertexShader    = MetalShader(library: library!, name: "basic_vertex")
        fragmentShader  = MetalShader(library: library!, name: "basic_fragment")
        
        pipelineStateDescriptor.vertexFunction      = vertexShader?.shader
        pipelineStateDescriptor.fragmentFunction    = fragmentShader?.shader
        
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
    }
    
    func createBuffer<T>(data: [T], layout: VertexLayout) -> MetalBuffer<T> {
        return MetalBuffer(device: device!, data: data, layout: layout)
    }
    
    func useShader(name: String) -> MetalShader {
        pipelineIsDirty = true
        return MetalShader(library: library!, name: name)
    }
    
    func prepareToRender() {
        let drawable = layer.nextDrawable()
        renderPassDescriptor.colorAttachments[0].texture    = drawable?.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .Clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0.0)
        
        do {
            pipelineState = try device!.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
        } catch {
            print("Failed to initialize new pipeline state")
        }
        
        commandBuffer           = commandQueue?.commandBuffer()
        renderCommandEncoder    = commandBuffer?.renderCommandEncoderWithDescriptor(renderPassDescriptor)
        renderCommandEncoder?.setRenderPipelineState(pipelineState!)
        
        commandEncoder.commandEncoder = renderCommandEncoder!
    }
    
    func render() {
        
    }
}

struct VertexAttribute
{
    var name = ""
    var size = 0
}

class VertexLayout
{
    var attributes = [VertexAttribute]()
    
    func numAttributes() -> Int {
        return attributes.count
    }
    
    func byteSize() -> Int {
        var sum = 0
        for attribute in attributes {
            sum += attribute.size
        }
        
        return sum
    }
}

class MetalBuffer<VertexType>
{
    var buffer: MTLBuffer?
    var origData: [VertexType]?
    var layout: VertexLayout?
    
    init(device: MTLDevice, data: [VertexType], layout: VertexLayout) {
        origData = data
        buffer = device.newBufferWithBytes(data, length: sizeof(VertexType) * data.count, options: .CPUCacheModeDefaultCache)
    }
}

class MetalShader
{
    var shader: MTLFunction?
    init(library: MTLLibrary, name: String)
    {
        shader = library.newFunctionWithName(name)
    }
}

class CommandEncoder
{
    var commandEncoder: MTLRenderCommandEncoder?
    
    func renderBuffer<T>(buffer: MetalBuffer<T>) -> Void {
        commandEncoder!.setVertexBuffer(buffer.buffer, offset: 0, atIndex: 0)
        let size = buffer.origData!.count / (buffer.layout?.byteSize())!
        commandEncoder!.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: size)
    }
}

class MetalPipelineState
{
    var state: MTLRenderPipelineState?
}