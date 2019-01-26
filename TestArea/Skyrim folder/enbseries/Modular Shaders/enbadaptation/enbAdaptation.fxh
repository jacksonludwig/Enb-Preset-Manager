//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//               Contains ENB Adaptation               //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// Boris: For ENBSeries and his knowledge and codes    //
// JawZ: Author and developer of MSL                   //
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

  bool ENABLE_HLSENSE < string UIName = "Enable Highlight Sensitivity"; > = {false};
    int CHOOSE_OUTPUT < string UIName = "Choose Grey Output";       string UIWidget="Spinner";  int UIMin=1;  int UIMax=3; > = {1};
    float3 fRGB_Out < string UIName = "Alter Grey RGB Output nr2";  string UIWidget="Color"; > = {0.3333, 0.3333, 0.3333};

int INFO_ADAPT1 <string UIName="--Instead of enbseries.ini values--";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float2 fAdaptSense1 < string UIName = "ADAPTATION: Sense -";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.5, 0.5};
    float2 fAdaptTime1 < string UIName = "ADAPTATION: Time -";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=100.0; > = {1.0, 1.0};
    float2 fAdaptMin1 < string UIName = "ADAPTATION: Min -";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=65536.0; > = {0.1, 0.1};
    float2 fAdaptMax1 < string UIName = "ADAPTATION: Max -";      string UIWidget="Spinner";  float UIMin=0.01;  float UIMax=65536.0; > = {10.0, 10.0};



// ------------------- //
//   DATA STRUCTURE    //
// ------------------- //

struct VS_INPUT_POST {
  float3 pos     : POSITION;
  float2 txcoord : TEXCOORD0;
};
struct VS_OUTPUT_POST {
  float4 pos      : SV_POSITION;
  float2 txcoord0 : TEXCOORD0;
};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //




// ------------------- //
//    VERTEX SHADER    //
// ------------------- //

VS_OUTPUT_POST VS_Quad(VS_INPUT_POST IN, uniform float sizeX, uniform float sizeY) {
  VS_OUTPUT_POST OUT;

    float4 pos;
    pos.xyz = IN.pos.xyz;
    pos.w   = 1.0;
    OUT.pos = pos;
    float2 offset;
    offset.x = sizeX;
    offset.y = sizeY;
    OUT.txcoord0.xy = IN.txcoord.xy + offset.xy;

  return OUT;
}


// ------------------- //
//    PIXEL SHADER     //
// ------------------- //

///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
/// output size is 16*16                                                         ///
/// TextureCurrent size is 256*256, it's internally downscaled from full screen  ///
/// input texture is R16G16B16A16 or R11G11B10 float format (alpha ignored)      ///
/// output texture is R32 float format (red channel only)                        ///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
float4 PS_Downsample(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
/// Time and Location interpolators
  float fAdaptSense = lerp(fAdaptSense1.x, fAdaptSense1.y, EInteriorFactor);


  float4 res;

/// Downsample 256*256 to 16*16
/// More complex blurring methods affect result if sensitivity uncommented
    float2 pos;
    float2 coord;
    float4 curr          = 0.0;
    float4 currmax       = 0.0;
    const float scale    = 1.0 / 16.0;
    const float step     = 1.0 / 16.0;
    const float halfstep = 0.5 / 16.0;
    pos.x                = -0.5 + halfstep;
    for (int x = 0; x < 16; x++) {
      pos.y = -0.5 + halfstep;
      for (int y = 0; y < 16; y++) {
        coord           = pos.xy * scale;
        float4 tempcurr = TextureCurrent.Sample(Sampler0, IN.txcoord0.xy + coord.xy);
        currmax         = max(currmax, tempcurr);
        curr           += tempcurr;
        pos.y          += step;
      }
      pos.x += step;
    }
    curr *= 1.0 / (16.0 * 16.0);

    res = curr;

  /// Adjust sensitivity to small bright areas on the screen
  /// Warning! Enabling the next line increases sensitivity a lot
  if (ENABLE_HLSENSE==true) res = lerp(curr, currmax, fAdaptSense); // fAdaptSense = AdaptationParameters.z

  ///gray output
  if (CHOOSE_OUTPUT==1)       res = AvgLuma(res.xyz).y;
  else if (CHOOSE_OUTPUT==2)  res = dot(res.xyz, float3(fRGB_Out.x, fRGB_Out.y, fRGB_Out.z));
  else if (CHOOSE_OUTPUT==3)  res = AvgLuma(res.xyz).w;

  res.w = 1.0;
  return res;
}

///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
/// output size is 1*1                                                 ///
/// TexturePrevious size is 1*1                                        ///
/// TextureCurrent size is 16*16                                       ///
/// output and input textures are R32 float format (red channel only)  ///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
float4 PS_Adaptation(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
/// Time and Location interpolators
  float fAdaptSense = lerp(fAdaptSense1.x, fAdaptSense1.y, EInteriorFactor);
  float fAdaptTime  = lerp(fAdaptTime1.x, fAdaptTime1.y, EInteriorFactor);
  float fAdaptMin   = lerp(fAdaptMin1.x, fAdaptMin1.y, EInteriorFactor);
  float fAdaptMax   = lerp(fAdaptMax1.x, fAdaptMax1.y, EInteriorFactor);


  float4 res;
  float prev = TexturePrevious.Sample(Sampler0, IN.txcoord0.xy).x;

/// Downsample 16*16 to 1*1
    float2 pos;
    float curr           = 0.0;
    float currmax        = 0.0;
    const float step     = 1.0 / 16.0;
    const float halfstep = 0.5 / 16.0;
    pos.x                = halfstep;

    for (int x = 0; x < 16; x++) {
      pos.y = halfstep;
      for (int y = 0; y < 16; y++) {
          float tempcurr = TextureCurrent.Sample(Sampler0, IN.txcoord0.xy + pos.xy).x;
          currmax        = max(currmax, tempcurr);
          curr          += tempcurr;
          pos.y         += step;
        }
      pos.x += step;
    }
    curr *= 1.0 / (16.0 * 16.0);

/// Adjust sensitivity to small bright areas on the screen
    curr = lerp(curr, currmax, fAdaptSense); /// fAdaptSense = AdaptationParameters.z

/// Smooth by time
    res = lerp(prev, curr, fAdaptTime * Timer.w); /// fAdaptTime * Timer.w ~= AdaptationParameters.w

/// Clamp to avoid bugs in post process shader, which have much lower floating point precision
    res = max(res, 0.001);
    res = min(res, 16384.0);

/// Limit value if ForceMinMaxValues=true
    float valmax;
    float valcut;
    valmax   = max(res.x, max(res.y, res.z));
    valcut   = max(valmax, fAdaptMin);  /// fAdaptMin = AdaptationParameters.x
    valcut   = min(valcut, fAdaptMax);  /// fAdaptMax = AdaptationParameters.y
    res *= valcut / (valmax + 0.000000001f);

  res.w = 1.0;
  return res;
}


// ------------------- //
//     TECNHIQUES      //
// ------------------- //

technique11 Downsample {  /// First pass for downscaling and computing sensitivity
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad(0.0, 0.0)));
    SetPixelShader(CompileShader(ps_5_0, PS_Downsample()));
  }
}

technique11 Draw {        /// Last pass for mixing everything
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad(0.0, 0.0)));
    SetPixelShader(CompileShader(ps_5_0, PS_Adaptation()));
  }
}