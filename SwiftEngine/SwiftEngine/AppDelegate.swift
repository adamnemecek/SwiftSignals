//
//  AppDelegate.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/25/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        window.makeFirstResponder(window.contentView)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}