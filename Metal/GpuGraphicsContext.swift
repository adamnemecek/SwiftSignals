//
//  GpuRenderContext.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/16/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

protocol GpuGraphicsContext
{
    func prepareToRender() -> Void
    func render() -> Void
}