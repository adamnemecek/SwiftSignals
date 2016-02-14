//
//  Behaviour.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/11/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation
import simd

protocol BehaviourProtocol {
    
    var object: GameObject?{get}
    
    func setup() -> Void
    func update() -> Void
}

class Behaviour: BehaviourProtocol {
    
    var object: GameObject?
    
    init(object: GameObject) {
        self.object = object
    }
    
    func setup() {
        
    }
    
    func update() {
        
        guard object?.body != nil else {
            return
        }
        
        if(GameEngine.instance.controller.isKeyPressed("a")) {
            object?.body!.position += float3(x: -0.1, y: 0.0, z: 0.0)
        }
        
        if(GameEngine.instance.controller.isKeyPressed("d")) {
            object?.body!.position += float3(x: 0.1, y: 0.0, z: 0.0)
        }
        
        if(GameEngine.instance.controller.isKeyPressed("w")) {
            object?.body!.position += float3(x: 0.0, y: 0.0, z: 0.1)
        }
        
        if(GameEngine.instance.controller.isKeyPressed("s")) {
            object?.body!.position += float3(x: 0.0, y: 0.0, z: -0.1)
        }
    }
}