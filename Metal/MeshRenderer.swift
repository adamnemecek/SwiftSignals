//
//  MeshRenderer.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit
import ModelIO

class SubMesh
{
    var name        = ""
    var indexCount  = 0
    var byteSize    = 0
    var indexBuffer = UnsafeMutablePointer<Void>()
    var indexType:MTLIndexType?
    
    init(aName: String, anIndexCount: Int, indexType: MDLIndexBitDepth, data: UnsafeMutablePointer<Void>) {
        name        = aName
        indexCount  = anIndexCount
        indexBuffer = data
        switch(indexType) {
        case .UInt16:
            byteSize    = indexCount * sizeof(UInt16)
            self.indexType = .UInt16
            break
            
        case .UInt32:
            byteSize    = indexCount * sizeof(UInt32)
            self.indexType = .UInt32
            break
            
        default:
            break
        }
    }
}

class Mesh
{
    var vertexCount = 0
    var byteSize    = 0
    
    var children    = [SubMesh]()
    var buffer      = UnsafeMutablePointer<Void>()
    
    var layout      = VertexLayout()
    
    init() {
        
    }
    
    init(fromFile: String) {
        let url = NSURL(fileURLWithPath: fromFile)
        let asset = MDLAsset(URL: url)
        
        for index in 0..<asset.count {
            let aMesh   = asset[index] as! MDLMesh
            
            vertexCount    = aMesh.vertexCount
            byteSize = aMesh.vertexBuffers[0].length
            buffer = aMesh.vertexBuffers[0].map().bytes
            
            for subMesh in aMesh.submeshes {
                let aSubMesh = subMesh as! MDLSubmesh
                children.append(SubMesh(aName: aSubMesh.name, anIndexCount: aSubMesh.indexCount, indexType: aSubMesh.indexType ,data: aSubMesh.indexBuffer.map().bytes))
            }
                        
            for attribute in aMesh.vertexDescriptor.attributes{
                let att = attribute as! MDLVertexAttribute
                if att.name != "" {
                    var attSize = 0
                    print("\(att.format)")
                    switch(att.format) {
                    case .Float4:
                        attSize = sizeof(Float) * 4
                        break
                        
                    case .Float3:
                        attSize = sizeof(Float) * 3
                        break
                        
                    case .Float2:
                        attSize = sizeof(Float) * 2
                        break
                        
                    case .Invalid:
                        print("Invalid data type for vertex")
                        break
                    default:
                        break
                    }
                    
                    let newAttribute = VertexAttribute(name: att.name, size: attSize, offset: att.offset)
                    layout.attributes.append(newAttribute)
                }
            }
        }
    }
}

class MeshRenderer: MetalRenderer
{
    var transform:  Transform?
    var initialized     = false
    
    var mesh: Mesh!     = nil
    
    var vertexBuffer: MTLBuffer?
    var indexBuffers: [MTLBuffer]?
    
    var descriptor: MTLVertexDescriptor?
    var uniformBuffer: MTLBuffer?
    
    init(aTransform: Transform) {
        transform = aTransform
    }
    
    func initializeResources(context: MetalContext) {
        
        descriptor = context.vertexDescriptor
        loadAsset("/Users/dannyvanswieten/Documents/Model/realship.obj")
        vertexBuffer = context.device?.newBufferWithBytes(mesh.buffer, length: mesh.byteSize, options: .CPUCacheModeDefaultCache)
        indexBuffers = [MTLBuffer]()
        for child in mesh.children {
            let newBuffer = context.device?.newBufferWithBytes(child.indexBuffer, length: child.byteSize, options: .CPUCacheModeDefaultCache)
            
            indexBuffers?.append(newBuffer!)
        }
        
        uniformBuffer = context.device?.newBufferWithLength(sizeof(Transform), options: .CPUCacheModeDefaultCache)
    }
    
    func loadAsset(path: String) {
        mesh = Mesh(fromFile: path)
        initialized = true
    }
    
    func loadAsset(aMesh: Mesh) {
        mesh = aMesh
        initialized = true
    }
    
    func render(commandEncoder: CommandEncoder) {
         memcpy(uniformBuffer!.contents(), toPointer(transform), sizeof(Transform))
        
        commandEncoder.commandEncoder?.setVertexBuffer(uniformBuffer, offset: 0, atIndex: 1)
        commandEncoder.commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
        for child in 0..<mesh.children.count {
            commandEncoder.commandEncoder?.drawIndexedPrimitives(.Triangle, indexCount: mesh.children[child].indexCount, indexType: mesh.children[child].indexType!, indexBuffer: indexBuffers![child], indexBufferOffset: 0)
        }
    }
}