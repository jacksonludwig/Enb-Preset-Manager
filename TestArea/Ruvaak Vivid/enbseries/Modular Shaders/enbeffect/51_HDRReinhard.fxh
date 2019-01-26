//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                 Contains HDR Toning                 //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// Erik Reinhard: Photographic Tone Reproduction       //
// Michael Stark: Photographic Tone Reproduction       //
// Peter Shirley: Photographic Tone Reproduction       //
// James Ferwerda: Photographic Tone Reproduction      //
// Charles Poynton: Color FAQ                          //
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

int RT <string UIName="-----------------TONEMAP - REINHARD";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_HDRT < string UIName = "Enable Reinhard Tonemapping"; > = {true};
int RT_Exterior < string UIName="EXTERIOR------------------------------EXTERIOR";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float4 fMaxLuma_E < string UIName="TONEMAP: Max Luminance [E]-";  string UIWidget="Spinner";  float UIMin=0.0; > = {1.0, 1.0, 1.0, 1.0};

int RT_Interior < string UIName="INTERIOR-------------------------------INTERIOR";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float fMaxLuma_I < string UIName="TONEMAP: Max Luminance [I]";  string UIWidget="Spinner";  float UIMin=0.0; > = {1.0};

int RT_Dungeon < string UIName="DUNGEON-------------------------------DUNGEON";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float fMaxLuma_D < string UIName="TONEMAP: Max Luminance [D]";  string UIWidget="Spinner";  float UIMin=0.0; > = {1.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 msTonemap(float3 color, float eAdapt) {
  if (ENABLE_HDRT==true) {  /// Activates if ENABLE_DITHER = true
/// Time and Location interpolators
  float fKeyValue = TODEID2(Params01[3], fKeyValue_E, fKeyValue_I, fKeyValue_D);
  float fMaxLuma  = TODEID2(Params01[3], fMaxLuma_E, fMaxLuma_I, fMaxLuma_D);

/// Color space conversion, from RGB to XYZ to Yxy
    float3 Yxy = RGBtoYxy(color.rgb);

/// Global Tone-mapping
    Yxy.r = (Yxy.r * (1 + Yxy.r / ((fMaxLuma / (1 + eAdapt)) * (fMaxLuma / (1 + eAdapt))))) / (Yxy.r + 1);

/// Color space conversion, from Yxy to XYZ to RGB
    color.rgb = YxytoRGB(Yxy);
  }
  return color.rgb;
}