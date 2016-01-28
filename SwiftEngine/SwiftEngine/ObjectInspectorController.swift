//
//  ObjectInspectorController.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/25/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Cocoa

class ObjectInspectorController: NSViewController, NSStackViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let theView = self.view as! NSStackView
        theView.delegate = self
        
//        ResourceManager.sharedInstance.loadAsset("New1", path: "/Users/dannyvanswieten/Documents/Model/teapot.obj")
    }
}
