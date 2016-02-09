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
            encoder.setVertexBuffer(buffer.buffer, offset: buffer.offset, atIndex: 0)
            bufferIndex++
        }
        
        for submesh in submeshes {
            encoder.drawIndexedPrimitives(.Triangle, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer.buffer, indexBufferOffset: submesh.indexBuffer.offset)
        }
    }
}

class Mesh {
    
    var meshes = [MTKMesh]()
    
    init(filePath: String, context: MetalContext){
        
        let assetURL = NSURL(fileURLWithPath: filePath)
        let allocator = MTKMeshBufferAllocator(device: context.device!)

        let mdlVertexDescriptor = MTKModelIOVertexDescriptorFromMetal(context.vertexDescriptor);
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