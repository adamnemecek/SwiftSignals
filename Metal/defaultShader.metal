//
//  defaultShader.metal
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/18/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

constant float3 lightPosition = float3(0.0, 1.0, -1.0);

struct Vertex {
    packed_float3 position[[attribute(0)]];
    packed_float3 normal[[attribute(1)]];
    packed_float2 tex[[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 tex;
    float4 color;
};

struct Uniforms {
    float4x4 translation;
    float4x4 scale;
    float4x4 rotation;
};

vertex VertexOut basic_vertex(const device Vertex* in[[ buffer(0) ]],
                                const device Uniforms* u [[ buffer(1) ]],
                                unsigned int vertexId [[ vertex_id ]])
{
    VertexOut v;
    v.position  = u->rotation * float4(in[vertexId].position, 1.0);
    float4 eyeNormal = u->rotation * float4(in[vertexId].normal, 0.0);
    float4 nn   = normalize(eyeNormal);
    float dp    = dot(nn.rgb, normalize(lightPosition));
    float i     = fmax(0.0, dp);
    v.color     = float4(1.0, 1.0, 1.0, 1.0) * i;
    v.tex       = in[vertexId].tex;
    
    return v;
}

fragment half4 basic_fragment(VertexOut v [[stage_in]])
{
    return half4(v.color);
}