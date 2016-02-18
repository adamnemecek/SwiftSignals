//
//  MeshRenderer.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit
import ModelIO

protocol Renderer {
    var mesh: Mesh?{set get}
    func setTransform(aTransform: float4x4)
    func prepareToRender() -> Void
    func render() -> Void
}

protocol NewRenderer {
    var meshes: [Mesh]{set get}
    func setTransform(aTransform: float4x4)
    func prepareToRender() -> Void
    func render() -> Void
}

class NewMeshRenderer: NewRenderer {
    
    var meshes: [Mesh]
    
    init() {
        meshes = [Mesh]()
    }
    
    func setTransform(aTransform: float4x4) {
        
    }
    func prepareToRender() -> Void {
        
    }
    func render() -> Void {
        
    }
}

class MeshRenderer: Renderer
{
    var mesh: Mesh?
    var transform = Matrix4x4.matrix_translation(0, y: 0, z: 0)
    
    var vertexDescriptor = defaultVertexDescriptor()
    var vertexShader = GameEngine.instance.graphicsContext?.library?.newFunctionWithName("default_vertex")
    var fragmentShader = GameEngine.instance.graphicsContext?.library?.newFunctionWithName("default_fragment")
    
    var pipelineState:              MTLRenderPipelineState?
    var pipelineStateDescriptor =   MTLRenderPipelineDescriptor()
    var commandBuffer:              MTLCommandBuffer?
    var commandEncoder:             MTLRenderCommandEncoder?
    var depthStateDescriptor =      MTLDepthStencilDescriptor()
    var depthState:                 MTLDepthStencilState?
    var view:                       MetalView?
    
    func setTransform(aTransform: float4x4) {
        transform = aTransform
    }
    
    func prepareToRender() {
        
        pipelineStateDescriptor.vertexFunction   = vertexShader!
        pipelineStateDescriptor.fragmentFunction = fragmentShader!
        pipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        
        view = GameEngine.instance.graphicsContext?.metalView
        
        pipelineStateDescriptor.sampleCount = view!.sampleCount
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = view!.colorPixelFormat
        pipelineStateDescriptor.depthAttachmentPixelFormat      = view!.depthStencilPixelFormat
        pipelineStateDescriptor.stencilAttachmentPixelFormat    = view!.depthStencilPixelFormat
        
        depthStateDescriptor.depthCompareFunction   = .Less
        depthStateDescriptor.depthWriteEnabled      = true
        
        depthState = GameEngine.instance.graphicsContext!.device?.newDepthStencilStateWithDescriptor(depthStateDescriptor)
        
        do{
            pipelineState = try GameEngine.instance.graphicsContext!.device?.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
        } catch {print("Something, somewhere went terribly wrong")}
        
        commandBuffer = GameEngine.instance.graphicsContext!.commandQueue?.commandBuffer()
        let desc = GameEngine.instance.graphicsContext!.renderPassDescriptor
        desc.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0)
        
        commandEncoder = commandBuffer?.renderCommandEncoderWithDescriptor(desc)
        commandEncoder?.setVertexBuffer(GameEngine.instance.currentScene?.uniformBuffer!, offset: 0, atIndex: 1)
        
        let vp = MTLViewport(originX: 0, originY: 0, width: Double((view?.drawableSize.width)!), height: Double((view?.drawableSize.height)!), znear: 0, zfar: 1)
        
        commandEncoder?.setViewport(vp)
        commandEncoder?.setDepthStencilState(depthState)
        commandEncoder?.setRenderPipelineState(pipelineState!)
    }
    
    func render() {
        
//        commandEncoder?.setFragmentTexture(mesh?.material?.albedo, atIndex: 0)
        mesh?.renderWithEncoder(commandEncoder!)
        commandEncoder?.endEncoding()
        commandBuffer?.presentDrawable(view!.currentDrawable!)
        commandBuffer?.commit()
    }
}