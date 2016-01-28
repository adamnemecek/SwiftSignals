//
//  ObjectInspector.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/25/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Cocoa

class ObjectInspector: NSStackView {

    var object: GameObject? {
        get {
            return self.object
        } set(newObject) {
            
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
