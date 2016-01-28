//
//  Window.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/12/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import AppKit


enum GraphicsBackEnd {
    case Metal
    case OpenGl
    case CoreGraphics
}

class Window
{
    var window: NSWindow?
    var mainContentView = MainContentView()
    var metal: MetalViewController?
    
    init(title: String, xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat) {
        let rect = CGRectMake(xPos, yPos, width, height)
        window = NSWindow(contentRect: rect, styleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask, backing: NSBackingStoreType.Buffered, `defer`: false)
        
        window!.title = title
        
        metal = MetalViewController()
        window!.contentView? = metal!.view
    }
    
    func addMainContentView(content: Widget) {
        mainContentView.content = content
    }
}
