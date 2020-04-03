#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

#if (SRC_TEXTURE2D_X_ARRAY == 1)
TEXTURE2D_ARRAY(_BlitTexture);
#else
TEXTURE2D(_BlitTexture);
#endif
SamplerState sampler_LinearClamp;
uniform float4 _BlitScaleBias;
uniform float4 _BlitScaleBiasRt;
uniform uint _BlitTexArraySlice;
uniform uint _SRGBRead;

struct Attributes
{
    uint vertexID : SV_VertexID;
};

struct Varyings
{
    float4 positionCS : SV_POSITION;
    float2 texcoord   : TEXCOORD0;
};

Varyings VertQuad(Attributes input)
{
    Varyings output;
    output.positionCS = GetQuadVertexPosition(input.vertexID) * float4(_BlitScaleBiasRt.x, _BlitScaleBiasRt.y, 1, 1) + float4(_BlitScaleBiasRt.z, _BlitScaleBiasRt.w, 0, 0);
    output.positionCS.xy = output.positionCS.xy * float2(2.0f, -2.0f) + float2(-1.0f, 1.0f); //convert to -1..1
    output.texcoord = GetQuadTexCoord(input.vertexID) * _BlitScaleBias.xy + _BlitScaleBias.zw;
    return output;
}

float4 FragBilinear(Varyings input) : SV_Target
{
    float4 outColor;
#if defined(SRC_TEXTURE2D_X_ARRAY)
    outColor = SAMPLE_TEXTURE2D_ARRAY(_BlitTexture, sampler_LinearClamp, input.texcoord.xy, _BlitTexArraySlice);
#else
    outColor = SAMPLE_TEXTURE2D(_BlitTexture, sampler_LinearClamp, input.texcoord.xy);
#endif
    if (_SRGBRead)
        outColor = SRGBToLinear(outColor);
    return outColor;
}
