//
//  Controller.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/10/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

/// The controller class is a singleton that is used to keep track of key and mouse events.
class Controller {
    
    static let sharedInstance = Controller()
    
    var keyPressed = NSMutableSet()
    
    private init() {
        
    }
    
    func isKeyPressed(key: String) -> Bool {
        return keyPressed.containsObject(key)
    }
}