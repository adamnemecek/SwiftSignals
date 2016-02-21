//
//  MeshRenderer.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit
import ModelIO

class MeshRenderer: Renderable
{
    var device: MTLDevice?
    
    var mesh: Renderable?
    private var attributes: [MTLVertexAttribute]?
    
    var transform = Matrix4x4.matrix_translation(0, y: 0, z: 0)
    
    private var vertexShader: MTLFunction?
    
    var pipelineStateDescriptor =   MTLRenderPipelineDescriptor()
    var pipelineState:              MTLRenderPipelineState?
    var depthStateDescriptor =      MTLDepthStencilDescriptor()
    var depthState:                 MTLDepthStencilState?
    
    var material:                   Material?
    
    var isDirty = true
    
    init(device: MTLDevice) {
        self.device = device
        if let shader = Shader.fromJson("/Users/dannyvanswieten/Desktop/shader.json"){
            material = Material(aShader: shader)
        }
    }
    
    func setVertexShader(function: MTLFunction) {
        vertexShader = function
        attributes = vertexShader?.vertexAttributes
        isDirty = true
    }
    
    func setTransform(aTransform: float4x4) {
        transform = aTransform
    }
    
    func prepareToRender() {
        
        if isDirty {
        
            let view = GameEngine.instance.view
            
            pipelineStateDescriptor.vertexFunction   = vertexShader
            pipelineStateDescriptor.fragmentFunction = material?.fragmentShader
            
            pipelineStateDescriptor.sampleCount = view!.sampleCount
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = view!.colorPixelFormat
            pipelineStateDescriptor.depthAttachmentPixelFormat      = view!.depthStencilPixelFormat
            pipelineStateDescriptor.stencilAttachmentPixelFormat    = view!.depthStencilPixelFormat
            
            depthStateDescriptor.depthCompareFunction   = .Less
            depthStateDescriptor.depthWriteEnabled      = true
            
            depthState = GameEngine.instance.device?.newDepthStencilStateWithDescriptor(depthStateDescriptor)
            
            do{
                pipelineState = try device?.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
            } catch {print("Something, somewhere went terribly wrong")}
            
            isDirty = false
        }
    }
    
    func renderWithEncoder(commandEncoder: MTLRenderCommandEncoder)
    {
        commandEncoder.setDepthStencilState(depthState)
        commandEncoder.setRenderPipelineState(pipelineState!)
        
        mesh?.renderWithEncoder(commandEncoder)
    }
}