//
//  MetalView.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/15/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit

class MetalView: MTKView {
    
    var numMoved = 0
    
    override func mouseMoved(theEvent: NSEvent) {
        
        let global = theEvent.locationInWindow
        GameEngine.instance.controller.setMouse(self.convertPoint(global, fromView: nil))
    }
}
