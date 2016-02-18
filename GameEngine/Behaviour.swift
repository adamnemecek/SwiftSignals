//
//  Behaviour.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/11/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import AppKit
import Foundation
import simd

protocol BehaviourProtocol {
    
    var object: GameObject?{get}
    
    func setup() -> Void
    func update() -> Void
}

class FPSCameraBehaviour: BehaviourProtocol {
    
    var object: GameObject?
    
    var mouseX = Float(0)
    var mouseY = Float(0)
    
    var prevMouseX = Float(0)
    var prevMouseY = Float(0)
    
    var deltaMouseX = Float(0)
    var deltaMouseY = Float(0)
    
    var yaw         = Float(0.0)
    var pitch       = Float(0.0)
    var roll        = Float(0.0)
    
    var yawQ        = Quaternion.identity()
    var pitchQ      = Quaternion.identity()
    var rollQ       = Quaternion.identity()
    
    var orientation = Quaternion.identity()
    var position    = Vector3(x: 0.0, y: 0.0, z: 2.0)
    
    init() {
        
    }
    
    init(object: GameObject) {
        self.object = object
    }
    
    
    private func rotate(rotation: Quaternion) {
        orientation = rotation * orientation
        orientation.normalize()
    }
    
    private func rotate(radians: Float, v: Vector3) {
        let q = Quaternion.fromRotation(radians, axis: v)
        rotate(q)
    }
    
    private func forwardVector() -> Vector3 {
        let vQ = -orientation * Vector3(x: 0.0, y: 0.0, z: 1.0)
        return Vector3(x: vQ.x, y: vQ.y, z: vQ.z)
    }
    
    private func upVector() -> Vector3 {
        let vQ = -orientation * Vector3(x: 0.0, y: -1.0, z: 0.0)
        return Vector3(x: vQ.x, y: vQ.y, z: vQ.z)
    }
    
    private func leftVector() -> Vector3 {
        let vQ = -orientation * Vector3(x: 1.0, y: 0.0, z: 0.0)
        return Vector3(x: vQ.x, y: vQ.y, z: vQ.z)
    }
    
    private func moveForward(amount: Float) {
        position += forwardVector() * amount
    }
    
    private func moveUp(amount: Float) {
        position += upVector() * amount
    }
    
    private func moveSides(amount: Float) {
        position += leftVector() * amount
    }
    
    private func getOrientation() -> Quaternion {
        
        if fabs(pitch) > 0.0 {
            pitchQ  = Quaternion.fromRotation(pitch, axis: Vector3(x: 1.0, y: 0.0, z: 0.0))
        } else {
            pitchQ  = Quaternion.identity()
        }
        
        if fabs(yaw) > 0.0{
            yawQ    = Quaternion.fromRotation(yaw, axis: Vector3(x: 0.0, y: 1.0, z: 0.0))
        } else {
            yawQ    = Quaternion.identity()
        }
        
        if fabs(roll) > 0.0 {
            rollQ   = Quaternion.fromRotation(roll, axis: Vector3(x: 0.0, y: 0.0, z: 1.0))
        } else {
            rollQ   = Quaternion.identity()
        }
        
        return pitchQ * yawQ * rollQ
    }
    
    private func updateViewByKeyboard() {
        
        let controller = GameEngine.instance.controller
        
        if controller.isKeyPressed("w") {
            moveForward(-0.1)
        } else if controller.isKeyPressed("s") {
            moveForward(0.1)
        } else if controller.isKeyPressed("d") {
            moveSides(-0.1)
        } else if controller.isKeyPressed("a") {
            moveSides(0.1)
        }
    }
    
    private func updateViewByMouse() {
        
        let loc = NSEvent.mouseLocation()
        
        mouseX = Float(loc.x)
        mouseY = Float(loc.y)
        
        deltaMouseX = mouseX - prevMouseX
        deltaMouseY = mouseY - prevMouseY
        
        pitch   += deltaMouseY * 0.01
        yaw     += -deltaMouseX * 0.01
        
        orientation = getOrientation()
        orientation.normalize()
        
        prevMouseX = mouseX
        prevMouseY = mouseY
    }
    
    func setup() {
        
    }
    
    func update() {
        
        updateViewByKeyboard()
        updateViewByMouse()
        
        GameEngine.instance.currentScene?.view = orientation.toMatrix() * Matrix4x4.matrix_translation(position.x, y: position.y, z: position.z)
    }
}