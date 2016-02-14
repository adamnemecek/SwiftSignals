//
//  Transform.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/19/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import simd

struct Transform
{
    var translation     = float4x4()
    var scaling         = float4x4()
    var rotation        = float4x4()
}