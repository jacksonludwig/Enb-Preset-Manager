//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                ENBSeries effect file                //
//         visit http://enbdev.com for updates         //
//       Copyright (c) 2007-2017 Boris Vorontsov       //
//----------------------ENB PRESET---------------------//
//                - ENB - Preset Name -                //
//                - ENBSeries v0.310 -                 //
//-----------------------CREDITS-----------------------//
// Boris: For ENBSeries and his knowledge and codes    //
// JawZ: Author and developer of MSL                   //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


int INFO1 <string UIName="X-Sunrise, Y-Day";   string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
int INFO2 <string UIName="Z-Sunset, W-Night";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
int INFO3 <string UIName="E-Exterior";         string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
int INFO4 <string UIName="I-Interior";         string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
int INFO5 <string UIName=" ";                  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};


//++++++++++++++++++++++++++++++++++++++++++++++++++++
// INTERNAL PARAMETERS BEGINS HERE, CAN BE MODIFIED
//++++++++++++++++++++++++++++++++++++++++++++++++++++



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// EXTERNAL PARAMETERS BEGINS HERE, SHOULD NOT BE MODIFIED UNLESS YOU KNOW WHAT YOU ARE DOING
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4 Timer;            /// x = generic timer in range 0..1, period of 16777216 ms (4.6 hours), y = average fps, w = frame time elapsed (in seconds)
float4 ScreenSize;       /// x = Width, y = 1/Width, z = aspect, w = 1/aspect, aspect is Width/Height
float4 Weather;          /// x = current weather index, y = outgoing weather index, z = weather transition, w = time of the day in 24 standart hours. Weather index is value from weather ini file, for example WEATHER002 means index==2, but index==0 means that weather not captured.
float4 TimeOfDay1;       /// x = dawn, y = sunrise, z = day, w = sunset. Interpolators range from 0..1
float4 TimeOfDay2;       /// x = dusk, y = night. Interpolators range from 0..1
float  ENightDayFactor;  /// Changes in range 0..1, 0 means that night time, 1 - day time
float  EInteriorFactor;  /// Changes 0 or 1. 0 means that exterior, 1 - interior

// External ENB debugging paramaters
float4 tempF1;     /// 0,1,2,3  // Keyboard controlled temporary variables.
float4 tempF2;     /// 5,6,7,8  // Press and hold key 1,2,3...8 together with PageUp or PageDown to modify.
float4 tempF3;     /// 9,0
float4 tempInfo1;  /// xy = cursor position in range 0..1 of screen, z = is shader editor window active, w = mouse buttons with values 0..7
                   /// tempInfo1 assigned mouse button values
float4 tempInfo2;  /// 0 = none  1 = left  2 = right  3 = left+right  4 = middle  5 = left+middle  6 = right+middle  7 = left+right+middle (or rather cat is sitting on your mouse)
                   /// xy = cursor position of previous left mouse button click
                   /// zw = cursor position of previous right mouse button click

// ENBAdaptation.fx specific parameters
float4 AdaptationParameters;  /// x = AdaptationMin, y = AdaptationMax, z = AdaptationSensitivity, w = AdaptationTime multiplied by time elapsed


// TEXTURES
Texture2D TextureCurrent;
Texture2D TexturePrevious;

// SAMPLERS
SamplerState Sampler0 {
  Filter=MIN_MAG_MIP_POINT;  AddressU=Clamp;  AddressV=Clamp;
};
SamplerState Sampler1 {
  Filter=MIN_MAG_MIP_LINEAR;  AddressU=Clamp;  AddressV=Clamp;
};


// HELPER FUNCTIONS
/// Include the additional shader files containing all helper functions and constants
   #include "/Modular Shaders/msHelpers.fxh"
//   #include "/Modular Shaders/enbadaptation/enbAdaptation.fxh"
   #include "/Modular Shaders/enbadaptation/msHistogramAdaptation.fxh"

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
 