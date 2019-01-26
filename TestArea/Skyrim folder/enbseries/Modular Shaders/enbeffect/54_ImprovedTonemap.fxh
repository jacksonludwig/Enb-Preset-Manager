//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//            Contains Improved Tonemapping            //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// Brodiggan Gale: Author of Improved Tonemapping      //
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

int IT <string UIName="---------------IMPROVED TONEMAPPING";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_IMPTONE < string UIName = "Enable Improved Tonemapping"; > = {true}; 
    float fSaturationMin < string UIName="TONEMAP: Saturation Min";          string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=4.0;  > = {1.0};
    float fSaturationMax < string UIName="TONEMAP: Saturation Max";          string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=4.0; > = {1.0};
    float fSatCurveDepth < string UIName="TONEMAP: Saturation Curve Depth";  string UIWidget="Spinner";  float UIMin=0.0; > = {1.0};
    float fBrightCurve < string UIName="TONEMAP: Brightness Curve";          string UIWidget="Spinner";  float UIMin=0.0; > = {1.0};
    float fContrastCurve < string UIName="TONEMAP: Contrast Curve";          string UIWidget="Spinner";  float UIMin=0.0; > = {1.0};
    float fContrastThreshold < string UIName="TONEMAP: Contrast Threshold";  string UIWidget="Spinner";  float UIMin=0.001;  float UIMax=0.999;  float UIStep=0.001; > = {0.001};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //
/// fitRange: Take an input value (x) on the range [a, b] and return a value mapped to the range [c, d].
float fitRange (float a, float b, float x, float c, float d) {
//  if ( a == b ) return (c + d)/2; /// Invalid input range, there is no 1 to 1 mapping of the range [a,b] to [c,d]. Since no particular value is valid, return the average of [c,d].
//  if ( c == d ) return c;         /// Invalid output range, there is no 1 to 1 mapping of the range [a,b] to [c,d]. Regardless of the input value (x), the output will be equal to (c) when mapped to this invalid range.
  return ((d - c) * (x - a) / (b - a)) + c;
}

/// pCurve: Takes an input value (x) on the range [-1, 1] and a curve depth (n), fits values to a bell (ish) curve (actually a portion of the Lorentz curve if (n) is equal to pi, but close enough).
/// Returns values for x=[-1, 1] ranging from 0 to 1, peeking at 1 where x = 0 (and falling to 0 at x=-1 and x=1). Values outside this range are negative.
/// Note: (n) must be positive and non-zero. This function must not be passed any value for n <= 0.0.
float pCurve (float x, float n) {
  return ((n + 1) / (n * (1 + (n * pow(x, 2))))) - (1/n);
}

/// sCurve: Takes an input value (x) on the range [-1, 1] and a curve depth (n), fits values to a smooth s-curve.
/// Returns values for x=(-1, 1] ranging from 0 to 1, peeking at 1.0 where x = 1. Values outside this range are invalid.
/// Note: The range (-1, 1] for (x) does not include -1.0. This function must not be passed x = -1.0.
float sCurve (float x, float n) {
  return 1 / (1 + pow((1 - x)/(1 + x), n));
}

/// peakCurve: Wrapper for pCurve, takes an input value (x) on the range [a,b], along with a curve depth (n),
/// Checks for invalid values, fits (x) to the appropriate range, then calls pCurve.
float peakCurve (float a, float b, float x, float n) {
    if (n <= 0.0) return -1.0; // check for invalid curve depth (n)
    x = fitRange(a, b, x, -1.0, 1.0);
  return pCurve(x, n);
}

/// smoothCurve: Wrapper for sCurve, takes an input value (x) on the range [a,b], along with a curve depth (n). 
/// Checks for invalid values, fits (x) to the appropriate range, then calls sCurve.
float smoothCurve (float a, float b, float x, float n) {
  if (x <= a) return 0.0; //return 0.0 if x is below the range.
  if (x >= b) return 1.0; //return 1.0 if x is below the range.
    x = fitRange(a, b, x,  -1.0, 1.0);
  return sCurve(x, n);
}

/// compoundCurve: Wrapper for sCurve, take an input value (x) and a crossover point (c) on the range [a,b], along with a curve depth (n). 
/// Check for invalid values, fit x < c to the range (-1, 0] and x > c to the range [0, 1), call sCurve, then scale the result to the appropriate range based on c.
float compoundCurve (float a, float b, float x, float n, float c) {
  if (x <= a) return 0.0; //return 0.0 if x is below the range.
  if (x >= b) return 1.0; //return 1.0 if x is below the range.

  if (c <= a) return -1.0; //invalid crossover point
  if (c >= b) return -1.0; //invalid crossover point

    float cMult = fitRange(a, b, c, 0.0, 2.0);

  if (x <= c) {
    return cMult * sCurve(fitRange(a, c, x, -1.0, 0.0), n);
  } else {
    return ((2.0 - cMult) * sCurve(fitRange(c, b, x, 0.0, 1.0), n)) + (cMult - 1);
  }
}


// Output Improved Tonemapping
float3 msTonemap(float3 color) {
  if (ENABLE_IMPTONE==true) {
    float avgLuminance = AvgLuma(color.xyz).y;  /// Too low or high of a luminance value will cause some artifacting in the steps to follow

    color.xyz = saturate(pow(color.xyz / avgLuminance, lerp(fSaturationMin, fSaturationMax, peakCurve(0.0, 1.0, (color.x + color.y + color.z) / 3, fSatCurveDepth)))) * avgLuminance;  /// Increase/Decrease Saturation
    color.xyz = color.xyz * (1.0 + compoundCurve(0.0, 1.0, avgLuminance, fContrastCurve, fContrastThreshold));                                                                         /// Contrast Tonemapping
//    color.xyz = color.xyz * (1.0 + smoothCurve(0.0, 1.0, avgLuminance, fContrastCurve) - avgLuminance);                                                                              /// Contrast Tonemapping
    color.xyz = color.xyz * (1.0 + color.xyz / fBrightCurve) / (color.xyz + (1 / fBrightCurve));                                                                                       /// Brightness Tonemapping
  }

  return color;
}