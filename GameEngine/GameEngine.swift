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
    
    var physics = PhysicsEngine()
    var graphicsContext: MetalContext?
    var resourceManager: ResourceManager?
    var scenes: [Scene]?
    var currentScene: Scene?
    
    private init() {
        scenes = [Scene]()
        newScene()
        currentScene = scenes?.last
    }
    
    func setupGraphics(view: MTKView) -> Void {
        graphicsContext = MetalContext(view: view)
        resourceManager = ResourceManager(aContext: graphicsContext!)
    }
    
    func newScene(title: String = "new scene") {
        scenes?.append(Scene(aTitle: title))
    }
    
    func newObject(title: String = "new object") {
        currentScene?.objects.append(GameObject(aScene: currentScene!, aTitle: title))
    }
}