//
//  Application.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/12/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import AppKit

class Application: NSObject
{
    private var application: NSApplication?
    private var delegate: AppDelegate?
    init(window: Window?) {
        super.init()
        application = NSApplication.sharedApplication()
        
        if window != nil
        {
            delegate = AppDelegate(window: window!.window!)
        }
        
        application!.delegate = delegate
    }
    
    func run() -> Int32 {
        application!.run()
        return EXIT_SUCCESS
    }
}