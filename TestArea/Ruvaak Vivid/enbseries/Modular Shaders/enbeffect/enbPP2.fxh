//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//            Contains ENB Post-Process v2             //
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

int PP2 <string UIName="---------------ENB POST-PROCESSING V2";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_PP2 < string UIName = "Enable Post Process v2"; > = {false};
    float fAdaptMax < string UIName="PP v2: Adaptation Min";                               string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=100.0;  float UIStep=0.001; > = {0.05};
    float fAdaptMin < string UIName="PP v2: Adaptation Max";                               string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=100.0;  float UIStep=0.001; > = {0.05};
    float fBrightness < string UIName="PP v2: Brightness";                                 string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0};
    float fContrast < string UIName="PP v2: Intensity Contrast";                           string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0};
    float fSaturation < string UIName="PP v2: Color Saturation";                           string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0};
    float fToneMappingOversaturation < string UIName="PP v2: Tonemapping Oversaturation";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1000.0; > = {180.0};
    float fToneMappingCurve < string UIName="PP v2: Tonemapping Curve";                    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=50.0; > = {8.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 enbPP(float3 color, float eAdapt) {
  if (ENABLE_PP2==true) {
    float grayadaptation = eAdapt;
      grayadaptation     = max(grayadaptation, 0.0);
      grayadaptation     = min(grayadaptation, 50.0);
      color.xyz          = color.xyz / (grayadaptation * fAdaptMax + fAdaptMin);

      color.xyz  *= fBrightness;
      color.xyz  += 0.000001;
    float3 xncol  = normalize(color.xyz);
    float3 scl    = color.xyz / xncol.xyz;
      scl         = pow(scl, fContrast);
      xncol.xyz   = pow(xncol.xyz, fSaturation);
      color.xyz   = scl * xncol.xyz;
    float lumamax = fToneMappingOversaturation;
      color.xyz   = (color.xyz * (1.0 + color.xyz / lumamax)) / (color.xyz + fToneMappingCurve);
  }
  return color;
}