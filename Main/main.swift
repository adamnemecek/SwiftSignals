//
//  main.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/7/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation


let scene = Scene()
scene.createObject()

scene.integrationFunction = integrateWithRK4

while(true)
{
    scene.update()
}