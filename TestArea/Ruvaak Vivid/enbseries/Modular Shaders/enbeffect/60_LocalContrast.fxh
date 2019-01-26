//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//               Contains Local Contrast               //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// wonderfulmore: inital Local Contrast author         //
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

int LC <string UIName="--------------------LOCAL CONTRAST";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
int LC_Exterior < string UIName="EXTERIOR------------------------------LOCAL CONTRAST";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float4 fLocalHighlights_E < string UIName="CONTRAST: Highlights [E]-";    string UIWidget="Spinner";  float UIMin=-1.0;  float UIMax=3.0;  > = {0.0, 0.0, 0.0, 0.0};
    float4 fLocalShadows_E < string UIName="CONTRAST: Shadows [E]-";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=3.0;  > = {0.0, 0.0, 0.0, 0.0};
	
int LC_Interior < string UIName="INTERIOR------------------------------LOCAL CONTRAST";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float fLocalHighlights_I < string UIName="CONTRAST: Highlights [I]-";    string UIWidget="Spinner";  float UIMin=-1.0;  float UIMax=3.0;  > = {0.0};
    float fLocalShadows_I < string UIName="CONTRAST: Shadows [I]-";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=3.0;  > = {0.0};
	
int LC_Dungeon < string UIName="DUNGEON-------------------------------LOCAL CONTRAST";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float fLocalHighlights_D < string UIName="CONTRAST: Highlights [D]-";    string UIWidget="Spinner";  float UIMin=-1.0;  float UIMax=6.0;  > = {0.0};
    float fLocalShadows_D < string UIName="CONTRAST: Shadows [D]-";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=3.0;  > = {0.0};

// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 msLocalContrast(float3 color, float eAdapt) {
/// Time and Location interpolators
  float fLocalHighlights = TODEID2(Params01[3], fLocalHighlights_E, fLocalHighlights_I, fLocalHighlights_D);
  float fLocalShadows = TODEID2(Params01[3], fLocalShadows_E, fLocalShadows_I, fLocalShadows_D);

/// Color Space Conversion STARTS
    float3 Yxy = RGBtoYxy(color.rgb);  /// From RGB to XYZ to Yxy

/// Adaptive Local Contrast
    float lcBlurLuma  = eAdapt;
    float lcColorLuma = Yxy.r;
    float lcNewLuma   = lcColorLuma;
    if (lcColorLuma > lcBlurLuma) {
        lcNewLuma = lcColorLuma + (lcColorLuma - lcBlurLuma) * (1 - (lcColorLuma - lcBlurLuma) / lcColorLuma) * (fLocalHighlights / (1 + eAdapt));
    }
    else if(lcColorLuma < lcBlurLuma) {
        lcNewLuma = lcColorLuma - (lcBlurLuma - lcColorLuma) * (1 - (lcBlurLuma - lcColorLuma) / lcBlurLuma) * (fLocalShadows / (1 + eAdapt));
    };
    Yxy.r *= lcNewLuma / lcColorLuma;

/// Color Space Conversion ENDS
    color.rgb = YxytoRGB(Yxy.rgb); /// From Yxy to XYZ to RGB

  return color;
}