//
//  PipelineState.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Metal

class PipelineState {
    var stateDescriptor = MTLRenderPipelineDescriptor()
    var state: MTLRenderPipelineState?
}