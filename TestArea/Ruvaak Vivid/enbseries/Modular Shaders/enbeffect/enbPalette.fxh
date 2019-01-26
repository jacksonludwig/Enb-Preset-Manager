//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                 Contains ENB Palette                //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// Boris: Initial author of ENB Palette method         //
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

int PALETTE <string UIName="--------------------------PALETTE";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_PALETTE < string UIName = "Enable Palette"; > = {false};

// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //

/// For Day, Night and Interior time and location Seperation
Texture2D TexturePaletteD < string ResourceName="Modular Shaders/textures/enbpaletteD.bmp"; >;
Texture2D TexturePaletteN < string ResourceName="Modular Shaders/textures/enbpaletteN.bmp"; >;
Texture2D TexturePaletteI < string ResourceName="Modular Shaders/textures/enbpaletteI.bmp"; >;

// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 enbPalette(float3 color, float eAdapt) {
  if (ENABLE_PALETTE==true) {
  float3 palette;
  float2 coord = 0.0;

    eAdapt = (eAdapt / (eAdapt + 1.0));

    color.xyz   = saturate(color.xyz);
    coord.y     = eAdapt;
    coord.x     = color.r;
    palette.r   = lerp(lerp(TexturePaletteN.SampleLevel(Sampler1, coord, 0).r, TexturePaletteD.SampleLevel(Sampler1, coord, 0).r, ENightDayFactor), TexturePaletteI.SampleLevel(Sampler1, coord, 0).r, EInteriorFactor);
    coord.x     = color.g;
    coord.y     = eAdapt;
    palette.g   = lerp(lerp(TexturePaletteN.SampleLevel(Sampler1, coord, 0).g, TexturePaletteD.SampleLevel(Sampler1, coord, 0).g, ENightDayFactor), TexturePaletteI.SampleLevel(Sampler1, coord, 0).g, EInteriorFactor);
    coord.x     = color.b;
    coord.y     = eAdapt;
    palette.b   = lerp(lerp(TexturePaletteN.SampleLevel(Sampler1, coord, 0).b, TexturePaletteD.SampleLevel(Sampler1, coord, 0).b, ENightDayFactor), TexturePaletteI.SampleLevel(Sampler1, coord, 0).b, EInteriorFactor);

    color.rgb = palette.rgb;
  }
  return color;
}