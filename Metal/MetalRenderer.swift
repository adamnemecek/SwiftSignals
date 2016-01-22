//
//  MetalRenderer.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/18/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

protocol MetalRenderer
{
    func initializeResources(context: MetalContext)
    func render(context: CommandEncoder)
}