//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//            Contains Game Post-Processing            //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// Boris: For ENBSeries and his knowledge and codes    //
// JawZ: Author and developer of MSL                   //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbeffect.fx!
// The below list is only viable if the msHelpers.fxh is loaded/included into the enbeffect.fx file!


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

int GCC2 <string UIName="--------------GAME COLOR CORRECTION";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    bool ENABLE_AGCC < string UIName="Enable AGCC"; > = {true};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //



// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float4 SimpleAGCC(float4 color, float2 txcoord0) {
  if (ENABLE_AGCC==true) {
  #define LUM_709  float3(0.2125, 0.7154, 0.0721)

    bool scalebloom    = (0.5 <= Params01[0].x);
    float2 scaleduv    = clamp(0.0, Params01[6].zy, Params01[6].xy * txcoord0.xy);
    float4 bloom       = TextureBloom.Sample(Sampler1, (scalebloom)? txcoord0.xy: scaleduv); /// Linear sampler
    float2 middlegray  = TextureAdaptation.Sample(Sampler1, txcoord0.xy).xy;                 /// .x == current, .y == previous
    middlegray.y       = 1.0;                                                                /// Bypass for enbadaptation format

    float  saturation  = Params01[3].x;    /// 0 == gray scale
    float3 tint        = Params01[4].rgb;  /// Tint color
    float  tint_weight = Params01[4].w;    /// 0 == no tint
    float  contrast    = Params01[3].z;    /// 0 == no contrast
    float  brightness  = Params01[3].w;    /// Intensity
    float3 fade        = Params01[5].xyz;  /// Fade current scene to specified color, mostly used in special effects
    float  fade_weight = Params01[5].w;    /// 0 == no fade

    color.a   = dot(color.rgb, LUM_709);                               /// Get luminance
    color.rgb = lerp(color.a, color.rgb, saturation);                  /// Saturation
    color.rgb = lerp(color.rgb, color.a * tint.rgb, tint_weight);      /// Tint
    color.rgb = lerp(middlegray.x, brightness * color.rgb, contrast);  /// Contrast & intensity
    color.rgb = pow(saturate(color.rgb), Params01[6].w);               /// This line is unused??
    color.rgb = lerp(color.rgb, fade, fade_weight);                    /// Fade current scene to specified color

  color.rgb = saturate(color.rgb);
  color.a   = 1.0;
  }
  return color;
}