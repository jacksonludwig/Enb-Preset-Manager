//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//               Contains ENB Blur & Sharp             //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// Boris: For ENBSeries and his knowledge and codes    //
// JawZ: Author and developer of MSL                   //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbeffectpostpass.fx!
// The below list is only viable if the msHelpers.fxh is loaded/included into the enbeffectpostpass.fx file!


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

int SharpBlur <string UIName="-----------------------SHARP & BLUR";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_BLURRING < string UIName = "Enable Blurring"; > = {false};
  bool ENABLE_SHARPENING < string UIName = "Enable Sharpening"; > = {false};
  bool ENABLE_DEPTHSHARP < string UIName = "Enable Depth Sharpening"; > = {false};
  bool ENABLE_LUMA < string UIName = "Enable Luma Sharpening"; > = {false};
  bool VISUALIZE_SHARP < string UIName = "Visualize Sharpening"; > = {false};
    float EBlurAmount < string UIName="Blur: amount";      string UIWidget="spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0};
    float EBlurRange < string UIName="Blur: range";        string UIWidget="spinner";  float UIMin=0.0;  float UIMax=2.0; > = {1.0};
    float ESharpAmount < string UIName="Sharp: amount";    string UIWidget="spinner";  float UIMin=0.0;  float UIMax=4.0; > = {1.0};
    float ESharpRange < string UIName="Sharp: range";      string UIWidget="spinner";  float UIMin=0.0;  float UIMax=2.0; > = {1.0};
    int fSharpFDepth < string UIName="Sharp: From Depth";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=100000; > = {300};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float4 enbBlur(float4 color, float2 txcoord0) {
if (ENABLE_BLURRING==false) return float4(TextureColor.Sample(Sampler0, txcoord0.xy));

  float4 Color;
  float4 centercolor;
  float2 pixeloffset = ScreenSize.y;
  pixeloffset.y     *= ScreenSize.z;

    centercolor = TextureColor.Sample(Sampler0, txcoord0.xy);
    Color       = 0.0;
    float2 offsets[4] = {
      float2(-1.0,-1.0),
      float2(-1.0, 1.0),
      float2( 1.0,-1.0),
      float2( 1.0, 1.0),
    };
    for (int i=0; i<4; i++) {
      float2 coord = offsets[i].xy * pixeloffset.xy * EBlurRange + txcoord0.xy;
      Color.xyz += TextureColor.Sample(Sampler1, coord.xy);
    }
    Color.xyz += centercolor.xyz;
    Color.xyz *= 0.2;

    color.xyz = lerp(centercolor.xyz, Color.xyz, EBlurAmount);

  return color;
}

float4 enbSharpen(float4 color, float2 txcoord0) {
if (ENABLE_SHARPENING==false) return float4(TextureColor.Sample(Sampler0, txcoord0.xy));

  float4 postcolor;
  float4 centercolor;
  float2 pixeloffset = ScreenSize.y;
  pixeloffset.y     *= ScreenSize.z;

/// Simple depth implementation
  float Depth = TextureDepth.Sample(Sampler0, txcoord0.xy ).x;
  float linDepthFromS = linearDepth(Depth, 0.5f, fSharpFDepth);

    centercolor = TextureColor.Sample(Sampler0, txcoord0.xy);
    postcolor       = 0.0;
    float2 offsets[4] = {
      float2(-1.0,-1.0),
      float2(-1.0, 1.0),
      float2( 1.0,-1.0),
      float2( 1.0, 1.0),
    };
    for (int i=0; i<4; i++) {
      float2 coord = offsets[i].xy * pixeloffset.xy * ESharpRange + txcoord0.xy;
      postcolor.xyz   += TextureColor.Sample(Sampler1, coord.xy);
    }
    postcolor.xyz *= 0.25;

    float diffgray = dot((centercolor.xyz - postcolor.xyz), 0.3333);

/// Apply depth based sharpening
    if (ENABLE_DEPTHSHARP==true)  diffgray = diffgray * (1.0f - linDepthFromS);

/// Simply does not blend the pre-sharpening scene with the post-sharpening scene together,
/// not true conversion to and from and Luma sharpening.
	if (ENABLE_LUMA==false) {
		color.xyz = ESharpAmount * centercolor.xyz * diffgray + centercolor.xyz;
	} else {
        color.xyz = ESharpAmount * diffgray + centercolor.xyz;
    }

	if (VISUALIZE_SHARP==true && ENABLE_LUMA==false) {
		color.rgb = ESharpAmount * centercolor.xyz * diffgray;
	} else if (VISUALIZE_SHARP==true && ENABLE_LUMA==true) {
        color.rgb = ESharpAmount * diffgray;
    }

  return color;
}