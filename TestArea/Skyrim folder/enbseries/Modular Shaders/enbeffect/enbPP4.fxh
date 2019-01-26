//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//            Contains ENB Post-Process v4             //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// Boris: Initial author of ENB post-process method    //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbeffect.fx!
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

int PP4 <string UIName="---------------ENB POST-PROCESSING V4";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_PP4 < string UIName = "Enable Post Process v4"; > = {false};
  bool ENABLE_YUVT < string UIName = "Enable YUV Tonemapping"; > = {true};
    float fAdaptMin < string UIName="PP v4: Adaptation Min";                                  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=100.0;  float UIStep=0.001; > = {0.125};
    float fAdaptMax < string UIName="PP v4: Adaptation Max";                                  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=100.0;  float UIStep=0.001; > = {0.2};
    float fBrightnessCurve < string UIName="PP v4: Brightness Curve";                         string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1000.0; > = {0.7};
    float fBrightnessMultiplier < string UIName="PP v4: Brightness Multiplier";               string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=50.0; > = {0.45};
    float fBrightnessToneMappingCurve < string UIName="PP v4: Brightness Tonemapping Curve";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=50.0; > = {0.5};

// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 enbPP(float3 color, float eAdapt) {
  if (ENABLE_PP4==true) {
    float grayadaptation = eAdapt;
      grayadaptation     = max(grayadaptation, 0.0);
      grayadaptation     = min(grayadaptation, 50.0);
      color.xyz          = color.xyz / (grayadaptation * fAdaptMin + fAdaptMax);

    float Y = dot(color.xyz, float3(0.299, 0.587, 0.114));        /// 0.299 * R + 0.587 * G + 0.114 * B;
    float U = dot(color.xyz, float3(-0.14713, -0.28886, 0.436));  /// -0.14713 * R - 0.28886 * G + 0.436 * B;
    float V = dot(color.xyz, float3(0.615, -0.51499, -0.10001));  /// 0.615 * R - 0.51499 * G - 0.10001 * B;
      Y     = pow(Y, fBrightnessCurve);
      Y     = Y * fBrightnessMultiplier;
    if (ENABLE_YUVT==true) {
      Y     = Y / (Y + fBrightnessToneMappingCurve);
    float desaturatefact = saturate(Y * Y * Y * 1.7);
      U         = lerp(U, 0.0, desaturatefact);
      V         = lerp(V, 0.0, desaturatefact);
    }
      color.xyz = V * float3(1.13983, -0.58060, 0.0) + U * float3(0.0, -0.39465, 2.03211) + Y;

    if (ENABLE_YUVT==false) {
      color.xyz = max(color.xyz, 0.0);
      color.xyz = color.xyz / (color.xyz + fBrightnessToneMappingCurve);
    }
  }
  return color;
}