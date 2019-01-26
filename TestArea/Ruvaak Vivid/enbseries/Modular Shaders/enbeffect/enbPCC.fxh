//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//      Contains ENB Procedural Color Corrections      //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// Boris: Initial author of ENB PCC method             //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbeffect.fx!
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

int PCC <string UIName="---------PROCEDURAL COLOR CORRECTION";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_PCC < string UIName = "Enable Procedural Color Correction"; > = {false};
    float ECCGamma < string UIName="CC: Gamma";                                       string UIWidget="Spinner";  float UIMin=0.2;  float UIMax=5.0; > = {1.0};

    float ECCInBlack < string UIName="CC: In black";                                  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.0};
    float ECCInWhite < string UIName="CC: In white";                                  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0};
    float ECCOutBlack < string UIName="CC: Out black";                                string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.0};
    float ECCOutWhite < string UIName="CC: Out white";                                string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0};

    float ECCBrightness < string UIName="CC: Brightness";                             string UIWidget="Spinner"; float UIMin=0.0; float UIMax=10.0; > = {1.0};

    float ECCContrastGrayLevel < string UIName="CC: Contrast gray level";             string UIWidget="Spinner"; float UIMin=0.01; float UIMax=0.99; > = {0.5};
    float ECCContrast < string UIName="CC: Contrast";                                 string UIWidget="Spinner"; float UIMin=0.0; float UIMax=10.0; > = {1.0};

    float ECCSaturation < string UIName="CC: Saturation";                             string UIWidget="Spinner"; float UIMin=0.0; float UIMax=10.0; > = {1.0};

    float ECCDesaturateShadows < string UIName="CC: Desaturate shadows";              string UIWidget="Spinner"; float UIMin=0.0; float UIMax=1.0; > = {0.0};

    float3 ECCColorBalanceShadows < string UIName="CC: Color balance shadows";        string UIWidget="Color"; > = {0.5, 0.5, 0.5};
    float3 ECCColorBalanceHighlights < string UIName="CC: Color balance highlights";  string UIWidget="Color"; > = {0.5, 0.5, 0.5};

    float3 ECCChannelMixerR < string UIName="CC: Channel mixer R";                    string UIWidget="Color"; > = {1.0, 0.0, 0.0};
    float3 ECCChannelMixerG < string UIName="CC: Channel mixer G";                    string UIWidget="Color"; > = {0.0, 1.0, 0.0};
    float3 ECCChannelMixerB < string UIName="CC: Channel mixer B";                    string UIWidget="Color"; > = {0.0, 0.0, 1.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 enbPCC(float3 color) {
  if (ENABLE_PCC==true) {
	float	tempgray;
	float4	tempvar;
	float3	tempcolor;

/// Levels like in photoshop, including gamma, lightness, additive brightness
	color=max(color-ECCInBlack, 0.0) / max(ECCInWhite-ECCInBlack, 0.0001);
	if (ECCGamma!=1.0) color=pow(color, ECCGamma);
	color=color*(ECCOutWhite-ECCOutBlack) + ECCOutBlack;

/// Brightness
	color=color*ECCBrightness;

///Contrast
	color=(color-ECCContrastGrayLevel) * ECCContrast + ECCContrastGrayLevel;

///Saturation
	tempgray=dot(color.xyz, 0.3333);
	color=lerp(tempgray, color, ECCSaturation);

/// Desaturate shadows
	tempgray=dot(color.xyz, 0.3333);
	tempvar.x=saturate(1.0-tempgray);
	tempvar.x*=tempvar.x;
	tempvar.x*=tempvar.x;
	color=lerp(color, tempgray, ECCDesaturateShadows*tempvar.x);

/// Color balance
	color=saturate(color);
	tempgray=dot(color.xyz, 0.3333);
	float2	shadow_highlight=float2(1.0-tempgray, tempgray);
	shadow_highlight*=shadow_highlight;
	color.rgb+=(ECCColorBalanceHighlights*2.0-1.0)*color * shadow_highlight.x;
	color.rgb+=(ECCColorBalanceShadows*2.0-1.0)*(1.0-color) * shadow_highlight.y;

/// Channel mixer
	tempcolor=color;
	color.r=dot(tempcolor, ECCChannelMixerR);
	color.g=dot(tempcolor, ECCChannelMixerG);
	color.b=dot(tempcolor, ECCChannelMixerB);
  }
  return color;
}