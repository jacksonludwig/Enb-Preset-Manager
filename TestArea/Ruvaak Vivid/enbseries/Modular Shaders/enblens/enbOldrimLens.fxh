//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//           Contains ENB Oldrim Lens effects          //
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

float ELensReflectionIntensity <string UIName="SkyrimLens: LensReflectionIntensity";  string UIWidget="spinner";  float UIMin=0.0;  float UIMax=1000.0;> = {1.0};
float ELensReflectionPower <string UIName="SkyrimLens: LensReflectionPower";          string UIWidget="spinner";  float UIMin=0.5;  float UIMax=100.0;> = {2.0};
float ELensDirtIntensity <string UIName="SkyrimLens: LensDirtIntensity";              string UIWidget="spinner";  float UIMin=0.0;  float UIMax=1000.0;> = {1.0};
float ELensDirtPower <string UIName="SkyrimLens: LensDirtPower";                      string UIWidget="spinner";  float UIMin=0.5;  float UIMax=100.0;> = {2.0};

// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float4 enbDrawSkyrimLens(float4 res, uniform Texture2D inputtex, float2 txcoord0) {
	float4 LensParameters;  // Internal variable from skyrim mod
	LensParameters.x = ELensReflectionIntensity;
	LensParameters.y = ELensReflectionPower;
	LensParameters.z = ELensDirtIntensity;
	LensParameters.w = ELensDirtPower;

	float2	coord;
// Deepness, curvature, inverse size
	const float3 offset[4]= {
		float3(1.6, 4.0, 1.0),
		float3(0.7, 0.25, 2.0),
		float3(0.3, 1.5, 0.5),
		float3(-0.5, 1.0, 1.0)
	};
// Color filter per reflection
	const float3 factors[4]= {
		float3(0.3, 0.4, 0.4),
		float3(0.2, 0.4, 0.5),
		float3(0.5, 0.3, 0.7),
		float3(0.1, 0.2, 0.7)
	};

	for (int i = 0; i < 4; i++) {
		float2 distfact = (txcoord0.xy - 0.5);
		coord.xy        = offset[i].x * distfact;
		coord.xy       *= pow(2.0 * length(float2(distfact.x * ScreenSize.z,distfact.y)), offset[i].y);
		coord.xy       *= offset[i].z;
		coord.xy        = 0.5 - coord.xy;  // v1
//		coord.xy          = txcoord0.xy - coord.xy;  // v2
		float3 templens = inputtex.Sample(Sampler1, coord.xy);
		templens        = templens * factors[i];
		distfact        = (coord.xy - 0.5);
		distfact       *= 2.0;
		templens       *= saturate(1.0 - dot(distfact,distfact));  // Limit by uv 0..1
		float maxlens   = max(templens.x, max(templens.y, templens.z));

		float tempnor = (maxlens / (1.0 + maxlens));
		tempnor       = pow(tempnor, LensParameters.y);
		templens.xyz *= tempnor;

		res.xyz += templens;
	}
	res.xyz *= 0.25 * LensParameters.x;


// Add mask
	{
		  coord         = txcoord0.xy;
		  coord.y      *= ScreenSize.w;  // Remove stretching of image
		float4 mask     = LensMaskTexture.Sample(Sampler1, coord.xy);
		float3 templens = RenderTarget128.Sample(Sampler1, txcoord0.xy);
		float maxlens   = max(templens.x, max(templens.y, templens.z));
		float tempnor   = (maxlens / (1.0 + maxlens));
		  tempnor       = pow(tempnor, LensParameters.w);
		  templens.xyz *= tempnor * LensParameters.z;
		  res.xyz      += mask.xyz * templens.xyz;
	}

  return res;
}

float4 enbMixSkyrimLens(float4 res, float2 txcoord0) {
	res = RenderTarget512.Sample(Sampler1, txcoord0.xy);

	res = max(res, 0.0);
	res = min(res, 16384.0);

  return res;
}
