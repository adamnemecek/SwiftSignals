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
    
    let slider = NSSlider()
    
    func metalSetup() {
        metalView = self.view as! MTKView
        metalView!.delegate = self
        ctx = MetalContext(view: metalView)
    }
    
    func drawInMTKView(view: MTKView) {
        ctx.prepareToRender()
        scene.update(ctx)
        ctx.render()
    }
    
    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalSetup()
        
        scene.createObject()
        scene.objects[0].createMeshRenderer()
        scene.objects[0].meshRenderer?.initializeResources(ctx)
        scene.integrationFunction = integrateWithRK4
    }
}
