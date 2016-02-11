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
        if(Controller.sharedInstance.isKeyPressed("a")) {
            object?.state.position += float3(x: 0.0, y: 1.0, z: 0.0)
        }
    }
}