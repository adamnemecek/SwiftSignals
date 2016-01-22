//
//  defaultShader.metal
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/18/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex(const device packed_float3* vertexArray[[ buffer(0) ]],
                           unsigned int vertexId [[ vertex_id ]])
{
    return float4(vertexArray[vertexId], 1.0);
}

fragment half4 basic_fragment()
{
    return half4(1.0);
}