//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//           Contains HDR Filmic Uncharted 2D          //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// John Hable: Filmic Uncharted2D                      //
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

int FU2DT <string UIName="---------------FILMIC-U2D TONEMAPPING";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_U2D < string UIName = "Enable Filmic Uncharted2D";  > = {true};
int FU2DT_Exterior < string UIName="EXTERIOR------------------------------U2D";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float4 fShoulderStrength_E < string UIName="TONEMAP: Shoulder Strength_E";  string UIWidget="Spinner";  float UIMin=0.001;  float UIMax=2.0;  > = {0.13, 0.13, 0.13, 0.13};
    float4 fLinearStrength_E < string UIName="TONEMAP: Linear Strength_E";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=5.0;  > = {0.2, 0.2, 0.2, 0.2};
    float4 fLinearAngle_E < string UIName="TONEMAP: Linear Angle_E";            string UIWidget="Spinner";  float UIMin=0.001;  float UIMax=1.0;  > = {0.1, 0.1, 0.1, 0.1};
    float4 fToeStrength_E < string UIName="TONEMAP: Toe Strength_E";            string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=2.0;  > = {0.2, 0.2, 0.2, 0.2};
    float4 fToeNumerator_E < string UIName="TONEMAP: Toe Numerator_E";          string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=5.0;  float UIStep=0.001; > = {0.001, 0.001, 0.001, 0.001};
    float4 fToeDenominator_E < string UIName="TONEMAP: Toe Denominator_E";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=2.0;  > = {0.2, 0.2, 0.2, 0.2};
    float4 fLinearWhite_E < string UIName="TONEMAP: Linear White_E";            string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=50.0;  > = {1.0, 1.0, 1.0, 1.0};

int FU2DT_Interior < string UIName="INTERIOR-------------------------------U2D";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float fShoulderStrength_I < string UIName="TONEMAP: Shoulder Strength_I";  string UIWidget="Spinner";  float UIMin=0.001;  float UIMax=2.0;  > = {0.16};
    float fLinearStrength_I < string UIName="TONEMAP: Linear Strength_I";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=5.0;  > = {1.0};
    float fLinearAngle_I < string UIName="TONEMAP: Linear Angle_I";            string UIWidget="Spinner";  float UIMin=0.001;  float UIMax=1.0;  > = {0.1};
    float fToeStrength_I < string UIName="TONEMAP: Toe Strength_I";            string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=2.0;  > = {0.2};
    float fToeNumerator_I < string UIName="TONEMAP: Toe Numerator_I";          string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=5.0;  float UIStep=0.001; > = {0.001};
    float fToeDenominator_I < string UIName="TONEMAP: Toe Denominator_I";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=2.0;  > = {0.2};
    float fLinearWhite_I < string UIName="TONEMAP: Linear White_I";            string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=50.0;  > = {1.0};

int FU2DT_Dungeon < string UIName="DUNGEON-------------------------------U2D";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float fShoulderStrength_D < string UIName="TONEMAP: Shoulder Strength_D";  string UIWidget="Spinner";  float UIMin=0.001;  float UIMax=2.0;  > = {0.06};
    float fLinearStrength_D < string UIName="TONEMAP: Linear Strength_D";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=5.0;  > = {0.16};
    float fLinearAngle_D < string UIName="TONEMAP: Linear Angle_D";            string UIWidget="Spinner";  float UIMin=0.001;  float UIMax=1.0;  > = {0.17};
    float fToeStrength_D < string UIName="TONEMAP: Toe Strength_D";            string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=2.0;  > = {0.2};
    float fToeNumerator_D < string UIName="TONEMAP: Toe Numerator_D";          string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=5.0;  float UIStep=0.001; > = {0.001};
    float fToeDenominator_D < string UIName="TONEMAP: Toe Denominator_D";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=2.0;  > = {0.2};
    float fLinearWhite_D < string UIName="TONEMAP: Linear White_D";            string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=50.0;  > = {1.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 msTonemap(float3 color, float eAdapt) {
  if (ENABLE_U2D==true) {
/// Time and Location interpolators
  float A = TODWe41i11d11(Params01[3], fShoulderStrength_E, fShoulderStrength_I, fShoulderStrength_D);
  float B = TODWe41i11d11(Params01[3], fLinearStrength_E, fLinearStrength_I, fLinearStrength_D);
  float C = TODWe41i11d11(Params01[3], fLinearAngle_E, fLinearAngle_I, fLinearAngle_D);
  float D = TODWe41i11d11(Params01[3], fToeStrength_E, fToeStrength_I, fToeStrength_D);
  float E = TODWe41i11d11(Params01[3], fToeNumerator_E, fToeNumerator_I, fToeNumerator_D);
  float F = TODWe41i11d11(Params01[3], fToeDenominator_E, fToeDenominator_I, fToeDenominator_D);
  float W = TODWe41i11d11(Params01[3], fLinearWhite_E, fLinearWhite_I, fLinearWhite_D);

/// Color Space Conversion STARTS
    float3 Yxy = RGBtoYxy(color.rgb);  /// From RGB to XYZ to Yxy

/// Adaptive Local Tonemapping
    float3 numerator   = ((Yxy.r * (A * Yxy.r + C * B) + D * E) / (Yxy.r * (A * Yxy.r + B) + D * F)) - E / F;
    float3 denominator = (((W / (1.0f + eAdapt.x)) * (A * (W / (1.0f + eAdapt.x)) + C * B) + D * E) / ((W / (1.0f + eAdapt.x)) * (A * (W / (1.0f + eAdapt.x)) + B) + D * F)) - E / F;
    Yxy.r              = numerator / denominator;

/// Color Space Conversion ENDS
    color.rgb = YxytoRGB(Yxy.rgb); /// From Yxy to XYZ to RGB
  }
  return color;
}