//
//  Controller.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/10/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation
import AppKit

/// The controller class is a singleton that is used to keep track of key and mouse events.
class Controller {
    
    var keyPressed = NSMutableSet()
    
    var mouseX      = Float(0.0)
    var mouseY      = Float(0.0)
    
    var prevMouseX  = Float(0.0)
    var prevMouseY  = Float(0.0)
    
    var deltaMouseX = Float(0.0)
    var deltaMouseY = Float(0.0)
    
    init() {

    }
    
    func isKeyPressed(key: String) -> Bool {
        return keyPressed.containsObject(key)
    }
    
    func setMouse(event: NSPoint){
        
        mouseX = Float(event.x)
        mouseY = Float(event.y)
        
        deltaMouseX = mouseX - prevMouseX
        deltaMouseY = mouseY - prevMouseY
        
        prevMouseX = mouseX
        prevMouseY = mouseY
    }
}