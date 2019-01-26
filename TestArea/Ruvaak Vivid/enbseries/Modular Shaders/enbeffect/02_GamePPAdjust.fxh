//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//             Contains Game PP Adjustments            //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbeffect.fx!
// The below list is only viable if the msHelpers.fxh is loaded/included into the enbeffect.fx file!


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

#ifdef E_CC_PROCEDURAL  /// Activates if UseProceduralCorrection = true
int TEST <string UIName="--------ADJUST ORIGINAL POSTPROCESSING";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
bool  GamePPAdjustEnabled < string UIName="Enable adjustment of Orginal Postprocessing"; > = {false};
float fBrightnessTest < string UIName="Brightness Test";  float UIMin= 0.0; float UIMax=5.0; > = {1.0};
#endif

// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //



// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float4 PS_GamePPAdjustPass(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
  float4 res;  /// Output
#ifdef E_CC_PROCEDURAL  /// Activates if UseProceduralCorrection = true
clip(GamePPAdjustEnabled? 1.0:-1.0);  /// Activates if GamePPAdjustEnabled = true
	float4	color;

	float2	scaleduv = Params01[6].xy * IN.txcoord0.xy;
	scaleduv = max(scaleduv, 0.0);
	scaleduv = min(scaleduv, Params01[6].zy);

	color = TextureColor.Sample(Sampler0, IN.txcoord0.xy); //hdr scene color

	float4 r0, r1, r2, r3;
	r1.xy  = scaleduv;
	r0.xyz = color.xyz;
	if (0.5 <= Params01[0].x) r1.xy = IN.txcoord0.xy;
	r1.xyz = TextureBloom.Sample(Sampler1, r1.xy).xyz;
	r2.xy  = TextureAdaptation.Sample(Sampler1, IN.txcoord0.xy).xy; //in skyrimse it two component

	r0.w   = dot(float3(2.125000e-001, 7.154000e-001, 7.210000e-002), r0.xyz);
	r0.w   = max(r0.w, 1.000000e-005);
	r1.w   = r2.y / r2.x;
	r2.y   = r0.w * r1.w;
	if (0.5 < Params01[2].z) r2.z = 0xffffffff; else r2.z = 0;
	r3.xy  = r1.w * r0.w + float2(-4.000000e-003, 1.000000e+000);
	r1.w   = max(r3.x, 0.0);
	r3.xz  = r1.w * 6.2 + float2(5.000000e-001, 1.700000e+000);
	r2.w   = r1.w * r3.x;
	r1.w   = r1.w * r3.z + 6.000000e-002;
	r1.w   = r2.w / r1.w;
	r1.w   = pow(r1.w, 2.2);
	r1.w   = r1.w * Params01[2].y;
	r2.w   = r2.y * Params01[2].y + 1.0;
	r2.y   = r2.w * r2.y;
	r2.y   = r2.y / r3.y;
	if (r2.z == 0) r1.w = r2.y; else r1.w = r1.w;
	r0.w   = r1.w / r0.w;
	r1.w   = saturate(Params01[2].x - r1.w);
	r1.xyz = r1 * r1.w;
	r0.xyz = r0 * r0.w + r1;
	r1.x   = dot(r0.xyz, float3(2.125000e-001, 7.154000e-001, 7.210000e-002));
	r0.w   = 1.0;
	r0     = r0 - r1.x;
	r0     = Params01[3].x * r0 + r1.x;
	r1     = Params01[4] * r1.x - r0;
	r0     = Params01[4].w * r1 + r0;
	r0     = Params01[3].w * r0 - r2.x;
	r0     = Params01[3].z * r0 + r2.x;
	r0.xyz = saturate(r0);
	r1.xyz = pow(r1.xyz, Params01[6].w);
//active only in certain modes, like khajiit vision, otherwise Params01[5].w = 0
	r1     = Params01[5] - r0;
	res    = Params01[5].w * r1 + r0;

/// Simple Color intensity adjustment
    res = res * fBrightnessTest;

/// DEVELOPMENT TOOLS
    res = msDevelopmentTools(res, IN.txcoord0.xy, TextureColor);

#endif
  return res;
}

#define GAME_PP_ADJUST_PASS  GamePPAdjustPass \
    { SetVertexShader(CompileShader(vs_5_0, VS_Draw())); \
      SetPixelShader(CompileShader(ps_5_0, PS_GamePPAdjustPass())); }