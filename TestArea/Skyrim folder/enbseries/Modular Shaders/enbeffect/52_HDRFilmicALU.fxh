//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//               Contains HDR Filmic ALU               //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// Jim Hejl: Filmic ALU                                //
// Richard Burgess-Dawson: Filmic ALU                  //
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

int FAT <string UIName="---------------FILMIC-ALU TONEMAPPING";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_ALU < string UIName = "Enable Filmic ALU"; > = {true};
int FAT_Exterior < string UIName="EXTERIOR------------------------------EXTERIOR";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float4 fUpperTone_E < string UIName="TONEMAP: Upper Tone [E]-";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0, 1.0, 1.0, 1.0};
//    float4 fGreyPoint_E < string UIName="TONEMAP: Grey Point [E]-";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0, 1.0, 1.0, 1.0};
    float4 fMiddleTone_E < string UIName="TONEMAP: Middle Tone [E]-";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=25.0; > = {1.0, 1.0, 1.0, 1.0};
    float4 fLowerTone_E < string UIName="TONEMAP: Lower Tone [E]-";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0, 1.0, 1.0, 1.0};

int FAT_Interior < string UIName="INTERIOR-------------------------------INTERIOR";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float fUpperTone_I < string UIName="TONEMAP: Upper Tone [I]";       string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0};
//    float fGreyPoint_I < string UIName="TONEMAP: Grey Point [I]";       string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0};
    float fMiddleTone_I < string UIName="TONEMAP: Middle Tone [I]";     string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=25.0; > = {1.0};
    float fLowerTone_I < string UIName="TONEMAP: Lower Tone [I]";       string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0};

int FAT_Dungeon < string UIName="DUNGEON-------------------------------DUNGEON";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float fUpperTone_D < string UIName="TONEMAP: Upper Tone [D]";       string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0};
//    float fGreyPoint_D < string UIName="TONEMAP: Grey Point [D]";       string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0};
    float fMiddleTone_D < string UIName="TONEMAP: Middle Tone [D]";     string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=25.0; > = {1.0};
    float fLowerTone_D < string UIName="TONEMAP: Lower Tone [D]";       string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 msTonemap(float3 color, float eAdapt) {
  if (ENABLE_ALU==true) {
/// Time and Location interpolators
  float fUpperTone = TODWe41i11d11(Params01[3], fUpperTone_E, fUpperTone_I, fUpperTone_D);
//  float fGreyPoint = TODWe41i11d11(Params01[3], fGreyPoint_E, fGreyPoint_I, fGreyPoint_D);
  float fMiddleTone = TODWe41i11d11(Params01[3], fMiddleTone_E, fMiddleTone_I, fMiddleTone_D);
  float fLowerTone = TODWe41i11d11(Params01[3], fLowerTone_E, fLowerTone_I, fLowerTone_D);

  float3 Yxy = RGBtoYxy(color.rgb);  /// Color space conversion, from RGB to XYZ to Yxy

/// Tonemapping, Global Filmic ALU
    Yxy.r = (Yxy.r * (fUpperTone * Yxy.r + (1 + eAdapt))) / (Yxy.r * (fUpperTone * eAdapt.x + fMiddleTone) + fLowerTone);  /// Tonemapping with Highlight and Shadow controls as well as "max allowed brightness"

  color.rgb = YxytoRGB(Yxy);  /// Color space conversion, from Yxy to XYZ to RGB
  }
  return color;
}