//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                Contains Color Filter                //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
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

int CF <string UIName="------------------------COLOR FILTER";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    bool ENABLE_CF < string UIName="Enable Color Filter"; > = {true};
    float fminRGBAR < string UIName="COLOR: Min RGB Adapt Range";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=6.0;  > = {0.0};
    float fmaxRGBAR < string UIName="COLOR: Max RGB Adapt Range";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=6.0;  > = {1.0};
int CF_Exterior < string UIName="EXTERIOR------------------------------COLOR FILTER";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float3 fColF_ESr < string UIName="COLOR: Filter [E-Sr]";  string UIWidget="Color";  > = {1.0, 1.0, 1.0};
    float3 fColF_ED < string UIName="COLOR: Filter [E-D]";    string UIWidget="Color";  > = {1.0, 1.0, 1.0};
    float3 fColF_ESs < string UIName="COLOR: Filter [E-Ss]";  string UIWidget="Color";  > = {1.0, 1.0, 1.0};
    float3 fColF_EN < string UIName="COLOR: Filter [E-N]";    string UIWidget="Color";  > = {1.0, 1.0, 1.0};

int CF_Interior < string UIName="INTERIOR------------------------------COLOR FILTER";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float3 fColF_I < string UIName="COLOR: Filter [I]";       string UIWidget="Color";  > = {1.0, 1.0, 1.0};

int CF_Dungeon < string UIName="DUNGEON-------------------------------COLOR FILTER";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float3 fColF_D < string UIName="COLOR: Filter [D]";       string UIWidget="Color";  > = {1.0, 1.0, 1.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //

///  Params01[4].x - Tint Red
///  Params01[4].y - Tint Green
///  Params01[4].z - Tint Blue
///  Params01[4].w - Tint Alpha


// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 ColorFilter(float3 color, float eAdapt) {
  if (ENABLE_CF==true) {
/// Time and Location interpolators
  float3 fColF = TODEIDe43i13d13(Params01[3], fColF_ESr, fColF_ED, fColF_ESs, fColF_EN, fColF_I, fColF_D);

  float params4 = Params01[4].x;
  float AdaptRange = clamp(eAdapt, fminRGBAR, fmaxRGBAR);

  float3 colorFactor = 0.0;
  if (params4 >= 0.1) {
    colorFactor.r = lerp(fColF.r, Params01[4].x, AdaptRange);
    colorFactor.g = lerp(fColF.g, Params01[4].y, AdaptRange);
    colorFactor.b = lerp(fColF.b, Params01[4].z, AdaptRange);
  } else {
    colorFactor.r = fColF.r / (0.7 + AdaptRange);
    colorFactor.g = fColF.g / (0.7 + AdaptRange);
    colorFactor.b = fColF.b / (0.7 + AdaptRange);
  }

  float3 newColor = colorFactor;
  float3 oldColor = color.rgb;
    color.rgb *= newColor;
    color.rgb += (oldColor.r - (oldColor.r * newColor.r)) * 0.2125f;  // Luma Coeffiecent: RED
    color.rgb += (oldColor.g - (oldColor.g * newColor.g)) * 0.7154f;  // Luma Coeffiecent: GREEN
    color.rgb += (oldColor.b - (oldColor.b * newColor.b)) * 0.0721f;  // Luma Coeffiecent: BLUE
  }
  return color;
}