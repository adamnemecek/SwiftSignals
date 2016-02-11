//
//  defaultShader.metal
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/18/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

#include <metal_stdlib>
#include <simd/simd.h>
#include <metal_texture>
#include <metal_matrix>
#include <metal_geometric>
#include <metal_math>
#include <metal_graphics>

using namespace metal;

constant float3 light = float3(0.0, 1.0, 0.5);

typedef struct {
    simd::float3 position[[attribute(0)]];
    simd::float3 normal[[attribute(1)]];
    simd::float2 tex[[attribute(2)]];
} VertexIn;

typedef struct {
    simd::float4 position [[position]];
    simd::float4 normal;
    simd::float2 tex;
    simd::half4 color;
} VertexOut;

typedef struct {
    simd::float4x4 model;
    simd::float4x4 view;
    simd::float4x4 projection;
} Uniform;

vertex VertexOut basic_vertex(VertexIn in[[stage_in]],
                              constant Uniform& uniforms [[buffer(1)]])
{
    VertexOut v;
    v.position      = uniforms.projection * uniforms.view * uniforms.model * float4(in.position, 1.0);
    v.normal        = uniforms.view * uniforms.model * float4(in.normal, 1.0);
    float intensity = dot(normalize(v.normal.xyz), light);
    v.color         = half4(1.0, 1.0, 1.0, 1.0) * fmax(0.0, intensity);
    v.tex           = in.tex;
    
    return v;
}

fragment half4 basic_fragment(VertexOut v [[stage_in]])
{
    return half4(v.color);
}