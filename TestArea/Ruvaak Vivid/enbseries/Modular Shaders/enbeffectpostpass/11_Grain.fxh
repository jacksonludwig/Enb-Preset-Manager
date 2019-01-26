//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                    Contains Grain                   //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// Boris: For ENBSeries and his knowledge and codes    //
// JawZ: Author and developer of MSL                   //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbeffectpostpass.fx!
// The below list is only viable if the msHelpers.fxh is loaded/included into the enbeffectpostpass.fx file!


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

int Grain <string UIName="----------------------------GRAIN";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_GRAIN < string UIName = "Enable Grain"; > = {false};
  bool VISUALIZE_GRAIN < string UIName = "Visualize Grain"; > = {false};
    float fGrainIntensity < string UIName="Grain: Intensity";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.5;  float UIStep=0.001; > = {0.035};
    float fGrainSaturation < string UIName="Grain: Saturation";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.5;  float UIStep=0.001; > = {0.0};
    float fGrainMotion < string UIName="Grain: Motion";          string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.2;  float UIStep=0.001; > = {0.2};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 msGrain(float3 color, float2 txcoord0) {
  if (ENABLE_GRAIN==true) {
    float  GrainTimerSeed    = Timer.x * fGrainMotion;
    float2 Gratxcoord0eed = txcoord0.xy * 1.0f;

    float2 GrainSeed1  = Gratxcoord0eed + float2( 0.0f, GrainTimerSeed );
    float2 GrainSeed2  = Gratxcoord0eed + float2( GrainTimerSeed, 0.0f );
    float2 GrainSeed3  = Gratxcoord0eed + float2( GrainTimerSeed, GrainTimerSeed );
    float  GrainNoise1 = random( GrainSeed1 );
    float  GrainNoise2 = random( GrainSeed2 );
    float  GrainNoise3 = random( GrainSeed3 );
    float  GrainNoise4 = ( GrainNoise1 + GrainNoise2 + GrainNoise3 ) * 0.333333333f;
    float3 GrainNoise  = float3( GrainNoise4, GrainNoise4, GrainNoise4 );
    float3 Gracolor  = float3( GrainNoise1, GrainNoise2, GrainNoise3 );

    color += ( lerp( GrainNoise, Gracolor, fGrainSaturation ) * fGrainIntensity ) - ( fGrainIntensity * 0.5f);

	if (VISUALIZE_GRAIN==true) color.rgb = (lerp(GrainNoise, Gracolor, fGrainSaturation) * fGrainIntensity) - (fGrainIntensity * 0.5f);
  }

  return color;
}