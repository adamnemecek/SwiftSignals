//
//  File.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/16/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation
import AppKit

enum TextureType {
    case TwoDimensional
    case Cube
}

class Texture {
    
    var desc = MTLTextureDescriptor()
    var texture: MTLTexture! = nil
    
    init(image: RawImage, type: TextureType){
        loadFromImage(image, type: type)
    }
    
    init(filePath: String, type: TextureType){
        loadFromFile(filePath, type: type)
    }
    
    private func loadFromFile(path: String, type: TextureType) {
        let image = RawImage(pathToFile: path)
        loadFromImage(image, type: type)
    }
    
    private func loadFromImage(image: RawImage, type: TextureType) {
        
        switch(type) {
        case .Cube:
            desc = MTLTextureDescriptor.textureCubeDescriptorWithPixelFormat(.RGBA8Unorm, size: image.width, mipmapped: false)
            texture = GameEngine.instance.device?.newTextureWithDescriptor(desc)
            for slice in 0..<6 {
                let region = MTLRegionMake2D(0, 0, image.width, image.width)
                let sliceSize = image.width * image.width
                
                texture.replaceRegion(region, mipmapLevel: texture.mipmapLevelCount, slice: slice, withBytes: image.data.advancedBy(slice * sliceSize * image.bytesPerPixel), bytesPerRow: image.bytesPerRow, bytesPerImage: sliceSize * image.bytesPerPixel)
            }
            
        case .TwoDimensional:
            desc = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(.RGBA8Unorm, width: image.width, height: image.height, mipmapped: true)
        }
    }
}