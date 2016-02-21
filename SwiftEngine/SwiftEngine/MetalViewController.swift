//
//  MetalViewController.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/25/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit
import AppKit

class MetalViewController: NSViewController, MTKViewDelegate {
    
    func drawInMTKView(view: MTKView) {
        GameEngine.instance.render()
    }
    
    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! MetalView
        view.delegate = self
        
        GameEngine.instance.setupGraphics(view)
        GameEngine.instance.physics.start()
    }
    
    override func keyDown(theEvent: NSEvent) {
        let controller = GameEngine.instance.controller
        if theEvent.characters! != ""{
            controller.keyPressed.addObject(theEvent.characters!)
        }
        
        switch(theEvent.keyCode) {
        case 56:
            controller.keyPressed.addObject("shift")
        default:
            return
        }
    }
    
    override func keyUp(theEvent: NSEvent) {
        let controller = GameEngine.instance.controller
        controller.keyPressed.removeObject(theEvent.characters!)
    }
}