//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//            Contains Normalized Saturation           //
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


int Norm_Sat <string UIName="----------------NORMALIZE SATURATION";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_NORMSAT < string UIName="Enable Normalize Saturation"; > = {true};
    float fminAR < string UIName="COLOR: Min Sat Adapt Range";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=6.0;  > = {0.0};
    float fmaxAR < string UIName="COLOR: Max Sat Adapt Range";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=6.0;  > = {1.0};
int NS_Exterior < string UIName="EXTERIOR------------------------------NORMALIZE SATURATION";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float4 fNormSaturation_E < string UIName="COLOR: Normalize Saturation [E]-";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=6.0;  > = {1.0, 1.0, 1.0, 1.0};
	
int NS_Interior < string UIName="INTERIOR------------------------------NORMALIZE SATURATION";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
    float2 fNormSaturation_I < string UIName="COLOR: Normalize Saturation [I]-";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=6.0;  > = {1.0, 1.0};
	
int NS_Dungeon < string UIName="DUNGEON-------------------------------NORMALIZE SATURATION";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float2 fNormSaturation_D < string UIName="COLOR: Normalize Saturation [D]-";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=6.0;  > = {1.0, 1.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 msNormSaturation(float3 color, float eAdapt) {
  if (ENABLE_NORMSAT==true) {
/// Time and Location interpolators
  float fNormSaturation = TODWe41i11d11(Params01[3], fNormSaturation_E, fNormSaturation_I, fNormSaturation_D);

   float  preLuma   = AvgLuma(color.rgb).w;
   float3 normColor = normalize(color.rgb);
     normColor.rgb  = pow(normColor.rgb, (fNormSaturation / (1 + clamp(eAdapt, fminAR, fmaxAR))));
   float  postluma  = AvgLuma(normColor.rgb).w;
     color.rgb      = (normColor.rgb * preLuma / postluma);
  }
  return color;
}