//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//            Contains NXS Dynamic Lighting            //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// nexstac: NXS-Post-Process                           //
// Greg Ward; Tonemapping Math                         //
// Kermles: Converted Greg Ward's tonemapping to HLSL  //
// Ian Taylor: RGB to HSV color space conversion       //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbeffect.fx file!
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

int NXS <string UIName="----------------NXS AUTO POSTPROCESS";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
//{
// Dynamic Bloom
    float eTML < string UIName="NXS: Tonemap Lighting";                  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=2.0; > = {1.0};

// Dynamic Bloom
    float eDBLOOMFmix < string UIName="NXS: Dynamic Bloom Mix";          string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0};

// Dynamic Desaturating Brightness
    float eDDBmix < string UIName="NXS: Desaturated Brightness Mix";     string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.0};

// Smooth Dynamic Brightness Color Filter
    float fAutoColorMix < string UIName="NXS: Auto Colorization Mix";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.0};

// Smooth Dynamic Contrast Expansion
    float eSDCEintensity < string UIName="NXS: Contrast Expansion";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=50.0; > = {0.0};

// Dynamic Detailed Lightness
    float eDDLmix < string UIName="NXS: Detailed Lightness Mix";         string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.0};

// Smooth Dynamic Color Filter
    float4 eSDCF < string UIName="NXS: Color Filter1";                   string UIWidget="Color"; > = {0.1, 0.1, 0.1, 1.0};

// Dynamic Color Filter
    float4 eDCF < string UIName="NXS: Color Filter2";                    string UIWidget="Color"; > = {0.15, 0.15, 0.15, 0.0};

// Dynamic Color Grading
    float4 eDCG < string UIName="NXS: Color Grading";                    string UIWidget="Color"; > = {0.1, 0.1, 0.1, 0.0};

// Dynamic HSV Saturation
    float eDHSrgb < string UIName="NXS: HSV Saturation RGB-Balanced";    string UIWidget="Spinner";  float UIMin=1.0;  float UIMax=20.0; > = {2.5};
    float4 eDHS < string UIName="NXS: HSV Saturation";                   string UIWidget="Color"; > = {0.125, 0.125, 0.125, 0.0};
    float eDHSpower < string UIName="NXS: HSV Saturation Power";         string UIWidget="Spinner";  float UIMin=-10.0;  float UIMax=10.0; > = {1.0};

// Dynamic HSV Value
    float eDHVintensity < string UIName="NXS: HSV Lightness Intensity";  string UIWidget="Spinner";  float UIMin=1.0;  float UIMax=20.0; > = {2.0};
    float eDHVmix < string UIName="NXS: HSV Lightness Mix";              string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.0};

// Dynamic Contrast Filter
    float eDCONFmix < string UIName="NXS: Dynamic Contrast Mix";         string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.0};
//}

// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

// Tonemapping (Wards Contrast Based Scale Factor)
float3 WardTonemap(in float3 color, in float eAdapt, in float coMultiplicator) {
  /// Initializing function for calculating the contrast-based-scale-factor
    #define scalef(Lmax, Lwa, scale)\
    scale = 1.f / Lmax * pow ( (1.219f + pow(0.5f * Lmax, 0.4f)) / (1.219f + pow(Lwa, 0.4f)) , 2.5f);

    float L_display_max = 1.0f;              /// Initializing maximum display luminance variable and set it to (1.0)
    float scale;                             /// Intitializing contrast-based-scale-factor variable
    float L_wa = eAdapt;                     /// Get world adaptation level
      scalef(L_display_max, L_wa, scale);    /// Calculate the contrast-based-scale-factor (the current luminance threshold)
      scale      = scale * coMultiplicator;  /// Manipulating the contrast based-scale-factor with the "Constant-Multiplicator" (also called: Curve) Input-Variable
      color *= scale;                        /// Multiply pixel-color-channels with contrast-based-scale-factor

  return saturate(color);  /// Returns the tonemapped color-channels and clips values <(0.0) and values >(1.0) to a range of [0..1] if required
}

// Returns (reversed) Luminance of (adjustable) Shadow-Areas (smooth adjustable Hard Transition Split between Bright and Dark Areas)
float RSLum(in float3 color, in float RSLcpLumInp, in float ShadowArea) {
  float3 rSHWcol; /// Initialize Final-Color
  float3 bMXcol;  /// Initialize Blend-Mix-Color
  float3 aMXcol;  /// Initialize Additional-Mix-Color  

    rSHWcol = pow(color, ShadowArea * (1.0f - RSLcpLumInp));
        /// Contrast-Operation increased by reversed perceived Luminance-Input (create Contrast-Color)
        /// (Low Luminance = more contrast ) ( High Luminance = less contrast)
        /// Variable "ShadowArea" is a Multiplicator (also called: Curve) 
        /// and de-/increases the overall affecting shadow areas while shifting the split between DARK- and BRIGHT-AREAS

    bMXcol  = (1.0f - rSHWcol) * (1.0f - color);  /// Blend Original-Input-Color to Contrast-Color 
    aMXcol  = lerp(color, bMXcol, 0.5f);          /// Mix Original-Input-Color and Blend-Contrast-Color
    aMXcol  = dot(aMXcol, bMXcol);                /// Grade Mix-Color with Blend-Contrast-Color
    rSHWcol = lerp(color, aMXcol, 0.64f);         /// Mix Original-Input-Color and Graded-Mix-Color to Final-Color (create Reversed-Shadow)
    rSHWcol = saturate(rSHWcol);                  /// Clip Final-Color to Range [0..1] if required

  return AvgLuma(rSHWcol).w;  ///Get perceived Luminance of Final-Color return it to OUTPUT -> CALLING FUNCTION "AvgLuma"  
}

// Dynamic Brightness Range Expansion (Luminance based)
float3 DynExpBrightRange(in float3 color) {
  float3 DEBRcol          = color;                                           /// Initialize Variable "DEBRcol" and get input-color
    float DEBRLum         = AvgLuma(DEBRcol).w;                              /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"
    float BrightnessCurve = lerp(12.0f, 7.0f, DEBRLum);                      /// Get current Brightness-Multiplicator (Curve) based on Luminance
      DEBRcol            *= pow(2.0f, (DEBRLum / 32.0f) * BrightnessCurve);  /// Brightness Operation based on Luminance
      DEBRcol             = saturate(DEBRcol);                               /// Clips Color to Range [0..1] if required

    DEBRLum            = AvgLuma(DEBRcol).w;                                                      /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"
    float DEBRContrast = 0.7f + (-8.0f * ((1.0f - DEBRLum) / 10.0f));                             /// Get current Contrast-Value based on inversed-Luminance
      DEBRcol          = DEBRcol - DEBRContrast * (DEBRcol - 1.0f) * DEBRcol * (DEBRcol - 0.5f);  /// Contrast Operation
      DEBRcol          = saturate(DEBRcol);                                                       /// Clips Color to Range [0..1] if required

  return DEBRcol;  /// returns new float3 Color (RED, GREEN, BLUE) to OUTPUT
}

// Returns the Percentage of Red,Green,Blue Channel of a Input Color
float3 RGBpercent(in float3 color) {
  float3 RGBbalance;  /// Initialize Variable "RGBbalance"
 
    RGBbalance.x = ((100.0f * color.x) / (color.x + color.y + color.z)) / 100.0f;  /// Calculate RED-Channel Amount in PERCENT and makes it fit to a RANGE of [0..1]
    RGBbalance.y = ((100.0f * color.y) / (color.x + color.y + color.z)) / 100.0f;  /// Calculate GREEN-Channel Amount in PERCENT and makes it fit to a RANGE of [0..1]
    RGBbalance.z = ((100.0f * color.z) / (color.x + color.y + color.z)) / 100.0f;  /// Calculate BLUE-Channel Amount in PERCENT and makes it fit to a RANGE of [0..1]

  return RGBbalance;  /// Returns calculated Percentage of each Color-Channel in a RANGE of [0..1] to OUTPUT
}

// Smooth Dynamic Contrast Expansion (Luminance and Color-based)
float3 SmoothDynConExp(in float3 color, in float SDCEIntensity) {
  float3 SDCEcol = color;  /// Initialize Variable "SDCEcol" and get Input-Color

    float SDCELum       = AvgLuma(SDCEcol).w;                                 /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"
    float SDCErsLum     = RSLum(SDCEcol, SDCELum, (1.0f - SDCELum) * 0.56f);  /// Get current Reversed-Shadow-Luminance -> CALLING FUNCTION "RSLum"
    float SDCEContrast  = SDCErsLum*SDCEIntensity;                            /// Calculate current Contrast-Value for Low-Luminance-Areas
    float3 RGBcpc       = RGBpercent(SDCEcol);                                /// Get Color-Channel-Percentage of Input-Color -> CALLING FUNCTION "RGBpercent"
    float3 SDCEChanCntr = float3(SDCEContrast * RGBcpc.x, SDCEContrast * RGBcpc.y, SDCEContrast * RGBcpc.z);  /// Calculate current Contrast-Value for each Color-Channel

    SDCEcol.x = SDCEcol.x - SDCEChanCntr.x * (SDCEcol.x - 1.0f) * SDCEcol.x * (SDCEcol.x - 0.5f);  /// Contrast Operation RED-Channel
    SDCEcol.y = SDCEcol.y - SDCEChanCntr.y * (SDCEcol.y - 1.0f) * SDCEcol.y * (SDCEcol.y - 0.5f);  /// Contrast Operation GREEN-Channel
    SDCEcol.z = SDCEcol.z - SDCEChanCntr.z * (SDCEcol.z - 1.0f) * SDCEcol.z * (SDCEcol.z - 0.5f);  /// Contrast Operation BLUE-Channel
    SDCEcol   = saturate(SDCEcol);                                                                 /// Clips Color to Range [0..1] if required

  return SDCEcol;  /// returns new float3 Color (RED, GREEN, BLUE) to OUTPUT
}

// Smooth Dynamic Brightness Coloring Filter (Adaption, Luminance and Color based)
float3 SDBColoringFilter(in float3 color, in float eAdapt, in float SDBCFmix) {
  float SDBCFLum        = eAdapt;             /// Get perceived Luminance of Adaption-Texture-Color -> CALLING FUNCTION "AvgLuma"
  float3 DyBColFilter   = color;              /// Initializing Variable "DyBColFilter" (Dynamic-Brightness-Color-Filter) and get INPUT-Color
  float3 SDBCFColChanPc = RGBpercent(color);  /// Initializing Variable "SDBCFColChanPc" (SDBCF-Color-Channel-Percentage) and get Color-Channel-Percentage of Input-Color -> CALLING FUNCTION "RGBpercent" 

    float SDBCFFactorRED   = lerp(1.21f, 2.42f, SDBCFLum);  /// Get current Value of RED-Factor based on Luminance (Lower Values = more RED Amount) (Higher Values = less RED Amount)
    float SDBCFFactorGREEN = lerp(1.7f, 3.4f, SDBCFLum);    /// Get current Value of GREEN-Factor based on Luminance (Lower Values = more GREEN Amount) (Higher Values = less GREEN Amount)
    float SDBCFFactorBLUE  = lerp(1.09f, 2.17f, SDBCFLum);  /// Get current Value of BLUE-Factor based on Luminance (Lower Values = more BLUE Amount) (Higher Values = less BLUE Amount)

/*
// Inversed luminance
    float SDBCFFactorRED   = lerp(1.21f, 2.42f, (1.0f - SDBCFLum));  /// Get current Value of RED-Factor based on inverse Luminance (Lower Values = more RED Amount) (Higher Values = less RED Amount)
    float SDBCFFactorGREEN = lerp(1.7f, 3.4f, (1.0f - SDBCFLum));    /// Get current Value of GREEN-Factor based on inverse Luminance (Lower Values = more GREEN Amount) (Higher Values = less GREEN Amount)
    float SDBCFFactorBLUE  = lerp(1.09f, 2.17f, (1.0f - SDBCFLum));  /// Get current Value of BLUE-Factor based on inverse Luminance (Lower Values = more BLUE Amount) (Higher Values = less BLUE Amount)

// Default
    float SDBCFFactorRED   = lerp(1.4f, 1.7f, SDBCFLum);           /// Get current Value of RED-Factor based on Luminance (Lower Values = more RED Amount) (Higher Values = less RED Amount)
    float SDBCFFactorGREEN = 3.0f;                                 /// Get fixed Value of GREEN-Factor
    float SDBCFFactorBLUE  = lerp(1.1f, 2.0f, (1.0f - SDBCFLum));  /// Get current Value of BLUE-Factor based on inverse Luminance (Lower Values = more BLUE Amount) (Higher Values = less BLUE Amount)
*/

    DyBColFilter.x = pow(DyBColFilter.x, SDBCFFactorRED * (1.0f - SDBCFColChanPc.x));    /// Contrast Operation RED-Channel based on inverse Red-Channel-Percentage of original Color
    DyBColFilter.y = pow(DyBColFilter.y, SDBCFFactorGREEN * (1.0f - SDBCFColChanPc.y));  /// Contrast Operation GREEN-Channel based on inverse GREEN-Channel-Percentage of original Color
    DyBColFilter.z = pow(DyBColFilter.z, SDBCFFactorBLUE * (1.0f - SDBCFColChanPc.z));   /// Contrast Operation BLUE-Channel based on inverse Red-Channel-Percentage of original Color

    DyBColFilter = (1.0f - (1.0f - color) * (1.0f - DyBColFilter));    /// Blend Contrast-Color (Dynamic-Brightness-Color-Filter) to original Color

    DyBColFilter.x = lerp(color.x, DyBColFilter.x, SDBCFColChanPc.x);  /// Mix original Color RED-Channel and Blended-Contrast-Color RED-Channel based on Red-Channel-Percentage of original Color
    DyBColFilter.y = lerp(color.y, DyBColFilter.y, SDBCFColChanPc.y);  /// Mix original Color GREEN-Channel and Blended-Contrast-Color GREEN-Channel based on Green-Channel-Percentage of original Color
    DyBColFilter.z = lerp(color.z, DyBColFilter.z, SDBCFColChanPc.z);  /// Mix original Color BLUE-Channel and Blended-Contrast-Color BLUE-Channel based on Blue-Channel-Percentage of original Color
    DyBColFilter   = lerp(color, DyBColFilter, SDBCFLum);              /// Mix Blended-Mixed-Contrast-Color (Dynamic-Brightness-Color-Filter) to original Color based on perceived Luminance of original Color
    DyBColFilter   = saturate(DyBColFilter);                           /// Clips Color to Range [0..1] if required
    DyBColFilter   = lerp(color, DyBColFilter, SDBCFmix);              /// Mix finalized Color of Dynamic-Brightness-Color-Filter to original Color

  return DyBColFilter;  /// returns new float3 Color (RED, GREEN, BLUE) to OUTPUT
}

// Dynamic Desaturating Brightness (Luminance and Color based)
float3 DynDesatBr(in float3 color, in float DDBmix) {    
  float3 DDBCol       = color;          /// Initialize Variable "DDBCol" and get Input-Color
  float  DDBLum       = AvgLuma(DDBCol).w;   /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"
  float3 DDBColChanPc = RGBpercent(DDBCol);  /// Initializing Variable "DDBColChanPc" (DDB-Color-Channel-Percentage) and get Color-Channel-Percentage of Input-Color -> CALLING FUNCTION "RGBpercent"

    DDBCol = 0.5f * (1.0f + cos((DDBCol - 0.5f) * 3.14f));  /// Color-Operation creates a New-Color
    DDBCol = dot(color, DDBCol);                       /// Grade Original-Color and the New-Color to achive a Desaturated-Color
    DDBCol = lerp(color, DDBCol, 0.35f);               /// Mix Original-Color and Desaturated-Color
    DDBCol = lerp(color, DDBCol, DDBColChanPc.zyx);    /// Mix Original-Color and (Mixed-)Desaturated-Color depending on (swapped) Color-Channel-Percentage (Red & Blue are swapped) 
    DDBCol = lerp(color, DDBCol, 1.0f - DDBLum);       /// Mix Original-Color and (Mixed-Mixed-)Desaturated-Color depending on inversed Luminance
    DDBCol = saturate(DDBCol);                              /// Clips Color to Range [0..1] if required
    DDBCol = lerp(color, DDBCol, DDBmix);              /// Final-Mix of Original-Color and Final-Desaturated-Color controlled by Mix-Input-Value

  return DDBCol;  /// returns new float3 Color (RED, GREEN, BLUE) to OUTPUT
}

// Dynamic Detailed Lightness (Luminance and Color based)
float3 DynDLight(in float3 color, in float DDLmix) {
  float3 DDLCol       = color;              /// Initialize Variable "DDLCol" and get Input-Color
  float  DDLlum       = AvgLuma(color).w;   /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"
  float3 DDLColChanPc = RGBpercent(color);  /// Initializing Variable "DDLColChanPc" (DDL-Color-Channel-Percentage) and get Color-Channel-Percentage of Input-Color -> CALLING FUNCTION "RGBpercent"
  float3 DDLContrast;                            /// Initializing Variable "DDLContrast"

    DDLContrast = 0.5f * (1.0f + cos((color - 0.5f) * 3.14f));             /// Color-Operation creates a New-Color
    DDLCol.x   += (DDLContrast.x * (((1.0f - DDLlum) / 10.0f) * 4.0f) / 2.6f);  /// Adds Contrast-Blue-Channel more to Color by inverse Luminance
    DDLCol.y   += (DDLContrast.y * (((DDLlum) / 10.0f) * 4.0f) / 4.7f);         /// Adds Contrast-Red-Channel more to Color by Luminance
    DDLCol.z   += (DDLContrast.z * (((DDLlum) / 10.0f) * 4.0f) / 5.6f);         /// Adds Contrast-Green-Channel more to Color by Luminance

    DDLCol      = lerp(color, DDLCol, (DDLlum / 3.0f) * 2.57f);            /// Mix Original-Input-Color and Contrast-Color controlled by Luminance
    DDLlum      = AvgLuma(DDLCol).w;                                            /// Get current perceived Luminance of Mixed-Contrast-Color -> CALLING FUNCTION "AvgLuma"
    DDLContrast = 0.5f * (1.0f + cos((DDLCol - 0.5f) * 3.14f));                 /// Color-Operation creates a New-Color from Mixed-Contrast-Color
    DDLContrast = 1.0f - (1.0f - DDLContrast) * (1.0f-DDLCol);                  /// Blend New-Contrast-Color and Mixed-Contrast-Color

    float3 DDLOvlMix = step(0.5f, DDLCol);                                      /// Initialize Variable "DDLOvlMix" (DDL-Overlay-Mix) and get Mix-Factor-Value (0.0f) or (1.0f)
    DDLContrast      = lerp((DDLCol * DDLContrast * 2.0f), (1.0f - (2.0f * (1.0f - DDLCol) * (1.0f - DDLContrast))), DDLOvlMix); /// Mix and Blend Blended-New-Contrast-Color and Mixed-Contrast-Color
    DDLContrast      = lerp(color, DDLContrast, 1.0f - DDLColChanPc);      /// Mix Original-Input-Color and Mixed-Blended-Blended-New-Contrast-Color controlled by inverse Color-Channel-Percentage
    DDLCol           = lerp(DDLCol, DDLContrast, DDLlum);                       /// Mix Mixed-Contrast-Color and Mixed-Mixed-Blended-Blended-New-Contrast-Color controlled by luminance
    DDLCol           = saturate(DDLCol);                                        /// Clip the Final-Color to Range [0..1] if required
    DDLCol           = lerp(color, DDLCol, DDLColChanPc);                  /// Mix Original-Input-Color and Final-Color controlled by Color-Channel-Percentage
    DDLCol           = lerp(color, DDLCol, DDLmix);                        /// Mix Original-Input-Color and DDL-Color controlled by Mix-Input-Value

  return DDLCol;  /// returns new float3 Color (RED, GREEN, BLUE) to OUTPUT
}

// Smooth Dynamic Color Filter (Luminance and Color based)
float3 SmoothDynColFilt(in float3 color, in float4 SDCFintensity) { 
  float3 SDCFCol       = color;              /// Initialize Variable "SDCFCol" and get Input-Color
  float  SDCFlum       = AvgLuma(color).w;   /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"
  float3 SDCFColChanPc = RGBpercent(color);  /// Initializing Variable "SDCFColChanPc" (SDCF-Color-Channel-Percentage) and get Color-Channel-Percentage of Input-Color -> CALLING FUNCTION "RGBpercent"

    float SDCFdiv = (SDCFlum * ((1.0f - SDCFColChanPc.x) * 0.5f)) + (SDCFintensity.x * 100);  /// Calculate Division-Factor RED-Channel
    SDCFCol.x    += (1.0f - color.x) / SDCFdiv;                                               /// Color Operation RED-Channel
    SDCFCol.x     = lerp(SDCFCol.x, color.x, max(0.8f, SDCFlum));                             /// Mix New-Color and Original-Input-Color controlled by Luminance

    SDCFdiv    = (SDCFlum * ((1.0f - SDCFColChanPc.y) * 0.5f)) + (SDCFintensity.x * 100);     /// Calculate Division-Factor BLUE-Channel
    SDCFCol.y += (1.0f - color.y) / SDCFdiv;                                                  /// Color Operation BLUE-Channel
    SDCFCol.y  = lerp(color.y, SDCFCol.y, min(0.3f, SDCFlum));                                /// Mix New-Color and Original-Input-Color controlled by Luminance

    SDCFdiv    = (SDCFlum * ((1.0f - SDCFColChanPc.z) * 0.5f)) + (SDCFintensity.x * 100);     /// Calculate Division-Factor BLUE-Channel
    SDCFCol.z += (1.0f - color.z) / SDCFdiv;                                                  /// Color Operation BLUE-Channel
    SDCFCol.z  = lerp(color.z, SDCFCol.z, min(0.9f, SDCFlum));                                /// Mix New-Color and Original-Input-Color controlled by Luminance

    SDCFCol = saturate(SDCFCol);                      /// Clip the Final-Color to Range [0..1] if required
    SDCFCol = lerp(color, SDCFCol, SDCFintensity.w);  /// Mix Original-Input-Color and SDCF-Color controlled by Mix-Input-Value

  return SDCFCol; /// returns new float3 Color (RED, GREEN, BLUE) to OUTPUT
}

// Dynamic Color Filter (Luminance based)
float3 DyCoFi(in float3 color, in float4 DCFintensity) {
  float3 DCFCol = color;             /// Initialize Variable "DCFCol" and get Input-Color
  float  DCFlum = AvgLuma(color).w;  /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"

    DCFCol.x += (pow(min(0.8f, DCFlum), ((DCFlum) / 2.02f))) / (DCFintensity.x * 100);  /// Color-Operation RED-Channel
    DCFCol.y += (pow(min(0.8f, DCFlum), ((DCFlum) / 2.03f))) / (DCFintensity.y * 100);  /// Color-Operation GREEN-Channel
    DCFCol.z += (pow(min(0.8f, DCFlum), ((DCFlum) / 1.9f)))  / (DCFintensity.z * 100);  /// Color-Operation BLUE-Channel

    DCFCol = lerp(DCFCol, color, min(1.0f, (DCFlum+0.3f)));  /// Mix New-Color and Original-Input-Color depending on perceived Luminance
    DCFCol = saturate(DCFCol);                               /// Clip the Final-Color to Range [0..1] if required
    DCFCol = lerp(color, DCFCol, DCFintensity.w);            /// Mix Original-Input-Color and DCF-Color controlled by Mix-Input-Value

  return DCFCol;  /// returns new float3 Color (RED, GREEN, BLUE) to OUTPUT
}

// Dynamic Color Grading (Luminance based)
float3 DyColGrad(in float3 color, in float4 DCG) {
  float3 DCGcol   = color;                       /// Initialize Variable "SDCFCol" and get Input-Color
  float  DCGlum   = AvgLuma(color).w;            /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"
  float  DCGrslum = RSLum(color, DCGlum, 0.8f);  /// Get current Reversed-Shadow-Luminance -> CALLING FUNCTION "RSLum"

    DCGcol.x = DCGcol.x * (DCG.x * 100);  /// Color Operation RED Channel
    DCGcol.y = DCGcol.y * (DCG.y * 100);  /// Color Operation GREEN Channel
    DCGcol.z = DCGcol.z * (DCG.z * 100);  /// Color Operation BLUE Channel

    DCGcol = saturate(DCGcol);               /// Clip the Color-Graded-Color to Range [0..1] if required
    DCGcol = lerp(color, DCGcol, DCGrslum);  /// Mix Original-Input-Color and Color-Graded-Color controlled by Reversed-Shadow-Luminance
    DCGcol = lerp(color, DCGcol, DCG.w);     /// Mix Original-Input-Color and Final-Color controlled by Mix-Input-Value

  return DCGcol;  /// returns new float3 Color (RED, GREEN, BLUE) to OUTPUT
}

// Dynamic HSV Saturation (Luminance and Color based)
float3 DynHSVSat(in float3 color, in float DHSsatRGB, in float4 DHSsat, in float DHSpower) {
  float3 DHSCol;                            /// Initialize Variable "DHSCol"
  float  DHSLum       = AvgLuma(color).w;   /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"
  float3 DHSColChanPc = RGBpercent(color);  /// Initializing Variable "DHSColChanPc" (DHS-Color-Channel-Percentage) and get Color-Channel-Percentage of Input-Color -> CALLING FUNCTION "RGBpercent"

    float DHSdiv = DHSsatRGB;                                                                          /// Initialize Variable "DHSdiv" and get Value from Input-Variable "DHSsatRGB"
    if (DHSColChanPc.x > DHSColChanPc.y && DHSColChanPc.x > DHSColChanPc.z) DHSdiv = (DHSsat.x * 20);  /// If the RED-Channel is the strongest get Value from Input-Variable "DHSsatRED"
    if (DHSColChanPc.y > DHSColChanPc.x && DHSColChanPc.y > DHSColChanPc.z) DHSdiv = (DHSsat.y * 20);  /// If the GREEN-Channel is the strongest get Value from Input-Variable "DHSsatGREEN"
    if (DHSColChanPc.z > DHSColChanPc.y && DHSColChanPc.z > DHSColChanPc.x) DHSdiv = (DHSsat.z * 20);  /// If the BLUE-Channel is the strongest get Value from Input-Variable "DHSsatBLUE"

  float3 DHShsvCol = RGBtoHSV(color); /// Initialize Variable "DHShsvCol" and get HSV-Color from RGB-Color -> CALLING FUNCTION "RGBtoHSV"
        /// DHShsvCol.x = H (Hue)
        /// DHShsvCol.y = S (Saturation)
        /// DHShsvCol.z = V (Value)

  float DHScolSat = DHShsvCol.y * DHSLum; /// Initialize Variable "DHScolSat"
        /// Multiplicate current Saturation (in Range [0..1]) with current perceived Luminance (in Range [0..1])

    DHScolSat   = DHScolSat/DHSdiv;                                /// Divide Result by Variable "DHSdiv"
    DHScolSat   = DHShsvCol.y+((DHShsvCol.y*DHScolSat)*DHSpower);  /// Calculate Final Saturation
    DHScolSat   = saturate(DHScolSat);                             /// Clip Final-Saturation to Range [0..1] if required
    DHShsvCol.y = DHScolSat;                                       /// Copy Final-Saturation Value from Variable "DHScolSat" to HSV-Color
    DHSCol      = HSVtoRGB(DHShsvCol);                             /// Get RGB-Color from HSV-Color -> CALLING FUNCTION "HSVtoRGB"
    DHSCol      = lerp(color.xyz, DHSCol, DHSsat.w);               /// Mix Original-Input-Color and Saturated-Color controlled by Mix-Input-Value

  return DHSCol; /// returns new float3 Color (RED, GREEN, BLUE) to OUTPUT
}

// Dynamic HSV-Value (Luminance based)
float3 DynHSVvalue(in float3 color, in float DHVintensity ,in float DHVmix) {
  float3 DHVCol;                        /// Initialize Variable "DHVCol"
  float  DHVLum    = AvgLuma(color).w;  /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"
  float3 DHVhsvCol = RGBtoHSV(color);   /// Initialize Variable "DHVhsvCol" and get HSV-Color from RGB-Color -> CALLING FUNCTION "RGBtoHSV"
        /// DHVhsvCol.x = H (Hue)
        /// DHVhsvCol.y = S (Saturation)
        /// DHVhsvCol.z = V (Value)

    float DHVcolVal = (1.0f - DHVhsvCol.z) * (1.0f - DHVLum);  /// Calculate Base-HSV-Value depending on Inverse-Luminance
    DHVcolVal       = DHVhsvCol.z + DHVcolVal / DHVintensity;  /// Calculate Final-HSV-Value
    DHVcolVal       = saturate(DHVcolVal);                     /// Clip Final-HSV-Value to Range [0..1] if required
    DHVhsvCol.z     = DHVcolVal;                               /// Copy Final-HSV-Value to HSV-Color

    DHVCol = HSVtoRGB(DHVhsvCol);                 /// Get RGB-Color from HSV-Color -> CALLING FUNCTION "HSVtoRGB"
    DHVCol = lerp(DHVCol, color, 1.0f - DHVLum);  /// Mix New-Color and Original-Input-Color controlled by Inverse-Luminance
    DHVCol = lerp(color, DHVCol, DHVmix);         /// Mix Original-Input-Color and New-Color controlled by Mix-Input-Value

  return DHVCol;  /// returns new float3 Color (RED, GREEN, BLUE) to OUTPUT
}

// Dynamic Contrast Filter (Luminance and Color based)
float3 DynContrastFi(in float3 color, in float DCOFmix) {
  float3 DCOFcol       = color;              /// Initialize Variable "DCOFcol" and get Input-Color
  float DCOFlum        = AvgLuma(color).w;   /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"
  float3 DCOFColChanPc = RGBpercent(color);  /// Initializing Variable "DCOFColChanPc" (DCOF-Color-Channel-Percentage) and get Color-Channel-Percentage of Input-Color -> CALLING FUNCTION "RGBpercent"

    DCOFcol.x = pow(DCOFcol.x * 1.2f, 1.0f + (1.0f - DCOFColChanPc.z));  /// Color Operation RED-Channel depending on Inverse-BLUE-Channel-Amount
    DCOFcol.y = pow(DCOFcol.y * 1.2f, 1.0f + (1.0f - DCOFColChanPc.x));  /// Color Operation GREEN-Channel depending on Inverse-RED-Channel-Amount
    DCOFcol.z = pow(DCOFcol.z * 1.2f, 1.0f + (1.0f - DCOFColChanPc.y));  /// Color Operation BLUE-Channel depending on Inverse-GREEN-Channel-Amount

    DCOFcol = saturate(DCOFcol);              /// Clip Final-Color to Range [0..1] if required
    DCOFcol = lerp(color, DCOFcol, DCOFlum);  /// Mix Original-Input-Color and Final-Color controlled by Luminance
    DCOFcol = lerp(color, DCOFcol, DCOFmix);  /// Mix Original-Input-Color and Mixed-Final-Color controlled by Mix-Input-Value

  return DCOFcol;  /// returns new float3 Color (RED, GREEN, BLUE) to OUTPUT
}


// Output for above NXS shader functions
float3 msNXS(float3 color, float3 eBloom, float eAdapt) {
  float cpLum = eAdapt;  /// Calculate the perceived luminance of the color input

/// Tonemapping
    color.rgb = WardTonemap(color.rgb, cpLum, eTML * (1.0f + ((cpLum / 16.0f) * 0.7f)));

/// Bloom Mix
    eBloom.xyz = 1.0f - (1.0f - color.rgb) * (1.0f - eBloom.xyz);               /// Blend Color and Bloom
    cpLum      = AvgLuma(eBloom.xyz).w;                                         /// Get current perceived Luminance -> CALLING FUNCTION "AvgLuma"
    color.rgb  = lerp(color.rgb, eBloom.xyz, eDBLOOMFmix * min(0.37f, cpLum));  /// Mix Color and Blended-Bloom-Color depending on perceived Luminance

/// Dynamic color corrections
    color.rgb = DynDesatBr(color.rgb, eDDBmix);                        /// DYNAMIC-DESATURATING-BRIGHTNESS
    color.rgb = SDBColoringFilter(color.rgb, eAdapt, fAutoColorMix);   /// SMOOTH-DYNAMIC-BRIGHTNESS-COLORING-FILTER
    color.rgb = DynExpBrightRange(color.rgb);                          /// DYNAMIC-BRIGHTNESS-RANGE-EXPANSION
    color.rgb = SmoothDynConExp(color.rgb, eSDCEintensity);            /// SMOOTH-DYNAMIC-CONTRAST-EXPANSION
    color.rgb = DynDLight(color.rgb, eDDLmix);                         /// DYNAMIC-DETAILED-LIGHTNESS
    color.rgb = SmoothDynColFilt(color.rgb, eSDCF);                    /// SMOOTH-DYNAMIC-COLOR-FILTER
    color.rgb = DyCoFi(color.rgb, eDCF);                               /// DYNAMIC-COLOR-FILTER
    color.rgb = DyColGrad(color.rgb, eDCG);                            /// DYNAMIC-COLOR-GRADING
    color.rgb = DynHSVSat(color.rgb, eDHSrgb, eDHS, eDHSpower);        /// DYNAMIC-HSV-SATURATION
    color.rgb = DynHSVvalue(color.rgb, eDHVintensity, eDHVmix);        /// DYNAMIC-HSV-VALUE
    color.rgb = DynContrastFi(color.rgb, eDCONFmix);                   /// DYNAMIC-CONTRAST-FILTER

  return color;
}