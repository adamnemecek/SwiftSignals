//
//  Image.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/21/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import AppKit

struct RawImage {
    
    var width           = 0
    var height          = 0
    var bitsPerPixel    = 0
    var bytesPerPixel   = 0
    var hasAlpha        = false
    var sizeInBytes     = 0
    var bytesPerRow     = 0
    
    var data            = UnsafeMutablePointer<Void>()
    
    init(fromNSImage: NSImage){
        
        let imageData   = fromNSImage.TIFFRepresentation
        let source      = CGImageSourceCreateWithData(imageData! as CFDataRef, nil)
        let mask        = CGImageSourceCreateImageAtIndex(source!, 0, nil)
        
        if mask == nil {
            return
        }
        
        width = CGImageGetWidth(mask!);
        height = CGImageGetHeight(mask!);
        bitsPerPixel = CGImageGetBitsPerPixel(mask!);
        bytesPerPixel   = bitsPerPixel / 8
        hasAlpha = CGImageGetAlphaInfo(mask!) == .None ? false: true
        sizeInBytes = width * height * bitsPerPixel / 8;
        bytesPerRow = width * bitsPerPixel / 8;
        
        data = malloc(sizeInBytes);
        
    }
    
    init(pathToFile: String) {
        let image   = NSImage(contentsOfFile: pathToFile)
        
        if image == nil {
            return
        }
        
        let imageData   = image?.TIFFRepresentation
        let source      = CGImageSourceCreateWithData(imageData! as CFDataRef, nil)
        let mask        = CGImageSourceCreateImageAtIndex(source!, 0, nil)
        
        if mask == nil {
            return
        }
        
        width = CGImageGetWidth(mask!);
        height = CGImageGetHeight(mask!);
        bitsPerPixel = CGImageGetBitsPerPixel(mask!);
        bytesPerPixel   = bitsPerPixel / 8
        hasAlpha = CGImageGetAlphaInfo(mask!) == .None ? false: true
        sizeInBytes = width * height * bitsPerPixel / 8;
        bytesPerRow = width * bitsPerPixel / 8;
        
        data = malloc(sizeInBytes);
    }
}