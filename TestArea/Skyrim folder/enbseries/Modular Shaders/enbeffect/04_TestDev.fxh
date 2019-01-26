//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//             Contains Various Dev effects            //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// MJP: Author of initial code content                 //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbadaptation.fx!
// The below list is only viable if the msHelpers.fxh is loaded/included into the enbadaptation.fx file!


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

int TD <string UIName="--------------------DEV TESTS";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_DEVTEST       < string UIName="Enable Dev Test"; > = {true};
    float WhiteLevel          < string UIName="TEST: White Level";  float UIMin= 0.0; float UIMax=10.0; > = {1.0};
    float LuminanceSaturation < string UIName="TEST: Luminance Saturation";  float UIMin= 0.0; float UIMax=10.0; > = {1.0};
    float KeyValue            < string UIName="TEST: Key Value";  float UIMin= 0.0; float UIMax=10.0; > = {1.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

// Approximates luminance from an RGB value
float CalcLuminance(float3 color) {
  return max(dot(color, float3(0.299f, 0.587f, 0.114f)), 0.0001f);
}

// Retrieves the log-average luminance from the texture
float GetAvgLuminance(Texture2D adaptTex, float2 txcoord0) {
  return exp(adaptTex.Sample(Sampler0, txcoord0).x);
}


// Applies Reinhard's modified tone mapping operator
float3 ToneMapReinhardModified(float3 color) {    
    float pixelLuminance = CalcLuminance(color);
	float toneMappedLuminance = pixelLuminance * (1.0f + pixelLuminance / (WhiteLevel * WhiteLevel)) / (1.0f + pixelLuminance);

  return toneMappedLuminance * pow(color / pixelLuminance, LuminanceSaturation);
}


// Determines the color based on exposure settings
float3 CalcExposedColor(float3 color, float avgLuminance, float threshold, out float exposure) {    
  exposure = 0;

// Use geometric mean
    avgLuminance = max(avgLuminance, 0.001f);

    float keyValue = 0;
    keyValue = KeyValue - (2.0f / (2 + log10(avgLuminance + 1)));

      float linearExposure = (keyValue / avgLuminance);
      exposure = log2(max(linearExposure, 0.0001f));

    exposure -= threshold;

  return exp2(exposure) * color;
}


// Applies exposure and tone mapping to the specific color, and applies
// the threshold to the exposure value. 
float3 Combine (float3 color, Texture2D adaptTex, float2 txcoord0) {
  if (ENABLE_DEVTEST==true) {
    float avgLuminance = GetAvgLuminance(adaptTex, txcoord0);
    float exposure = 0;

      color = CalcExposedColor(color, avgLuminance, 0, exposure);
      color = ToneMapReinhardModified(color);
  }
  return color;
}