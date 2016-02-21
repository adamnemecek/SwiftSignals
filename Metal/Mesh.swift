//
//  MeshLoader.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/8/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit

protocol Renderable {
    func renderWithEncoder(commandEncoder: MTLRenderCommandEncoder)
}

extension MTKMesh: Renderable {
    
    func renderWithEncoder(encoder: MTLRenderCommandEncoder) {
        var bufferIndex = 0
        for buffer in vertexBuffers{
            encoder.setVertexBuffer(buffer.buffer, offset: buffer.offset, atIndex: bufferIndex)
            bufferIndex++
        }
        
        for submesh in submeshes {
            encoder.drawIndexedPrimitives(submesh.primitiveType, indexCount: submesh.indexCount, indexType: .UInt32, indexBuffer: submesh.indexBuffer.buffer, indexBufferOffset: submesh.indexBuffer.offset)
        }
    }
}

class Mesh: Renderable {
    
    var vertexBuffer: MTLBuffer?
    var vertexCount = 0
    var byteSize    = 0
    var subMeshes = [SubMesh]()
    
    func renderWithEncoder(commandEncoder: MTLRenderCommandEncoder) {
        
        commandEncoder.setVertexBuffer(vertexBuffer!, offset: 0, atIndex: 0)
        
        for submesh in subMeshes {
            submesh.renderWithEncoder(commandEncoder)
        }
    }
}

class SubMesh: Renderable {
    
    var parentMesh: Mesh?
    var indexType: MTLIndexType?
    var indexBuffer: MTLBuffer?
    var indexCount  = 0
    var indexOffset = 0
    
    init(anIndexBuffer: MTLBuffer, anIndexCount: Int, offset: Int ,type: MTLIndexType) {
        indexBuffer = anIndexBuffer
        indexCount  = anIndexCount
        indexType   = type
        indexOffset = offset
    }
    
    func renderWithEncoder(commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.drawIndexedPrimitives(.Triangle, indexCount: indexCount, indexType: indexType!, indexBuffer: indexBuffer!, indexBufferOffset: indexOffset)
    }
}