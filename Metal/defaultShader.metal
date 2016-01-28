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
    packed_float3 position[[attribute(0)]];
    packed_float3 normal[[attribute(1)]];
    packed_float2 tex[[attribute(2)]];
};

struct VertexInOut {
    float4 position [[position]];
    float2 tex;
    float4 color;
};

struct Uniforms {
    float4x4 translation;
    float4x4 scale;
    float4x4 rotation;
};

vertex VertexInOut basic_vertex(const device Vertex* vertexArray[[ buffer(0) ]],
                                const device Uniforms* u [[ buffer(1) ]],
                                unsigned int vertexId [[ vertex_id ]])
{
    VertexInOut v;
    v.position  = u->rotation * float4(vertexArray[vertexId].position, 1.0);
    v.color     = float4(vertexArray[vertexId].normal, 1.0);
    v.tex       = vertexArray[vertexId].tex;
    
    return v;
}

fragment half4 basic_fragment(VertexInOut v [[stage_in]])
{
    return half4(v.color);
}