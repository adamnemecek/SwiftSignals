//
//  Widget.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/13/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

class Widget
{
    private var children    = [Widget]()
    var bounds = Rectangle()
    
    private var transform   = CGAffineTransform()
    
    final func onPaint(context: GraphicsContext) -> Void {
        
        context.save()
        context.translate(bounds.position.x, y: bounds.position.y)
        
        paint(context)
        
        for child in children {
            child.onPaint(context)
        }
        
        context.restore()
    }
    
    func paint(context: GraphicsContext) -> Void {
        
    }
    
    final func addChild(child: Widget) {
        children.append(child)
    }
    
    final func onMouseDown(position: Position) -> Void {
        for child in children {
            if(child.hitTest(position - child.bounds.position)) {
                child.onMouseDown(position)
                return
            }
        }
        
        mouseDown(position)
    }
    
    func mouseDown(position: Position) -> Void {
        print(self)
    }
    
    final func hitTest(position: Position) -> Bool {
        return bounds.isPointWithinRectangle(position)
    }
    
    func setBounds(bounds: Rectangle) -> Void {
        self.bounds = bounds
    }
    
    func setBounds(xPos: Float, yPos: Float, width: Float, height: Float) -> Void {
        bounds.position.x   = xPos
        bounds.position.y   = yPos
        bounds.size.width   = width
        bounds.size.height  = height
    }
}