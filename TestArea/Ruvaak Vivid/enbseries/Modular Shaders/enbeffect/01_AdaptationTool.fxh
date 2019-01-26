//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//               Contains ENB Adaptation               //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// kingeric1992: Adaptation Level Visualizer author    //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbadaptation.fx!
// The below list is only viable if the msHelpers.fxh is loaded/included into the enbadaptation.fx file!


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

int AT <string UIName="--------------------ADAPTATION TOOL";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
bool  AdaptToolEnabled < string UIName="Adapt Tool Enabled"; > = {false};
float AdaptToolMax     < string UIName="Adapt Max Brightness (log2 scale)";  float UIMin= -9.0; float UIMax=3.0; > = {1.0};
float AdaptToolMin     < string UIName="Adapt Min Brightness (log2 scale)";  float UIMin= -9.0; float UIMax=3.0; > = {-4.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

void VS_AdaptTool( inout float4 pos : SV_POSITION, inout float2 txcoord0 : TEXCOORD0)
{
    pos = float4( pos.xy / 16.0 + float2(15.0 / 16.0, -15.0 / 16.0) , pos.z, 1.0);  // Graph background size and position
}

float4 PS_AdaptTool(float4 pos : SV_POSITION,  float2 txcoord0 : TEXCOORD0) : SV_Target
{
    clip(AdaptToolEnabled? 1.0:-1.0);
    float  adapt = saturate((log2(TextureAdaptation.Sample(Sampler0, 0.5).x) + 9.0) / 12.0);  // Graph indicator position
           adapt = step(txcoord0.x, adapt + ScreenSize.y * 16) * step(adapt - ScreenSize.y * 16, txcoord0.x);  // Graph indicator thickness
    return adapt + float4( 0.2, step(txcoord0.x, (AdaptToolMax + 9.0) / 12.0) * step((AdaptToolMin + 9.0) / 12.0, txcoord0.x) * 0.5, 0.0, 0.0);  // Graph limit box
}

#define ADAPT_TOOL_PASS  AdaptToolPass \
    { SetVertexShader(CompileShader(vs_5_0, VS_AdaptTool())); \
      SetPixelShader(CompileShader(ps_5_0, PS_AdaptTool())); }