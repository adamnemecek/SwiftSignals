//
//  GameEngine.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/12/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import MetalKit

class GameEngine {
    static var instance = GameEngine()
    
    var device = MTLCreateSystemDefaultDevice()
    var commandQueue: MTLCommandQueue?
    
    var physics = PhysicsEngine()
    var controller  = Controller()
    var resourceManager: ResourceManager?
    
    var scenes = [Scene]()
    var currentScene: Scene?
    
    var view:           MetalView?
    var viewPort:       MTLViewport?
    
    private init() {
        print("Opened device: \(device?.name!) for rendering.")
        print("Device supports max number of threads: \(device?.maxThreadsPerThreadgroup)")
        
        commandQueue = device?.newCommandQueue()
        resourceManager = ResourceManager(device: device!)
    }
    
    final func setupGraphics(view: MetalView) -> Void {
        self.view = view
        self.view?.device = device!
        
        viewPort = MTLViewport(originX: 0, originY: 0, width: Double(view.drawableSize.width), height: Double(view.drawableSize.height), znear: 0, zfar: 1)
    }
    
    final func render() {
        if let commandBuffer = commandQueue?.commandBuffer() {
            
            let commandEncoder = commandBuffer.renderCommandEncoderWithDescriptor(view!.currentRenderPassDescriptor!)
            commandEncoder.setViewport(viewPort!)
            currentScene?.renderWithEncoder(commandEncoder)
            commandEncoder.endEncoding()
            commandBuffer.presentDrawable(view!.currentDrawable!)
            commandBuffer.commit()
        }
    }
}