//
//  Gui.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/12/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate
{
    var window: NSWindow?
    
    init(window: NSWindow) {
        super.init()
        self.window = window
    }
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        window?.makeKeyAndOrderFront(self)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}