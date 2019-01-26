//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                 Contains ENB Palette                //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// :                //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbeffect.fx!
// The below list is only viable if the elepHelpers.fxh is loaded/included into the enbeffect.fx file!


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

float Row_Dither <string UIName="---------------------------DITHER";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.0;> = {0.0};
  bool ENABLE_DITHER < string UIName = "Enable Dither";   > = {false};
  bool VISUALIZE_PATTERN < string UIName = "Visualize Dither Pattern";   > = {false};
    int DITHER_METHOD < string UIName="Dither: Choose Method";  string UIWidget="Spinner";  int UIMin=1;  int UIMax=3;  > = {3};

// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //



// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float3 msDither(float3 color, float2 txcoord0) {
  if (ENABLE_DITHER==true) {  /// Activates if ENABLE_DITHER = true
    float dither_bit = 8.0;  /// Number of bits per channel. Should be 8 for most monitors.

  /// Ordered Dithering
    if (DITHER_METHOD==1) {
    /// Calculate grid position
      float grid_position = frac(dot(txcoord0, (ScreenSize.x * float2(1.0/16.0,10.0/36.0))) + 0.25 );

    /// Calculate how big the shift should be
      float dither_shift = (0.25) * (1.0 / (pow(2, dither_bit) - 1.0));

    /// Shift the individual colors differently, thus making it even harder to see the dithering pattern
      float3 dither_shift_RGB = float3(dither_shift, -dither_shift, dither_shift);  /// Subpixel dithering

    /// Modify shift acording to grid position.
      dither_shift_RGB = lerp(2.0 * dither_shift_RGB, -2.0 * dither_shift_RGB, grid_position);  /// Shift acording to grid position.

    /// Shift the color by dither_shift
      color.rgb += dither_shift_RGB;

    /// Debugging features
      if (VISUALIZE_PATTERN==true && DITHER_METHOD==1) {
        color.rgb = (dither_shift_RGB * 2.0 * (pow(2,dither_bit) - 1.0) ) + 0.5;  /// Visualize the RGB shift
        color.rgb = grid_position;  /// Visualize the grid
      }
    }

  /// Random Dithering
    else if (DITHER_METHOD==2) {
    /// Pseudo Random Number Generator
      /// -- PRNG 1 - Reference --
      float seed = dot(txcoord0, float2(12.9898,78.233));  /// I could add more salt here if I wanted to
      float sine = sin(seed);                                 /// cos also works well. Sincos too if you want 2D noise.
      float noise = frac(sine * 43758.5453 + txcoord0.x);  /// txcoord0.x is just some additional salt - it can be taken out.

    /// Calculate how big the shift should be
      float dither_shift = (1.0 / (pow(2,dither_bit) - 1.0));  /// Using noise to determine shift. Will be 1/255 if set to 8-bit.
      float dither_shift_half = (dither_shift * 0.5);          /// The noise should vary between +- 0.5
      dither_shift = dither_shift * noise - dither_shift_half; /// MAD

    /// Shift the color by dither_shift
      color.rgb += float3(-dither_shift, dither_shift, -dither_shift);  /// Subpixel dithering

    /// Debugging features
      if (VISUALIZE_PATTERN==true && DITHER_METHOD==2) {
        color.rgb = noise;  /// Visualize the noise
      }
    }

  /// New Dithering
    else if (DITHER_METHOD==3) {
    /// Calculate grid position
      float grid_position = frac(dot(txcoord0, (ScreenSize.x) * float2(0.75, 0.5) + (0.00025)));  // (0.6,0.8) is good too - TODO : experiment with values

    /// Calculate how big the shift should be
      float dither_shift = (0.25) * (1.0 / (pow(2, dither_bit) - 1.0));              /// 0.25 seems good both when using math and when eyeballing it. So does 0.75 btw.
      dither_shift = lerp(2.0 * dither_shift, -2.0 * dither_shift, grid_position);  /// Shift according to grid position.

    /// Shift the color by dither_shift
      color.rgb += float3(dither_shift, -dither_shift, dither_shift);  /// Subpixel dithering

    /// Debugging features
      if (VISUALIZE_PATTERN==true && DITHER_METHOD==3) {
        color.rgb = grid_position;  /// Visualize the grid
      }
    }
  }

  return color;
}