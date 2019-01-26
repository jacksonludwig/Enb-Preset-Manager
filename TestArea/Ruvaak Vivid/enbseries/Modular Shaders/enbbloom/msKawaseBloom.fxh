//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                Contains Kawase Bloom                //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// roxahris: Converted Kawase Bloom                    //
// Filip.S: Author of Kawase Bloom                     //
// Masaki Kawase: Author of Kawase Bloom               //
// Additional credits are below near the relevant code //
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

float fContrast_E < string UIName="Contrast [E]";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=1000.0; > = {1.0};
float fContrast_I < string UIName="Contrast [I]";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=1000.0; > = {1.0};
float ECCInBlack < string UIName="CC: In black";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=5.0; > = {0.0};
float ECCInWhite < string UIName="CC: In white";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=500.0; > = {1.0};
float ECCOutBlack < string UIName="CC: Out black";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.0};
float ECCOutWhite < string UIName="CC: Out white";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //




// ------------------- //
//    PIXEL SHADER     //
// ------------------- //

/// This is supposedly a very fast approximation of a gaussian blur. 
/// Source: https://software.intel.com/en-us/blogs/2014/07/15/an-investigation-of-fast-real-time-gpu-based-image-blur-algorithms
float3 KawaseBlurFilter( Texture2D tex, float2 texCoord, float2 pixelSize, float iteration ) {
    float2 texCoordSample;
    float2 halfPixelSize = pixelSize / 2.0f;
    float2 dUV = ( pixelSize.xy * float2( iteration, iteration ) ) + halfPixelSize.xy;

    float3 cOut;

    // Sample top left pixel
    texCoordSample.x = texCoord.x - dUV.x;
    texCoordSample.y = texCoord.y + dUV.y;    
    cOut = tex.Sample(Sampler1, texCoordSample ).xyz;

    // Sample top right pixel
    texCoordSample.x = texCoord.x + dUV.x;
    texCoordSample.y = texCoord.y + dUV.y;
    cOut += tex.Sample(Sampler1, texCoordSample ).xyz;

    // Sample bottom right pixel
    texCoordSample.x = texCoord.x + dUV.x;
    texCoordSample.y = texCoord.y - dUV.y;
    cOut += tex.Sample(Sampler1, texCoordSample ).xyz;

    // Sample bottom left pixel
    texCoordSample.x = texCoord.x - dUV.x;
    texCoordSample.y = texCoord.y - dUV.y;
    cOut += tex.Sample(Sampler1, texCoordSample ).xyz;

    // Average 
    cOut *= 0.25f;
    
    return cOut;
}

float4  PS_KawaseBloom(VS_OUTPUT_POST IN, float4 v0 : SV_Position0, uniform Texture2D inputtex, uniform float destsize, uniform float iteration) : SV_Target {
  float4  res;

  //float2 pxSize = (1/destsize)*float2(1, ScreenSize.z);  // Visibly blocky
  float2 pxSize = (1/(destsize*2))*float2(1, ScreenSize.z);

  res.xyz=KawaseBlurFilter(inputtex, IN.txcoord0.xy, pxSize, iteration);

  #if 0 // Double blur. This removes artifacing in the raw bloom texture.
  // However, it costs more than ENB's bloom and does like 60 passes. 
  // The aliasing is only noticeable at 100% bloom anyway. 
  res.xyz+=KawaseBlurFilter(inputtex, IN.txcoord0.xy, pxSize, iteration+1);
  res.xyz/=2;
  #endif
  
  res=max(res, 0.0);
  res=min(res, 16384.0);

  res.w=1.0;
  return res;
}

float4  PS_KawaseBloomFirst(VS_OUTPUT_POST IN, float4 v0 : SV_Position0, uniform Texture2D inputtex, uniform float destsize, uniform float iteration) : SV_Target {
/// Time and Location interpolators
  float fContrast = lerp(fContrast_E, fContrast_I, EInteriorFactor);

  float4  res;

  //float2 pxSize = (1/destsize)*float2(1, ScreenSize.z);  // Visibly blocky
  float2 pxSize = (1/(destsize*2))*float2(1, ScreenSize.z);

  res.xyz=KawaseBlurFilter(inputtex, IN.txcoord0.xy, pxSize, iteration);

  #if 0 // Double blur. This removes artifacing in the raw bloom texture.
  // However, it costs more than ENB's bloom and does like 60 passes. 
  // The aliasing is only noticeable at 100% bloom anyway. 
  res.xyz+=KawaseBlurFilter(inputtex, IN.txcoord0.xy, pxSize, iteration+1);
  res.xyz/=2;
  #endif

/// Color Space Conversion STARTS
    float3 Yxy = RGBtoYxy(res.rgb);  /// From RGB to XYZ to Yxy

  	Yxy.r = max(Yxy.r - ECCInBlack, 0.0) / max(ECCInWhite - ECCInBlack, 0.0001);
	if (fContrast != 1.0) Yxy.r = pow(Yxy.r, fContrast);
	Yxy.r = Yxy.r * (ECCOutWhite - ECCOutBlack) + ECCOutBlack;

/// Color Space Conversion ENDS
    res.rgb = YxytoRGB(Yxy.rgb); /// From Yxy to XYZ to RGB

  res=max(res, 0.0);
  res=min(res, 16384.0);

  res.w=1.0;
  return res;
}

float4  PS_KawaseMix(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
  float4  res;

    res.xyz=RenderTarget1024.Sample(Sampler1, IN.txcoord0.xy);

  res=max(res, 0.0);
  res=min(res, 16384.0);

  res.w=1.0;
  return res;
}

float4  PS_KawaseMix2(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
  float4  res=0;


  #if 0
    res.xyz=RenderTarget1024.Sample(Sampler1, IN.txcoord0.xy);
    res.xyz+=RenderTarget512.Sample(Sampler1, IN.txcoord0.xy);
    res.xyz+=RenderTarget256.Sample(Sampler1, IN.txcoord0.xy);
    res.xyz+=RenderTarget128.Sample(Sampler1, IN.txcoord0.xy);
    res.xyz+=RenderTarget64.Sample(Sampler1, IN.txcoord0.xy);
    res.xyz+=RenderTarget32.Sample(Sampler1, IN.txcoord0.xy);
    res.xyz /= 6;
  #else 
    res.xyz=RenderTarget1024.Sample(Sampler1, IN.txcoord0.xy)*0.5;
    res.xyz+=RenderTarget512.Sample(Sampler1, IN.txcoord0.xy)*0.8*0.75;
    res.xyz+=RenderTarget256.Sample(Sampler1, IN.txcoord0.xy)*0.6;
    res.xyz+=RenderTarget128.Sample(Sampler1, IN.txcoord0.xy)*0.45;
    res.xyz+=RenderTarget64.Sample(Sampler1, IN.txcoord0.xy) *0.32;
    res.xyz+=RenderTarget32.Sample(Sampler1, IN.txcoord0.xy) *0.23;
    res.xyz /= 2.2;
  #endif

  res=max(res, 0.0);
  res=min(res, 16384.0);

  res.w=1.0;
  return res;
}


// ------------------- //
//     TECNHIQUES      //
// ------------------- //

///+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
/// Techniques are drawn one after another and they use the result of   ///
/// the previous technique as input color to the next one.  The number  ///
/// of techniques is limited to 255.  If UIName is specified, then it   ///
/// is a base technique which may have extra techniques with indexing   ///
///+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///

technique11 KawaseBloomPass <string UIName="Kawase blur bloom (5 passes)"; string RenderTarget="RenderTarget1024";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureDownsampled, 1024.0, 0)));
  }
}
technique11 KawaseBloomPass1 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(RenderTarget1024, 1024.0, 1)));
  }
}
technique11 KawaseBloomPass2 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 1024.0, 2)));
  }
}
technique11 KawaseBloomPass3 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 1024.0, 2)));
  }
}
technique11 KawaseBloomPass4 <string RenderTarget="RenderTarget1024";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 1024.0, 3)));
  }
}
technique11 KawaseBloomPass5 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseMix()));
  }
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
technique11 MKawaseBloomPass <string UIName="Kawase blur bloom (25 passes)"; string RenderTarget="RenderTarget1024";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloomFirst(TextureDownsampled, 1024.0, 0)));
  }
}
technique11 MKawaseBloomPass1 <string RenderTarget="RenderTarget512";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloomFirst(RenderTarget1024, 512.0, 1)));
  }
}
technique11 MKawaseBloomPass2 <string RenderTarget="RenderTarget256";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(RenderTarget512, 256.0, 1)));
  }
}
technique11 MKawaseBloomPass3 <string RenderTarget="RenderTarget128";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(RenderTarget256, 128.0, 1)));
  }
}
technique11 MKawaseBloomPass4 <string RenderTarget="RenderTarget64";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(RenderTarget128, 64.0, 1)));
  }
}
technique11 MKawaseBloomPass5 <string RenderTarget="RenderTarget32";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(RenderTarget64, 32.0, 1)));
  }
}
// Passes 1024
technique11 MKawaseBloomPass6 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloomFirst(RenderTarget1024, 1024.0, 1)));
  }
}
technique11 MKawaseBloomPass7 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloomFirst(TextureColor, 1024.0, 2)));
  }
}
technique11 MKawaseBloomPass8 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloomFirst(TextureColor, 1024.0, 2)));
  }
}
technique11 MKawaseBloomPass9 <string RenderTarget="RenderTarget1024";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloomFirst(TextureColor, 1024.0, 3)));
  }
}
// Passes 512
technique11 MKawaseBloomPass10 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloomFirst(TextureColor, 512.0, 2)));
  }
}
technique11 MKawaseBloomPass11 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloomFirst(TextureColor, 512.0, 2)));
  }
}
technique11 MKawaseBloomPass12 <string RenderTarget="RenderTarget512";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloomFirst(TextureColor, 512.0, 3)));
  }
}

// Passes 256
technique11 MKawaseBloomPass13 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 256.0, 2)));
  }
}
technique11 MKawaseBloomPass14 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 256.0, 2)));
  }
}
technique11 MKawaseBloomPass15 <string RenderTarget="RenderTarget256";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 256.0, 3)));
  }
}

// Passes 128
technique11 MKawaseBloomPass16 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 128.0, 2)));
  }
}
technique11 MKawaseBloomPass17 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 128.0, 2)));
  }
}
technique11 MKawaseBloomPass18 <string RenderTarget="RenderTarget128";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 128.0, 3)));
  }
}

// Passes 64
technique11 MKawaseBloomPass19 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 64.0, 2)));
  }
}
technique11 MKawaseBloomPass20 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 64.0, 2)));
  }
}
technique11 MKawaseBloomPass21 <string RenderTarget="RenderTarget64";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 64.0, 3)));
  }
}

// Passes 32
technique11 MKawaseBloomPass22 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 32.0, 2)));
  }
}
technique11 MKawaseBloomPass23 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 32.0, 2)));
  }
}
technique11 MKawaseBloomPass24 <string RenderTarget="RenderTarget32";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseBloom(TextureColor, 32.0, 3)));
  }
}

// End
technique11 MKawaseBloomPass25 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_KawaseMix2()));
  }
}