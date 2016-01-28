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
    /// Special subclass of CALayer to render on.
    var layer   = CAMetalLayer()
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
    var commandEncoder = CommandEncoder()
    
    var vertexShader: MetalShader?
    var fragmentShader: MetalShader?
    
    var metalView: MTKView?
    
    init(view: MTKView) {
        
        metalView = view
        metalView!.device       = device!
        library                 = device?.newDefaultLibrary()
        commandQueue            = device?.newCommandQueue()
        
        vertexShader    = MetalShader(library: library!, name: "basic_vertex")
        fragmentShader  = MetalShader(library: library!, name: "basic_fragment")
        
        pipelineStateDescriptor.vertexFunction      = vertexShader?.shader
        pipelineStateDescriptor.fragmentFunction    = fragmentShader?.shader
        
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
        
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
        
        pipelineStateDescriptor.vertexDescriptor = vertexDescriptor
    }
    
    func createBuffer<T>(data: [T], layout: VertexLayout) -> MetalBuffer<T> {
        return MetalBuffer(device: device!, data: data, aLayout: layout)
    }
    
    func createBuffer(meshBuffer: MDLMeshBufferData) -> MetalBuffer<Float>{
        let temp = device?.newBufferWithBytes(meshBuffer.data.bytes, length: meshBuffer.length, options:.CPUCacheModeDefaultCache)
        
        return MetalBuffer(aBuffer: temp!)
    }
    
    func createIndexBuffer(meshBuffer: MDLMeshBufferData) -> MetalBuffer<UInt32>{
        let temp = device?.newBufferWithBytes(meshBuffer.data.bytes, length: meshBuffer.length, options:.CPUCacheModeDefaultCache)
        
        return MetalBuffer(aBuffer: temp!)
    }
    
    func useShader(name: String) -> MetalShader {
        pipelineIsDirty = true
        return MetalShader(library: library!, name: name)
    }
    
    func prepareToRender() {
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
        renderCommandEncoder?.setRenderPipelineState(pipelineState!)
        
        commandEncoder.commandEncoder = renderCommandEncoder!
        commandEncoder.commandEncoder?.setCullMode(.Back)
        commandEncoder.commandEncoder?.setFrontFacingWinding(.CounterClockwise)
    }
    
    func render() {
        
        commandEncoder.commandEncoder?.endEncoding()
        commandBuffer?.presentDrawable(metalView!.currentDrawable!)
        commandBuffer?.commit()
    }
}

struct VertexAttribute
{
    var name = ""
    var size = 0
    var offset = 0
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
    var vertexCount: UInt64 = 0
    
    var size = 0
    
    init(device: MTLDevice, data: [VertexType], aLayout: VertexLayout) {
        
        layout      = aLayout
        origData    = data
        buffer      = device.newBufferWithBytes(data, length: sizeof(VertexType) * data.count, options: .CPUCacheModeDefaultCache)
        
        size = data.count * sizeof(VertexType)
    }
    
    init(aBuffer: MTLBuffer) {
        buffer = aBuffer
        size = (buffer?.length)!
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
        let size = buffer.size / sizeof(T) / 9
        commandEncoder!.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: size)
    }
    
    func renderIndexBuffer<T>(vertexBuffer: MetalBuffer<T>, indexBuffer: MetalBuffer<UInt32>) {
        
        commandEncoder!.setVertexBuffer(vertexBuffer.buffer, offset: 0, atIndex: 0)
        commandEncoder!.drawIndexedPrimitives(.Triangle, indexCount: indexBuffer.size / sizeof(UInt32), indexType: .UInt32, indexBuffer: indexBuffer.buffer!, indexBufferOffset: 0)
    }
}

class MetalPipelineState
{
    var state: MTLRenderPipelineState?
}