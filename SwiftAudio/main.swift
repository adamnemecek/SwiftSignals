//
//  main.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/7/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

let host = Host.sharedInstance
let window = Window(title: "Host", xPos: 0, yPos: 0, width: 1200, height: 800)
var app = Application(window: window)
app.run()