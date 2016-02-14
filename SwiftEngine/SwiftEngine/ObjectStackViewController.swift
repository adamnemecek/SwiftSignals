//
//  ObjectStackViewController.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/13/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Cocoa

class ObjectStackViewController: NSViewController, NSStackViewDelegate {

    var transform = TransformView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let view = self.view as! NSStackView
        view.delegate = self
        view.addView(transform, inGravity: NSStackViewGravity.Trailing)
    }
}
