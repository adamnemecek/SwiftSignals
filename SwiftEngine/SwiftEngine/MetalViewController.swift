//
//  MetalViewController.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/25/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit

class MetalViewController: NSViewController, MTKViewDelegate {
    
    func drawInMTKView(view: MTKView) {
        GameEngine.instance.currentScene?.render()
    }
    
    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        print("resized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! MTKView
        view.delegate = self
        
        GameEngine.instance.setupGraphics(view)
        let obj = GameObject(aTitle: "First Object")
        obj.meshRenderer?.mesh = GameEngine.instance.resourceManager?.getModel("/Users/dannyvanswieten/Documents/Model/teapot.obj")
        obj.body = GameEngine.instance.physics.newBody(100)
        obj.behaviour = Behaviour(object: obj)
        GameEngine.instance.currentScene?.addObject(obj)
        GameEngine.instance.physics.start()
    }
    
    override func keyDown(theEvent: NSEvent) {
        let controller = GameEngine.instance.controller
        controller.keyPressed.addObject(theEvent.characters!)
    }
    
    override func keyUp(theEvent: NSEvent) {
        let controller = GameEngine.instance.controller
        controller.keyPressed.removeObject(theEvent.characters!)
    }
}