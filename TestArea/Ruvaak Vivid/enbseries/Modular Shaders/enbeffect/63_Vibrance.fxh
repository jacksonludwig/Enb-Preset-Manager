//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                  Contains Vibrance                  //
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

int Vib <string UIName="------------------------VIBRANCE";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
int Vib_Exterior < string UIName="EXTERIOR------------------------------VIBRANCE";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float4 fVibrance_E < string UIName="COLOR: Vibrance [E]-";         string UIWidget="Spinner";  float UIMin=-1.0;  float UIMax=1.0;  > = {0.0, 0.0, 0.0, 0.0};
    float3 fVibRGB_ESr < string UIName="COLOR: Vibrance Filter [E-Sr]";  string UIWidget="Color";  > = {1.0, 1.0, 1.0};
    float3 fVibRGB_ED < string UIName="COLOR: Vibrance Filter [E-D]";    string UIWidget="Color";  > = {1.0, 1.0, 1.0};
    float3 fVibRGB_ESs < string UIName="COLOR: Vibrance Filter [E-Ss]";  string UIWidget="Color";  > = {1.0, 1.0, 1.0};
    float3 fVibRGB_EN < string UIName="COLOR: Vibrance Filter [E-N]";    string UIWidget="Color";  > = {1.0, 1.0, 1.0};

int Vib_Interior < string UIName="INTERIOR------------------------------VIBRANCE";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float2 fVibrance_I < string UIName="COLOR: Vibrance [I]-";       string UIWidget="Spinner";  float UIMin=-1.0;  float UIMax=1.0;  > = {0.0, 0.0};
    float3 fVibRGB_I < string UIName="COLOR: Vibrance Filter [I-D]";  string UIWidget="Color";  > = {1.0, 1.0, 1.0};

int Vib_Dungeon < string UIName="DUNGEON-------------------------------VIBRANCE";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float2 fVibrance_D < string UIName="COLOR: Vibrance [D]-";       string UIWidget="Spinner";  float UIMin=-1.0;  float UIMax=1.0;  > = {0.0, 0.0};
    float3 fVibRGB_D < string UIName="COLOR: Vibrance Filter [D-D]";  string UIWidget="Color";  > = {1.0, 1.0, 1.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 Vibrance(float3 color) {
/// Time and Location interpolators
  float fVibrance = TODEID2(Params01[3], fVibrance_E, fVibrance_I, fVibrance_D);
  float3 fVibrance_RGB = TODEID23(Params01[3], fVibRGB_ESr, fVibRGB_ED, fVibRGB_ESs, fVibRGB_EN, fVibRGB_I, fVibRGB_D);

    float Luma = AvgLuma(color.rgb).w;  /// Grey value for color perception
    float3 Vibrance_coeff = float3(fVibrance_RGB.xyz * 2) * fVibrance;
    float Max_Color = max(color.r, max(color.g, color.b));  /// Find the strongest color
    float Min_Color = min(color.r, min(color.g, color.b));  /// Find the weakest color
    float Color_Sat = Max_Color - Min_Color;                /// The difference between the two is the saturation
      color.rgb     = lerp(Luma, color.rgb, (1.0 + (Vibrance_coeff.xyz * (1.0 - (sign(Vibrance_coeff.xyz) * Color_Sat)))));  /// Extrapolate between luma and original by 1 + (1-saturation) - current

  return color;
}