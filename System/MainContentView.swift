//
//  MainContentView.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/12/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Cocoa

class MainContentView: NSView {
    
    var content: Widget?
    var graphicsContext: GraphicsContext?
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        content?.onPaint(graphicsContext!)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let position = Position(x: Float(theEvent.locationInWindow.x), y: Float(theEvent.locationInWindow.y))
        content!.onMouseDown(position)
    }
}
