//
//  MetalViewController.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/25/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit

class MetalViewController: NSViewController, MTKViewDelegate {

    var ctx: MetalContext!  = nil
    var metalView: MTKView! = nil
    var scene = Scene()
    
    func metalSetup() {
        metalView = self.view as! MTKView
        metalView!.delegate = self
        ctx = MetalContext(view: metalView)
    }
    
    func drawInMTKView(view: MTKView) {
//        ctx.prepareToRender()
//        scene.update(ctx)
//        ctx.render()
    }
    
    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
//        let aspect = Float(fabs(self.view.bounds.size.width / self.view.bounds.size.height))
//        ctx.projection.projection = Matrix4x4.matrix_from_perspective_fov_aspectLH(65.0 * Float((M_PI / 180.0)), aspect: aspect, nearZ: 0.1, farZ: 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        metalSetup()

//        scene.createObject()
//        scene.objects[0].createMeshRenderer()
//        scene.objects[0].meshRenderer?.initializeResources(ctx)
//        scene.integrationFunction = integrateWithRK4
        
        GameEngine.instance.setupGraphics(self.view as! MTKView)
    }
    
    override func keyDown(theEvent: NSEvent) {
        let controller = Controller.sharedInstance
        controller.keyPressed.addObject(theEvent.characters!)
    }
    
    override func keyUp(theEvent: NSEvent) {
        let controller = Controller.sharedInstance
        controller.keyPressed.removeObject(theEvent.characters!)
    }
}