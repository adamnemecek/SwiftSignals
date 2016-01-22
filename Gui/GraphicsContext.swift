//
//  GraphicsContext.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/12/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

protocol GraphicsContext {
    
    func save() -> Void
    func restore() -> Void
    func fillRect(xPos: Float, yPos: Float, width: Float, height: Float) -> Void
    func fillRect(rect: Rectangle) -> Void
    func setColour(r: Float, g: Float, b: Float, a: Float)
    func translate(x: Float, y: Float) -> Void
    func drawText(text: String, position: Position, size: Float, font: String)
    func drawTextInRectangle(text: String, rect: Rectangle, size: Float, font: String)
    func drawGradientInRectangle()
}