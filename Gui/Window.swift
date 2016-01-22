//
//  Window.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/12/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import AppKit

class Window
{
    var window: NSWindow?
    var mainContentView = MainContentView()
    
    init(title: String, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat) {
        let rect = CGRectMake(xPos, yPos, width, height)
        window = NSWindow(contentRect: rect, styleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask, backing: NSBackingStoreType.Buffered, `defer`: false)
        
        window!.title = title
        
        mainContentView.graphicsContext = OsxGraphicsContext(ctx: (window?.graphicsContext?.CGContext)!)
        window?.contentView = mainContentView
    }
    
    func addMainContentView(content: Widget) {
        mainContentView.content = content
    }
}
