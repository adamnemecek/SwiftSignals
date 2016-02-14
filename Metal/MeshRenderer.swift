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
    var mesh: Mesh?
    var material: Material?
    
    var vertexDescriptor = defaultVertexDescriptor()
    var vertexShader = GameEngine.instance.graphicsContext?.library?.newFunctionWithName("default_vertex")
    var fragmentShader = GameEngine.instance.graphicsContext?.library?.newFunctionWithName("default_fragment")
    
    var pipelineState: MTLRenderPipelineState?
    var pipelineStateDescriptor = MTLRenderPipelineDescriptor()
    var commandBuffer: MTLCommandBuffer?
    var commandEncoder: MTLRenderCommandEncoder?
    var depthStateDescriptor = MTLDepthStencilDescriptor()
    var depthState: MTLDepthStencilState?
    
    func render() {
        
        pipelineStateDescriptor.vertexFunction   = vertexShader!
        pipelineStateDescriptor.fragmentFunction = fragmentShader!
        pipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
        
        let view = GameEngine.instance.graphicsContext?.metalView
        
        pipelineStateDescriptor.sampleCount = view!.sampleCount
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = view!.colorPixelFormat
        pipelineStateDescriptor.depthAttachmentPixelFormat      = view!.depthStencilPixelFormat
        pipelineStateDescriptor.stencilAttachmentPixelFormat    = view!.depthStencilPixelFormat
        
        depthStateDescriptor.depthCompareFunction   = .Less
        depthStateDescriptor.depthWriteEnabled      = true
        
        depthState = GameEngine.instance.graphicsContext!.device?.newDepthStencilStateWithDescriptor(depthStateDescriptor)
        
        do{
            pipelineState = try GameEngine.instance.graphicsContext!.device?.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
        } catch {}
        
        commandBuffer = GameEngine.instance.graphicsContext!.commandBuffer
        let desc = GameEngine.instance.graphicsContext!.renderPassDescriptor
        desc.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0)
        
        commandEncoder = commandBuffer?.renderCommandEncoderWithDescriptor(desc)
        commandEncoder?.setVertexBuffer(GameEngine.instance.currentScene?.uniformBuffer!, offset: 0, atIndex: 1)
        
        let vp = MTLViewport(originX: 0, originY: 0, width: Double((view?.drawableSize.width)!), height: Double((view?.drawableSize.height)!), znear: 0, zfar: 1)
        
        commandEncoder?.setViewport(vp)
        commandEncoder?.setDepthStencilState(depthState)
        commandEncoder?.setRenderPipelineState(pipelineState!)
        
        mesh?.renderWithEncoder(commandEncoder!)
        commandEncoder?.endEncoding()
    }
}