//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//               Contains Linear Exposure              //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// MJP: Linear Exposure author                         //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//

// This helper file is specifically only for use in the enbeffect.fx shader file!
// The below list is only viable if the mshelpers.fxh is loaded/included into the enbeffect.fx file!


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

int LE <string UIName="--------------------LINEAR EXPOSURE";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_LE < string UIName = "Enable Adaptive Linear Exposure"; > = {true};
    float fMinERange_E < string UIName="EXPOSURE: Adapt Min Range [E]";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=100.0; > = {0.0};
    float fMaxERange_E < string UIName="EXPOSURE: Adapt Max Range [E]";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=100.0; > = {1.0};
    float fMinERange_I < string UIName="EXPOSURE: Adapt Min Range [I]";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=100.0; > = {0.0};
    float fMaxERange_I < string UIName="EXPOSURE: Adapt Max Range [I]";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=100.0; > = {1.0};
int RT_Exterior < string UIName="EXTERIOR------------------------------EXTERIOR";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
//    float4 fMinERange_E < string UIName="EXPOSURE: Adapt Min Range [E]-";  string UIWidget="Spinner";  float UIMin=1.0;  float UIMax=100.0; > = {0.0, 0.0, 0.0, 0.0};
//    float4 fMaxERange_E < string UIName="EXPOSURE: Adapt Max Range [E]-";  string UIWidget="Spinner";  float UIMin=1.0;  float UIMax=100.0; > = {1.0, 1.0, 1.0, 1.0};
    float4 fKeyValue_E < string UIName="EXPOSURE: Amount [E]-";         string UIWidget="Spinner";  float UIMin=1.0;  float UIMax=5.0; > = {1.61, 1.61, 1.61, 1.61};

int RT_Interior < string UIName="INTERIOR-------------------------------INTERIOR";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
//    float fMinERange_I < string UIName="EXPOSURE: Adapt Min Range [I]";  string UIWidget="Spinner";  float UIMin=1.0;  float UIMax=100.0; > = {0.0};
//    float fMaxERange_I < string UIName="EXPOSURE: Adapt Max Range [I]";  string UIWidget="Spinner";  float UIMin=1.0;  float UIMax=100.0; > = {1.0};
    float fKeyValue_I < string UIName="EXPOSURE: Amount [I]";          string UIWidget="Spinner";  float UIMin=1.0;  float UIMax=5.0; > = {1.61};

int RT_Dungeon < string UIName="DUNGEON-------------------------------DUNGEON";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
//    float fMinERange_D < string UIName="EXPOSURE: Adapt Min Range [D]";  string UIWidget="Spinner";  float UIMin=1.0;  float UIMax=100.0; > = {0.0};
//    float fMaxERange_D < string UIName="EXPOSURE: Adapt Max Range [D]";  string UIWidget="Spinner";  float UIMin=1.0;  float UIMax=100.0; > = {1.0};
    float fKeyValue_D < string UIName="EXPOSURE: Amount [D]";          string UIWidget="Spinner";  float UIMin=1.0;  float UIMax=5.0; > = {1.61};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 msLinExposure(float3 color, float eAdapt) {
  if (ENABLE_LE==true) {  /// Activates if ENABLE_LE = true
/// Time and Location interpolators
  float fMinERange = lerp(fMinERange_E, fMinERange_I, EInteriorFactor);
  float fMaxERange = lerp(fMaxERange_E, fMaxERange_I, EInteriorFactor);
//  float fMinERange = TODWe41i11d11(Params01[3], fMinERange_E, fMinERange_I, fMinERange_D);
//  float fMaxERange = TODWe41i11d11(Params01[3], fMaxERange_E, fMaxERange_I, fMaxERange_D);
  float fKeyValue = TODWe41i11d11(Params01[3], fKeyValue_E, fKeyValue_I, fKeyValue_D);

/// Color space conversion, from RGB to XYZ to Yxy
    float3 Yxy = RGBtoYxy(color.rgb);

/// Adaptive Linear Exposure
    float exposure = 0;
    float threshold = 0;
    float avgLuminance = eAdapt.x;

  // Use geometric mean
    avgLuminance = max(clamp(avgLuminance, fMinERange, fMaxERange), 0.001f);

  // Use auto key value
    float keyValue = 0;
    keyValue = fKeyValue - (2.0f / (2 + log10(avgLuminance + 1)));

  // Compute the linear exposure
      float linearExposure = (keyValue / avgLuminance);
      exposure = log2(max(linearExposure, 0.0001f));

    exposure -= threshold;

    Yxy.r = exp2(exposure) * Yxy.r;

/// Color space conversion, from Yxy to XYZ to RGB
    color.rgb = YxytoRGB(Yxy);
  }

  return color.rgb;
}