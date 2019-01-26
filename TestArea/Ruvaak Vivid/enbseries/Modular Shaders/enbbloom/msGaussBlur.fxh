//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//             Contains Fast Gaussian Blur             //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// MaxG3D: Converted Fast seperated gaussian bloom     //
// SonicEther: Author of Fast seperated gaussian bloom //
// Additional credits are below near the relevant code //
//----------------------INFO LINKS---------------------//
// Source: https://www.shadertoy.com/view/lstSRS       //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbbloom.fx!
// The below list is only viable if the msHelpers.fxh is loaded/included into the enbbloom.fx file!


/***List of available fetches*****************************************************************************
 * - PI // value of PI                                                                                   *
 * - InteriorFactor(Params01[3])                                                                         *
 * - DungeonFactor(Params01[3])                                                                          *
 * - TOD(fVar1, fVar2)                                                                                   *
 * - TODe41i41d41(Params01[3], fExt, fInt, fDun)                                                         *
 * - TODe41i11d11(Params01[3], fExt, fInt, fDun)                                                         *
 * - TODe41i21d21(Params01[3], fExt_Sr, fExt_D, fExt_Ss, fExt_N, fInt_D, fInt_N, fDun_D, fDun_N)         *
 * - TODe43i13d13(Params01[3], fExt_Sr, fExt_D, fExt_Ss, fExt_N, fInt_D, fInt_N, fDun_D, fDun_N)         *
 * - TODe44i14d14(Params01[3], fExt, fInt, fDun)                                                         *
 * - EID1(Params01[3], fExt, fInt, fDun)                                                                 *
 * - TODWe41i41d41(Params01[3], fExt, fInt, fDun)                                                        *
 * - TODWe41i11d11(Params01[3], fExt, fInt, fDun)                                                        *
 * - TODEIDe43i13d13(Params01[3], fExt_Sr, fExt_D, fExt_Ss, fExt_N, fInt_D, fInt_N, fDun_D, fDun_N)      *
 * - TODE1(Params01[3], Exterior_TOD)                                                                    *
 * - AvgLuma(color.rgb).x  // or .y or .z or .w, never ever .xyzw!                                       *
 * - LogLuma(color.rgb)                                                                                  *
 * - RGBtoXYZ(color.rgb)                                                                                 *
 * - XYZtoYxy(XYZ.xyz)                                                                                   *
 * - YxytoXYZ(XYZ.xyz, Yxy.rgb)                                                                          *
 * - XYZtoRGB(XYZ.xyz)                                                                                   *
 * - RGBtoYxy(color.rgb)                                                                                 *
 * - YxytoRGB(Yxy.rgb)                                                                                   *
 * - RGBToHSL(color.rgb)                                                                                 *
 * - HueToRGB(f1, f2, hsl)                                                                               *
 * - HSLToRGB(hsl.rgb)                                                                                   *
 * - RGBCVtoHUE(RGB, C, HSV.z)                                                                           *
 * - RGBtoHSV(color.rgb)                                                                                 *
 * - HUEtoRGBhsv(HSV.xyz)                                                                                *
 * - HSVtoRGB(hsv.rgb)                                                                                   *
 * - BlendLuma(HSLBase.xyz, HSLBlend.xyz)                                                                *
 * - random(IN.txcoord0.xy)                                                                              *
 * - randomNoise(IN.txcoord0.xy)                                                                         *
 * - linStep(minVal, maxVal, coords)                                                                     *
 * - InterleavedGradientNoise(IN.txcoord0.xy)                                                            *
 * - linearDepth(eDepth, fFromFarDepth, fFromNearDepth)                                                  *
 * - SplitScreen(TextureColor.Sample(Sampler0, IN.txcoord0.xy), color, IN.txcoord0.xy, fSplitscreenPos)  *
 * - ClipMode(color.rgb)                                                                                 *
 * - ShowDepth(color.rgb, TextureDepth, IN.txcoord0.xy, fFromFarDepth, fFromNearDepth)                   *
 * - FuncBlur(TextureBloom, IN.txcoord0.xy, srcsize, destsize)                                           *
 * - GetAtlasAddressSym(tile.xy, float2 IN.txcoord0.xy)                                                  *
 * - GetAtlasAddressAsy(tile.xy, float2 IN.txcoord0.xy)                                                  *
 * - GetAnamorphicAddress(axis, blur, float2 IN.txcoord0.xy)                                             *
 ********************************************************************************************************/
 

// ------------------- //
//   GUI ANNOTATIONS   //
// ------------------- //

/// Bloom tinting by pass. Provides a cool violet shift effect. 
#define GaussianBloomColorEffect 0

float  fContrast_E < string UIName="Contrast [E]";    string UIWidget="spinner";  float UIMin=0.0;  float UIMax=1000.0; > = {1.0};
float  fContrast_I < string UIName="Contrast [I]";    string UIWidget="spinner";  float UIMin=0.0;  float UIMax=1000.0; > = {1.0};
float  ECCInBlack < string UIName="CC: In black";     string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=5.0; > = {0.0};
float  ECCInWhite < string UIName="CC: In white";     string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=500.0; > = {1.0};
float  ECCOutBlack < string UIName="CC: Out black";   string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.0};
float  ECCOutWhite < string UIName="CC: Out white";   string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0};
float4 fSaturation < string UIName="CC: Saturation";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=5.0; > = {1.0, 1.0, 1.0, 1.0};

float post_mixer_bloomShape < string UIName="Gaussian: Bloom Shape";  string UIWidget="Spinner";   float UIMin=0.0;   float UIMax=32.0;   float UIStep=0.01; > = {1.0};
#ifdef GaussianBloomColorEffect
float3 post_mixer_bloomColor < string UIName="Gaussian: Bloom Color Tint Amount";  string UIWidget="Color"; > = {1.0, 1.0, 1.0};
#endif


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 ColorFetch(Texture2D inputtex, float2 coord) {
 	return inputtex.Sample(Sampler1, coord).rgb;   
}

/// Horizontal gaussian blur leveraging hardware filtering for fewer texture lookups.
float3 FuncHoriBlur(Texture2D inputtex, float2 uvsrc, float2 pxSize) {    
float weights[5];
float offsets[5];
    
    weights[0] = 0.19638062;
    weights[1] = 0.29675293;
    weights[2] = 0.09442139;
    weights[3] = 0.01037598;
    weights[4] = 0.00025940;
    
    offsets[0] = 0.00000000;
    offsets[1] = 1.41176471;
    offsets[2] = 3.29411765;
    offsets[3] = 5.17647059;
    offsets[4] = 7.05882353;
    
    float2 uv = uvsrc; //fragCoord.xy / iResolution.xy;
    
    float3 color = 0.0;
    float weightSum = 0.0;
    
    //if (uv.x < 0.52)
    {
        color += ColorFetch(inputtex, uv) * weights[0];
        weightSum += weights[0];

        for(int i = 1; i < 5; i++) {
            float2 offset = offsets[i] * pxSize;
            color += ColorFetch(inputtex, uv + offset * float2(0.5, 0.0)) * weights[i];
            color += ColorFetch(inputtex, uv - offset * float2(0.5, 0.0)) * weights[i];
            weightSum += weights[i] * 2.0;
        }

        color /= weightSum;
    }

    return color;
}

//Vertical gaussian blur leveraging hardware filtering for fewer texture lookups.
float3 FuncVertBlur(Texture2D inputtex, float2 uvsrc, float2 pxSize) {    
float weights[5];
float offsets[5];
    
    weights[0] = 0.19638062;
    weights[1] = 0.29675293;
    weights[2] = 0.09442139;
    weights[3] = 0.01037598;
    weights[4] = 0.00025940;
    
    offsets[0] = 0.00000000;
    offsets[1] = 1.41176471;
    offsets[2] = 3.29411765;
    offsets[3] = 5.17647059;
    offsets[4] = 7.05882353;
    
    float2 uv = uvsrc; //fragCoord.xy / iResolution.xy;
    
    float3 color = 0.0;
    float weightSum = 0.0;
    
    //if (uv.x < 0.52)
    {
        color += ColorFetch(inputtex, uv) * weights[0];
        weightSum += weights[0];

        for(int i = 1; i < 5; i++) {
            float2 offset = offsets[i] * pxSize;
            color += ColorFetch(inputtex, uv + offset * float2(0.0, 0.5)) * weights[i];
            color += ColorFetch(inputtex, uv - offset * float2(0.0, 0.5)) * weights[i];
            weightSum += weights[i] * 2.0;
        }

        color /= weightSum;
    }

    return color;
}


// ------------------- //
//    PIXEL SHADER     //
// ------------------- //

float4 PS_GaussHResize(VS_OUTPUT_POST IN, float4 v0 : SV_Position0, uniform Texture2D inputtex, uniform float texsize) : SV_Target {
  float4 res;

    float2 pxSize = (1/(texsize))*float2(1, ScreenSize.z);
    res.xyz = FuncHoriBlur(inputtex, IN.txcoord0.xy, pxSize*2);

  res = max(res, 0.0);
  res = min(res, 16384.0);

  res.w = 1.0;
  return res;
}

float4 PS_GaussVResize(VS_OUTPUT_POST IN, float4 v0 : SV_Position0, uniform Texture2D inputtex, uniform float texsize) : SV_Target {
  float4  res;

    float2 pxSize = (1/(texsize))*float2(1, ScreenSize.z);
    res.xyz = FuncVertBlur(inputtex, IN.txcoord0.xy, pxSize*2);

  res = max(res, 0.0);
  res = min(res, 16384.0);

  res.w = 1.0;
  return res;
}

float4 PS_GaussHResizeFirst(VS_OUTPUT_POST IN, float4 v0 : SV_Position0, uniform Texture2D inputtex, uniform float texsize) : SV_Target {
/// Time and Location interpolators
  float fContrast = lerp(fContrast_E, fContrast_I, EInteriorFactor);

  float4  res;

  float2 pxSize = (1/(texsize))*float2(1, ScreenSize.z);
  res.xyz=FuncHoriBlur(inputtex, IN.txcoord0.xy, pxSize*2);

/// Color Space Conversion STARTS
    float3 Yxy = RGBtoYxy(res.rgb);  /// From RGB to XYZ to Yxy

  	Yxy.r = max(Yxy.r - ECCInBlack, 0.0) / max(ECCInWhite - ECCInBlack, 0.0001);
	if (fContrast != 1.0) Yxy.r = pow(Yxy.r, fContrast);
	Yxy.r = Yxy.r * (ECCOutWhite - ECCOutBlack) + ECCOutBlack;

/// Color Space Conversion ENDS
    res.rgb = YxytoRGB(Yxy.rgb); /// From Yxy to XYZ to RGB

  res = max(res, 0.0);
  res = min(res, 16384.0);

  res.w = 1.0;
  return res;
}

float4  PS_GaussVResizeFirst(VS_OUTPUT_POST IN, float4 v0 : SV_Position0, uniform Texture2D inputtex, uniform float texsize) : SV_Target {
/// Time and Location interpolators
  float fContrast = lerp(fContrast_E, fContrast_I, EInteriorFactor);

  float4  res;

  float2 pxSize = (1/(texsize))*float2(1, ScreenSize.z);
  res.xyz=FuncVertBlur(inputtex, IN.txcoord0.xy, pxSize*2);

/// Color Space Conversion STARTS
    float3 Yxy = RGBtoYxy(res.rgb);  /// From RGB to XYZ to Yxy

  	Yxy.r = max(Yxy.r - ECCInBlack, 0.0) / max(ECCInWhite - ECCInBlack, 0.0001);
	if (fContrast != 1.0) Yxy.r = pow(Yxy.r, fContrast);
	Yxy.r = Yxy.r * (ECCOutWhite - ECCOutBlack) + ECCOutBlack;

/// Color Space Conversion ENDS
    res.rgb = YxytoRGB(Yxy.rgb); /// From Yxy to XYZ to RGB

  res = max(res, 0.0);
  res = min(res, 16384.0);

  res.w = 1.0;
  return res;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/*
float3 MixColorFetch(float i, float2 coord)
{   // Shader gods, have mercy.
    // This actually isn't optimised out by the compiler like I thought. Don't use this.
    switch (i) {
        case 0: //return RenderTarget1024; 
        return RenderTarget1024.Sample(Sampler1, coord);
        case 1: //return RenderTarget512; 
        return RenderTarget512.Sample(Sampler1, coord);
        case 2: //return RenderTarget256; 
        return RenderTarget256.Sample(Sampler1, coord);
        case 3: //return RenderTarget128; 
        return RenderTarget128.Sample(Sampler1, coord);
        case 4: //return RenderTarget64; 
        return RenderTarget64.Sample(Sampler1, coord);
        case 5: //return RenderTarget32; 
        return RenderTarget32.Sample(Sampler1, coord);
    }
    return 0; //TextureColor; //?!
}
*/


float4 PS_GaussMix(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
  float4 res = 0.0;

  // Mercury bloom blending code
  // Source: https://imgur.com/a/MZD3l
  // This is kind of messy... sorry! 
  float weightSum = 0;
  int maxlevel = 5;
  #define TAU 6.28318
  /* UNROLL THIS
  for (int i = 0; i <= maxlevel; i++) {
    float weight = pow(i+1,post_mixer_bloomShape);
    weightSum += weight;
    float x = i*2;
    #ifdef GaussianBloomColorEffect
    res.xyz += MixColorFetch(i, IN.txcoord0.xy)*weight * (1 + post_mixer_bloomColor*float3(sin(x), sin(x+TAU/3), sin(x-TAU/3)));
    #else
    res.xyz += MixColorFetch(i, IN.txcoord0.xy)*weight; //
    #endif
  }*/

    // This should get optimised by the compiler. 
    float weight[6];
    float x[6];

    [unroll]
    for (int i=0; i <= maxlevel; i++) {
        weight[i] = pow(i+1, post_mixer_bloomShape);
        weightSum += weight[i];
        x[i] = i*2;
    }

    if (GaussianBloomColorEffect) {
    res.xyz += ColorFetch(RenderTarget1024, IN.txcoord0.xy) * weight[0] * (1 + post_mixer_bloomColor*float3(sin(x[0]), sin(x[0]+TAU/3), sin(x[0]-TAU/3)));
    res.xyz += ColorFetch(RenderTarget512, IN.txcoord0.xy)  * weight[1] * (1 + post_mixer_bloomColor*float3(sin(x[1]), sin(x[1]+TAU/3), sin(x[1]-TAU/3)));
    res.xyz += ColorFetch(RenderTarget256, IN.txcoord0.xy)  * weight[2] * (1 + post_mixer_bloomColor*float3(sin(x[2]), sin(x[2]+TAU/3), sin(x[2]-TAU/3)));
    res.xyz += ColorFetch(RenderTarget128, IN.txcoord0.xy)  * weight[3] * (1 + post_mixer_bloomColor*float3(sin(x[3]), sin(x[3]+TAU/3), sin(x[3]-TAU/3)));
    res.xyz += ColorFetch(RenderTarget64, IN.txcoord0.xy)   * weight[4] * (1 + post_mixer_bloomColor*float3(sin(x[4]), sin(x[4]+TAU/3), sin(x[4]-TAU/3)));
    res.xyz += ColorFetch(RenderTarget32, IN.txcoord0.xy)   * weight[5] * (1 + post_mixer_bloomColor*float3(sin(x[5]), sin(x[5]+TAU/3), sin(x[5]-TAU/3)));
    } else {
    res.xyz += ColorFetch(RenderTarget1024, IN.txcoord0.xy) * weight[0]; 
    res.xyz += ColorFetch(RenderTarget512, IN.txcoord0.xy)  * weight[1]; 
    res.xyz += ColorFetch(RenderTarget256, IN.txcoord0.xy)  * weight[2]; 
    res.xyz += ColorFetch(RenderTarget128, IN.txcoord0.xy)  * weight[3]; 
    res.xyz += ColorFetch(RenderTarget64, IN.txcoord0.xy)   * weight[4]; 
    res.xyz += ColorFetch(RenderTarget32, IN.txcoord0.xy)   * weight[5]; 
    };

  res /= weightSum;

	float3 Temp = AvgLuma(res.xyz).w;
    res.xyz = lerp(Temp.xyz, res.xyz, fSaturation);
  
  res = max(res, 0.0);
  res = min(res, 16384.0);

  res.w = 1.0;
  return res;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
technique11 GaussPass2Bloom <string UIName="Gaussian bloom (Single pass)"; string RenderTarget="RenderTarget1024";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussHResize(TextureDownsampled, 1024.0)));
  }
}
technique11 GaussPass2Bloom1 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussVResize(RenderTarget1024, 1024.0)));
  }
}


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
technique11 GaussPassMBloom <string UIName="Gaussian bloom (Multiple pass)";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussHResizeFirst(TextureDownsampled, 1024.0)));
  }
}
technique11 GaussPassMBloom1 <string RenderTarget="RenderTarget1024";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussVResizeFirst(TextureColor, 1024.0)));
  }
}
technique11 GaussPassMBloom2 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussHResizeFirst(RenderTarget1024, 512.0)));
  }
}
technique11 GaussPassMBloom3 <string RenderTarget="RenderTarget512";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussVResizeFirst(TextureColor, 512.0)));
  }
}
technique11 GaussPassMBloom4 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussHResize(RenderTarget512, 256.0)));
  }
}
technique11 GaussPassMBloom5 <string RenderTarget="RenderTarget256";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussVResize(TextureColor, 256.0)));
  }
}
technique11 GaussPassMBloom6 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussHResize(RenderTarget256, 128.0)));
  }
}
technique11 GaussPassMBloom7 <string RenderTarget="RenderTarget128";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussVResize(TextureColor, 128.0)));
  }
}
technique11 GaussPassMBloom8 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussHResize(RenderTarget128, 64.0)));
  }
}
technique11 GaussPassMBloom9 <string RenderTarget="RenderTarget64";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussVResize(TextureColor, 64.0)));
  }
}
technique11 GaussPassMBloom10 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussHResize(RenderTarget64, 32.0)));
  }
}
technique11 GaussPassMBloom11 <string RenderTarget="RenderTarget32";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussVResize(TextureColor, 32.0)));
  }
}
// last pass output to bloom texture
technique11 GaussPassMBloom12 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_GaussMix()));
  }
}