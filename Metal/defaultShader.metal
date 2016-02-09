//
//  defaultShader.metal
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/18/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float3 position[[attribute(0)]];
    float3 normal[[attribute(1)]];
    float2 tex[[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 tex;
    half4 color;
};

struct Uniforms {
    float4x4 translation;
    float4x4 scale;
    float4x4 rotation;
};

vertex VertexOut basic_vertex(Vertex in[[stage_in]])
{
    VertexOut v;
    v.position  = float4(in.position, 1.0);
    v.color     = half4(1.0, 1.0, 1.0, 1.0);
    v.tex       = in.tex;
    
    return v;
}

fragment half4 basic_fragment(VertexOut v [[stage_in]])
{
    return v.color;
}