//
//  SkinnedMesh.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit

//class SkinnedMesh2: Mesh {
//    
//    var meshes: [Mesh]?
//    
//    init(pathToFile: String) {
//        
//        let assetURL = NSURL(fileURLWithPath: pathToFile)
//        let allocator = MTKMeshBufferAllocator(device: GameEngine.instance.device!)
//        let mdlAsset = MDLAsset(URL: assetURL, vertexDescriptor: nil, bufferAllocator: allocator)
//        
//        for object in 0..<mdlAsset.count {
//            
//            let mdlMesh         = mdlAsset[object] as! MDLMesh
//            let mesh            = SkinnedMesh2()
//            mesh.vertexCount    = mdlMesh.vertexCount
//            let buffer          = mdlMesh.vertexBuffers[0] as! MTKMeshBuffer
//            mesh.byteSize       = buffer.length
//            mesh.vertexBuffer   = buffer.buffer
//            
//            for submesh in mdlMesh.submeshes {
//                if let m = mdlToBearSubMesh(submesh as! MDLSubmesh)
//                {
//                    m.parentMesh = mesh
//                    mesh.subMeshes.append(m)
//                }
//            }
//            
//            meshes.append(mesh)
//        }
//    }
//}
//
//class SkinnedSubMesh: SubMesh {
//    
//    init(anIndexBuffer: MTLBuffer, anIndexCount: Int, offset: Int ,type: MTLIndexType ,aMaterial: [String]) {
//        skin    = aMaterial
//        indexBuffer = anIndexBuffer
//        indexCount  = anIndexCount
//        indexType   = type
//        indexOffset = offset
//    }
//}
//
//func mdlToBearSubMesh(submesh: MDLSubmesh) -> SkinnedSubMesh? {
//    
//    var myMesh: SkinnedSubMesh?
//    let indexCount = submesh.indexCount
//    let mdlIndexType = submesh.indexType
//    var indexType: MTLIndexType = .UInt16
//    if mdlIndexType != .UInt16 {
//        indexType = .UInt32
//    }
//    var mat = [String]()
//    
//    if let material = submesh.material {
//        for materialIndex in 0..<material.count {
//            if let url = material[materialIndex]?.stringValue {
//                
//                mat.append(url)
//                let buffer = submesh.indexBuffer as! MTKMeshBuffer
//                myMesh = SkinnedSubMesh(anIndexBuffer: buffer.buffer, anIndexCount: indexCount, offset: buffer.offset, type: indexType, aMaterial: mat)
//            }
//        }
//    }
//    
//    return myMesh
//}