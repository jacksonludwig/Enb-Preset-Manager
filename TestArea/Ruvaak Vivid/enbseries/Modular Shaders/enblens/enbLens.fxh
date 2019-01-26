//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//              Contains ENB Lens effects              //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// Boris: For ENBSeries and his knowledge and codes    //
// JawZ: Author and developer of MSL                   //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enblens.fx!
// The below list is only viable if the msHelpers.fxh is loaded/included into the enblens.fx file!


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

float3 EColorFilter <string UIName="Color filter";  string UIWidget="color";> = {0.0471, 0.00784, 1.0};
float EContrast <string UIName="Contrast";          string UIWidget="spinner";  float UIMin=1.0;  float UIMax=10.0;> = {3.0};

// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float4 enbComputeLens1(float4 res, uniform Texture2D inputtex, float2 txcoord0) {
  float4 color;
  float2 coord;

	color = 0.0;

	float weight = 0.000001;
	float scale = 0.375;
	float step = 1.0 / 16.0;
	float2 pos;
	pos.y = 0.0;
	pos.x = -1.0;

	for (int i = 0; i < 33; i++) {
		float tempweight;
		coord.xy = pos.xy * scale;
		coord.xy += txcoord0.xy;
		float3 tempcolor = inputtex.Sample(Sampler1, coord.xy);
		tempweight = 1.05 - abs(pos.x);
		tempweight *= 1.0 - saturate(abs(coord.x * 32.0 - 16.0) - 16.0);  // Clamp outside of screen
		tempweight *= tempweight;
		color.xyz += tempcolor.xyz * tempweight;
		weight += tempweight;

		pos.x += step;
	}
	color.xyz /= weight;

	res.xyz = color;

  return res;
}

float4 enbComputeLens2(float4 res, uniform Texture2D inputtex, float2 txcoord0) {
  float4 color;
  float2 coord;

	color = 0.0;

	float weight = 0.000001;
	float scale = 1.0 / 96.0;
	float step = 1.0 / 4.0;
	float2 pos;
	pos.y = 0.0;
	pos.x = -1.0;
	for (int i = 0; i < 9; i++) {
		float tempweight;
		coord.xy = pos.xy * scale;
		coord.xy += txcoord0.xy;
		float3	tempcolor = inputtex.Sample(Sampler1, coord.xy);
		tempweight = 1.0;
		//tempweight = 1.05 - abs(pos.x);
		color.xyz += tempcolor.xyz * tempweight;
		weight += tempweight;

		pos.x += step;
	}
	color.xyz /= weight;

	res.xyz = color;

  return res;
}

float4 enbLensMix(float4 res, float2 txcoord0) {
  float4 color;

	color = RenderTarget512.Sample(Sampler1, txcoord0.xy);

	float3 colorfilter = EColorFilter;
	float intensity = dot(color.xyz, colorfilter);
	intensity = pow(intensity, EContrast);

	res.xyz = intensity * EColorFilter;

	res = max(res, 0.0);
	res = min(res, 16384.0);

  return res;
}