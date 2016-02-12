//
//  MeshLoader.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/8/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit

extension MTKMesh {
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

class Mesh {
    
    var meshes = [MTKMesh]()
    
    init(filePath: String, var vertexDescriptor: MTLVertexDescriptor?, context: MetalContext){
        
        let assetURL = NSURL(fileURLWithPath: filePath)
        let allocator = MTKMeshBufferAllocator(device: context.device!)

        if vertexDescriptor == nil {
            vertexDescriptor = defaultVertexDescriptor()
        }
        
        let mdlVertexDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor!);
        var name = mdlVertexDescriptor.attributes[0] as! MDLVertexAttribute
        name.name = MDLVertexAttributePosition
        name = mdlVertexDescriptor.attributes[1] as! MDLVertexAttribute
        name.name = MDLVertexAttributeNormal
        name = mdlVertexDescriptor.attributes[2] as! MDLVertexAttribute
        name.name = MDLVertexAttributeTextureCoordinate
        let asset = MDLAsset(URL: assetURL, vertexDescriptor: mdlVertexDescriptor, bufferAllocator: allocator)
        
        do {
            let array = AutoreleasingUnsafeMutablePointer<NSArray?>()
            meshes = try MTKMesh.newMeshesFromAsset(asset, device: context.device!, sourceMeshes: array)
                
        } catch {print(error)}
    }
    
    func renderWithEncoder(encoder: MTLRenderCommandEncoder){
        for mesh in meshes {
            mesh.renderWithEncoder(encoder)
        }
    }
}