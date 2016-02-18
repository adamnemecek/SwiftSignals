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
    var physics = PhysicsEngine()
    var graphicsContext: MetalContext?
    var resourceManager: ResourceManager?
    var scenes: [Scene]?
    var currentScene: Scene?
    var controller = Controller()
    
    private init() {
        
    }
    
    func setupGraphics(view: MetalView) -> Void {
        graphicsContext = MetalContext(view: view)
        resourceManager = ResourceManager()
        
        scenes = [Scene]()
        newScene()
        currentScene = scenes?.last
    }
    
    func newScene(title: String = "new scene") {
        scenes?.append(Scene(aTitle: title))
    }
    
    func newObject(title: String = "new object") {
        currentScene?.objects.append(GameObject())
    }
    
    func createRenderPass(aTitle: String) -> Void {
        
    }
}