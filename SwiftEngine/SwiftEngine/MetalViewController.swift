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
        GameEngine.instance.currentScene?.render()
    }
    
    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        print("resized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! MetalView
        view.delegate = self
        
        GameEngine.instance.setupGraphics(view)
        
//        let camera = GameObject(aTitle: "Camera")
//        camera.behaviour = CameraBehaviour(object: camera)
//        GameEngine.instance.currentScene?.addObject(camera)
        
        let obj = GameObject(aTitle: "First Object")
        
        obj.renderer = MeshRenderer()
        obj.renderer?.mesh = GameEngine.instance.resourceManager?.getModel("/Users/dannyvanswieten/Documents/Model/Nanosuit/Nanosuit.obj")
        obj.renderer?.mesh?.material = Material()
        obj.renderer?.mesh?.material?.albedo = GameEngine.instance.resourceManager?.getTexture("/Users/dannyvanswieten/Documents/Model/Materials/BlueStone.jpg")
        obj.body = GameEngine.instance.physics.newBody(100)
        GameEngine.instance.currentScene?.addObject(obj)
        
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