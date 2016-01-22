//
//  OsxGraphicsContext.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/12/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Cocoa

class OsxGraphicsContext: GraphicsContext {
    
    var ctx: CGContextRef?
    
    init(ctx: CGContextRef) {
        self.ctx = ctx
    }
    
    func save() {
        CGContextSaveGState(ctx)
    }
    
    func restore() {
        CGContextRestoreGState(ctx)
    }
    
    func setColour(r: Float, g: Float, b: Float, a: Float) {
        CGContextSetRGBFillColor(ctx, CGFloat(r), CGFloat(g), CGFloat(b), CGFloat(a))
    }
    
    func fillRect(xPos: Float, yPos: Float, width: Float, height: Float) {
        CGContextFillRect(ctx, CGRectMake(CGFloat(xPos), CGFloat(yPos), CGFloat(width), CGFloat(height)))
    }
    
    func fillRect(rect: Rectangle) {
        CGContextFillRect(ctx, CGRectMake(CGFloat(rect.position.x), CGFloat(rect.position.y), CGFloat(rect.size.width), CGFloat(rect.size.height)))
    }
    
    func translate(x: Float, y: Float) {
        CGContextTranslateCTM(ctx, CGFloat(x), CGFloat(y))
    }
    
    func drawText(text: String, position: Position, size: Float, font: String) {
        let point = NSPoint(x: CGFloat(position.x), y: CGFloat(position.y))
        let string:  NSString = text
        
        let font = NSFont(name: font, size: CGFloat(size))
        let baselineAdjust = 1.0
        let attrsDictionary =  [NSFontAttributeName:font!, NSBaselineOffsetAttributeName:baselineAdjust] as [String : AnyObject]
        string.drawAtPoint(point, withAttributes: attrsDictionary)
    }
    
    func drawTextInRectangle(text: String, rect: Rectangle, size: Float, font: String) {
        
        let rectangle = CGRectMake(CGFloat(rect.position.x), CGFloat(rect.position.y), CGFloat(rect.size.width), CGFloat(rect.size.height))
        let string:  NSString = text
        let font = NSFont(name: font, size: CGFloat(size))
        let baselineAdjust = 1.0
        let attrsDictionary =  [NSFontAttributeName:font!, NSBaselineOffsetAttributeName:baselineAdjust] as [String : AnyObject]
        
        string.drawInRect(rectangle, withAttributes: attrsDictionary)
    }
    
    func drawGradientInRectangle() {
        
//        var c1 = CGColorCreateGenericRGB(1.0, 1.0, 0.0, 1.0)
//        var c2 = CGColorCreateGenericRGB(0.0, 1.0, 0.0, 1.0)
//        
//        var ptr = UnsafeMutablePointer<CGColor>.alloc(2)
//        
//        let arr = CFArrayCreate(kCFAllocatorDefault, 
//        
//        CGGradientCreateWithColors(kCGColorSpaceGenericRGBLinear, <#T##colors: CFArray?##CFArray?#>, <#T##locations: UnsafePointer<CGFloat>##UnsafePointer<CGFloat>#>)
//        CGContextDrawLinearGradient(ctx!, CGGradient?, CGPoint, CGPoint, CGGradientDrawingOptions)
    }
}
