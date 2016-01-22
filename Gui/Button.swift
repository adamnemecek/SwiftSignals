//
//  Button.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/13/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

class TextButton: Widget
{
    var text = String()
    var action: Void -> Void = {}
    
    init(text: String) {
        self.text = text
    }
    
    override func paint(context: GraphicsContext) {
        
        context.setColour(0.0, g: 1.0, b: 0.0, a: 1.0)
        context.fillRect(bounds)
        context.drawTextInRectangle(text, rect: bounds, size: 15.0, font: "Georgia")
    }
    
    final override func mouseDown(position: Position) {
        action()
    }
}