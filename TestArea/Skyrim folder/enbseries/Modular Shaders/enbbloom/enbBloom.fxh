//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                  Contains ENB Bloom                 //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// Boris: For ENBSeries and his knowledge and codes    //
// JawZ: Author and developer of MSL                   //
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

  bool ENABLE_BLOOMDEPTH < string UIName = "Enable Bloom Depth Control"; > = {false};
int Row_Exterior < string UIName="EXTERIOR------------------------------EXTERIOR";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
//int Row_BloomDepthE < string UIName="---------------------------BLOOM_E";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    int fBloomFNearDepth_E < string UIName="BLOOM: From Near Depth_E";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=100000; > = {200};

//int Row_LightSpreadE <string UIName="A-------------------------------A_E";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float fLSThres_E < string UIName="LIGHT SPREAD: Threshold";  string UIWidget="Spinner";  float UIMin=0.0; > = {1.0};
    float fLSPwr_E < string UIName="LIGHT SPREAD: Power";        string UIWidget="Spinner";  float UIMin=0.0; > = {0.0};

//int Row_GlowE <string UIName="B-------------------------------B_E";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float fGThres_E < string UIName="GLOW: Threshold";  string UIWidget="Spinner";  float UIMin=0.0; > = {1.0};
    float fGPwr_E < string UIName="GLOW: Power";        string UIWidget="Spinner";  float UIMin=0.0; > = {0.0};

//int Row_ColorE <string UIName="C-------------------------------C_E";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float fMaxWhite_E < string UIName="COLOR: Max White";  string UIWidget="Spinner";  float UIMin=0.01;  float UIMax=25.0; > = {1.0};


int Row_Interior < string UIName="INTERIOR-------------------------------INTERIOR";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
//int Row_BloomDepthI < string UIName="---------------------------BLOOM_I";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    int fBloomFNearDepth_I < string UIName="BLOOM: From Near Depth_I";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=100000; > = {0};

//int Row_LightSpreadI <string UIName="A-------------------------------A_I";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float fLSThres_I < string UIName="LIGHT SPREAD: Threshold_I";  string UIWidget="Spinner";  float UIMin=0.0; > = {1.0};
    float fLSPwr_I < string UIName="LIGHT SPREAD: Power_I";        string UIWidget="Spinner";  float UIMin=0.0; > = {0.0};

//int Row_GlowI <string UIName="B-------------------------------B_I";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float fGThres_I < string UIName="GLOW: Threshold_I";  string UIWidget="Spinner";  float UIMin=0.0; > = {1.0};
    float fGPwr_I < string UIName="GLOW: Power_I";        string UIWidget="Spinner";  float UIMin=0.0; > = {0.0};

//int Row_ColorI <string UIName="C-------------------------------C_I";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float fMaxWhite_I < string UIName="COLOR: Max White_I";  string UIWidget="Spinner";  float UIMin=0.01;  float UIMax=25.0; > = {1.0};

// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //




// ------------------- //
//    PIXEL SHADER     //
// ------------------- //

float4 PS_Resize(VS_OUTPUT_POST IN, float4 v0 : SV_Position0, uniform Texture2D inputtex, uniform float srcsize, uniform float destsize) : SV_Target {
/// Time and Location interpolators
float fBloomFNearDepth = lerp(fBloomFNearDepth_E, fBloomFNearDepth_I, EInteriorFactor);
float fLSThres         = lerp(fLSThres_E, fLSThres_I, EInteriorFactor);
float fLSPwr           = lerp(fLSPwr_E, fLSPwr_I, EInteriorFactor);
float fGThres          = lerp(fGThres_E, fGThres_I, EInteriorFactor);
float fGPwr            = lerp(fGPwr_E, fGPwr_I, EInteriorFactor);
float fMaxWhite        = lerp(fMaxWhite_E, fMaxWhite_I, EInteriorFactor);


  float4 res;

/// ENB BLUR METHOD
    res.xyz = FuncBlur(inputtex, IN.txcoord0.xy, srcsize, destsize);	/// Requires msHelpers.fxh active

/// DEPTH BASED BLOOM
    float Depth    = TextureDepth.Sample(Sampler0, IN.txcoord0.xy).x;
    float linDepth = linearDepth(Depth, 0.5, fBloomFNearDepth);
      res.xyz      = lerp(res.xyz, res.xyz * linDepth, ENABLE_BLOOMDEPTH);

/// BLOOM CONTROL
/// Bloom Lightspread
    float3 orgBloom = res;
    res.xyz += max(0.0, (res.xyz - fLSThres * 0.1) * fLSPwr * (1.0 - orgBloom.xyz));

/// Bloom Glow
    res.xyz += max(0.0, (res.xyz - fGThres * 0.1) * fGPwr);

/// Compress and scale bloom
    res.xyz = (res.xyz * (1.0f + res.xyz / (fMaxWhite * fMaxWhite))) / (1.0f + res.xyz);  /// Scale bloom luminance within a displayable range of 0 to 1


	res = max(res, 0.0);
	res = min(res, 16384.0);

  res.w = 1.0;
  return res;
}

float4 PS_BloomMix(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
  float4 res;

/// MIX BLOOM SAMPLES
/// Mix bloom textures, ENB Bloom
    res.xyz  = RenderTarget1024.Sample(Sampler1, IN.txcoord0);
    res.xyz += RenderTarget512.Sample(Sampler1, IN.txcoord0);
    res.xyz += RenderTarget256.Sample(Sampler1, IN.txcoord0);
    res.xyz += RenderTarget128.Sample(Sampler1, IN.txcoord0);
    res.xyz += RenderTarget64.Sample(Sampler1, IN.txcoord0);
    res.xyz += RenderTarget32.Sample(Sampler1, IN.txcoord0);
    res.xyz *= 0.2;

	res = max(res, 0.0);
	res = min(res, 16384.0);

  res.w = 1.0;
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

technique11 MultiPassBloom <string UIName="Multipass bloom"; string RenderTarget="RenderTarget512";> {
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Resize(TextureDownsampled, 1024.0, 512.0)));
	}
}

technique11 MultiPassBloom1 <string RenderTarget="RenderTarget256";> {
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Resize(RenderTarget512, 512.0, 256.0)));
	}
}

technique11 MultiPassBloom2 <string RenderTarget="RenderTarget128";> {
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Resize(RenderTarget256, 256.0, 128.0)));
	}
}

technique11 MultiPassBloom3 <string RenderTarget="RenderTarget64";> {
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Resize(RenderTarget128, 128.0, 64.0)));
	}
}

technique11 MultiPassBloom4 <string RenderTarget="RenderTarget32";> {
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Resize(RenderTarget64, 64.0, 32.0)));
	}
}

technique11 MultiPassBloom5 <string RenderTarget="RenderTarget16";> {
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Resize(RenderTarget32, 32.0, 16.0)));
	}
}

technique11 MultiPassBloom6 {        /// Last pass for mixing everything
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_BloomMix()));
	}
}
