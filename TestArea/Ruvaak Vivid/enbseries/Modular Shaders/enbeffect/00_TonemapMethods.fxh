//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//             Contains Tonemapping methods            //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// Erik Reinhard: Photographic Tone Reproduction       //
// Michael Stark: Photographic Tone Reproduction       //
// Peter Shirley: Photographic Tone Reproduction       //
// James Ferwerda: Photographic Tone Reproduction      //
// John Hable: Filmic Uncharted2D                      //
// easyrgb.com: Example of the RGB>XYZ>Yxy color space //
// Charles Poynton: Color FAQ                          //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbeffect.fx!
// The below list is only viable if the mshelpers.fxh is loaded/included into the enbeffect.fx file!

// For the Local tone mapping to render as they should, you need to have ENBSeries bloom active.
// You can have BloomAmount set to 0.0 to visually have it off though.


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

int TM1 <string UIName="---------------TONEMAPPING OPERATORS";  string UIWidget="Spinner";  int UIMin=0.0;  int UIMax=0.0;  > = {0.0};
int TM2 <string UIName="Change operator in TECHNIQUE menu";  string UIWidget="Spinner";  int UIMin=0.0;  int UIMax=0.0;  > = {0.0};
int TM3 <string UIName="Local Operators NEED Bloom";  string UIWidget="Spinner";  int UIMin=0.0;  int UIMax=0.0;  > = {0.0};

//string LOGARITHMIC = "Logarithmic Variables";
    float LOGMaxWhite < string UIName="LOGARITHMIC: Max White";                  string UIWidget="Spinner";  float UIMin=0.01;  float UIMax=25.0; > = {1.0};
	float LOGLumSaturation < string UIName="LOGARITHMIC: Luminance Saturation";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=4.0; > = {1.0};

//string DRAGOLOG = "Drago Logarithmic Variables";
    float DRAGOMaxWhite < string UIName="DRAGO LOG: Max White";                  string UIWidget="Spinner";  float UIMin=0.01;  float UIMax=25.0; > = {1.0};
    float DRAGOBias < string UIName="DRAGO LOG: Bias";                           string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=4.0; > = {0.5};
    float DRAGOLumSaturation < string UIName="DRAGO LOG: Luminance Saturation";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=4.0; > = {1.0};

//string EXPONENTIAL = "Exponential Variables";
    float EXPMaxWhite < string UIName="EXPONENTIAL: Max White";                  string UIWidget="Spinner";  float UIMin=0.01;  float UIMax=25.0; > = {1.0};
    float EXPLumSaturation < string UIName="EXPONENTIAL: Luminance Saturation";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=4.0; > = {1.0};

//string REINHARDB = "Reinhard Basic Variables";
    float REINBMaxWhite < string UIName="REINHARDB: Max White";                  string UIWidget="Spinner";  float UIMin=0.01;  float UIMax=25.0; > = {1.0};
    float REINBLumSaturation < string UIName="REINHARDB: Luminance Saturation";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=4.0; > = {1.0};

//string REINHARDM = "Reinhard Modified Variables";
    float REINMMaxWhite < string UIName="REINHARDM: Max White";                  string UIWidget="Spinner";  float UIMin=0.01;  float UIMax=25.0; > = {1.0};
    float REINMLumSaturation < string UIName="REINHARDM: Luminance Saturation";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=4.0; > = {1.0};

//string FILMIC_ALU = "Filmic ALU Variables";
    float ALUUpperTone < string UIName="FILMIC-ALU: Upper Tone";                 string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {0.75};
    float ALUGreyPoint < string UIName="FILMIC-ALU: Grey Point";                 string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.55};
    float ALUMiddleTone < string UIName="FILMIC-ALU: Middle Tone";               string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {0.35};
    float ALULowerTone < string UIName="FILMIC-ALU: Lower Tone";                 string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {0.25};

//string FILMIC_UNCHARTED2D = "Filmic Uncharted2D Variables";
    float U2DShoulderStrength < string UIName="FILMIC-U2D: Shoulder Strength";   string UIWidget="Spinner";  float UIMin=0.001;  float UIMax=2.0; > = {0.16};
    float U2DLinearStrength < string UIName="FILMIC-U2D: Linear Strength";       string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=5.0; > = {0.1};
    float U2DLinearAngle < string UIName="FILMIC-U2D: Linear Angle";             string UIWidget="Spinner";  float UIMin=0.001;  float UIMax=1.0; > = {0.1};
    float U2DToeStrength < string UIName="FILMIC-U2D: Toe Strength";             string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=2.0; > = {0.4};
    float U2DToeNumerator < string UIName="FILMIC-U2D: Toe Numerator";           string UIWidget="Spinner";  float UIMin=0.001;  float UIMax=0.5;  float UIStep=0.001; > = {0.001};
    float U2DToeDenominator < string UIName="FILMIC-U2D: Toe Denominator";       string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=2.0; > = {0.3};
    float U2DLinearWhite < string UIName="FILMIC-U2D: Linear White";             string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=20.0; > = {1.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

// PIXEL SHADERS
float4 PS_TM_Logarithmic(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {                // Global operator technique
  float4 res;                                                    /// Output
  float4 color = TextureColor.Sample(Sampler0, IN.txcoord0.xy);  /// HDR scene color

/// Tonemapping, Logarithmic
    float pixelLuminance      = AvgLuma(color.rgb).w;
    float toneMappedLuminance = log10(1.0f + pixelLuminance) / log10(1.0f + LOGMaxWhite);
    color.rgb                 = toneMappedLuminance * pow(color.rgb / pixelLuminance, LOGLumSaturation);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}

float4 PS_TM_Logarithmic_Local(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {          // Local operator technique
  float4 res;                                                         /// Output
  float4 color  = TextureColor.Sample(Sampler0, IN.txcoord0.xy);      /// HDR scene color
  float3 eBloom = TextureBloom.Sample(Sampler1, IN.txcoord0.xy).xyz;  /// ENB and Skyrim SE bloom

/// Tonemapping, Logarithmic
    float pixelLuminance      = AvgLuma(color.rgb).w / (1.0f + eBloom.xyz);
    float toneMappedLuminance = log10(1.0f + pixelLuminance) / log10(1.0f + LOGMaxWhite);
    color.rgb                 = toneMappedLuminance * pow(color.rgb / pixelLuminance, LOGLumSaturation);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}


float4 PS_TM_DragoLogarithmic(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {           // Global operator technique
  float4 res;                                                    /// Output
  float4 color = TextureColor.Sample(Sampler0, IN.txcoord0.xy);  /// HDR scene color

// Tonemapping, Drago Logarithmic
    float pixelLuminance      = AvgLuma(color.rgb).w;
    float toneMappedLuminance = log10(1.0f + pixelLuminance);
    toneMappedLuminance      /= log10(1.0f + DRAGOMaxWhite);
    toneMappedLuminance      /= log10(2.0f + 8.0f * ((pixelLuminance / DRAGOMaxWhite) * log10(DRAGOBias) / log10(0.5f)));
    color.rgb                 = toneMappedLuminance * pow(color.rgb / pixelLuminance, DRAGOLumSaturation);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}

float4 PS_TM_DragoLogarithmic_Local(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {     // Local operator technique
  float4 res;                                                         /// Output
  float4 color = TextureColor.Sample(Sampler0, IN.txcoord0.xy);       /// HDR scene color
  float3 eBloom = TextureBloom.Sample(Sampler1, IN.txcoord0.xy).xyz;  /// ENB and Skyrim SE bloom
  float4 eAdapt = TextureAdaptation.Sample(Sampler0, IN.txcoord0.xy);  /// ENB and Skyrim SE adaptation

// Tonemapping, Drago Logarithmic
    float pixelLuminance      = AvgLuma(color.rgb).w;
    float toneMappedLuminance = log10(1.0f + pixelLuminance);
    toneMappedLuminance      /= log10(1.0f + DRAGOMaxWhite);
    toneMappedLuminance      /= log10(2 + 8 * ((eAdapt.x / DRAGOMaxWhite) * log10(DRAGOBias) / log10(0.5f)));
    color.rgb                 = toneMappedLuminance * pow(color.rgb / pixelLuminance, DRAGOLumSaturation);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}


float4 PS_TM_Exponential(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {                // Global operator technique
  float4 res;                                                    /// Output
  float4 color = TextureColor.Sample(Sampler0, IN.txcoord0.xy);  /// HDR scene color

// Tonemapping, Exponential
    float pixelLuminance      = AvgLuma(color.rgb).w;
    float toneMappedLuminance = 1.0f - exp(-pixelLuminance / EXPMaxWhite);
    color.rgb                 = toneMappedLuminance * pow(color.rgb / pixelLuminance, EXPLumSaturation);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}

float4 PS_TM_Exponential_Local(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {          // Local operator technique
  float4 res;                                                         /// Output
  float4 color  = TextureColor.Sample(Sampler0, IN.txcoord0.xy);      /// HDR scene color
  float3 eBloom = TextureBloom.Sample(Sampler1, IN.txcoord0.xy).xyz;  /// ENB and Skyrim SE bloom

// Tonemapping, Exponential
    float pixelLuminance      = AvgLuma(color.rgb).w / (1.0f + eBloom.xyz);
    float toneMappedLuminance = 1.0f - exp(-pixelLuminance / EXPMaxWhite);
    color.rgb                 = toneMappedLuminance * pow(color.rgb / pixelLuminance, EXPLumSaturation);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}


float4 PS_TM_ReinhardBasic(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {              // Global operator technique
  float4 res;                                                    /// Output
  float4 color = TextureColor.Sample(Sampler0, IN.txcoord0.xy);  /// HDR scene color

// Tonemapping, Reinhard Basic
    float pixelLuminance      = AvgLuma(color.rgb).w;
    float toneMappedLuminance = pixelLuminance / (pixelLuminance + 1.0f);
    color.rgb                 = toneMappedLuminance * pow(color.rgb / pixelLuminance, REINBLumSaturation);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}

float4 PS_TM_ReinhardBasic_Local(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {        // Local operator technique
  float4 res;                                                         /// Output
  float4 color  = TextureColor.Sample(Sampler0, IN.txcoord0.xy);      /// HDR scene color
  float3 eBloom = TextureBloom.Sample(Sampler1, IN.txcoord0.xy).xyz;  /// ENB and Skyrim SE bloom

// Tonemapping, Reinhard Basic
    float pixelLuminance      = AvgLuma(color.rgb).w;
    float toneMappedLuminance = pixelLuminance / (1.0f + eBloom.xyz);
    color.rgb                 = toneMappedLuminance * pow(color.rgb / pixelLuminance, REINBLumSaturation);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}


float4 PS_TM_ReinhardModified(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {           // Global operator technique
  float4 res;                                                    /// Output
  float4 color = TextureColor.Sample(Sampler0, IN.txcoord0.xy);  /// HDR scene color

// Tonemapping, Reinhard Modified
    float pixelLuminance      = AvgLuma(color.rgb).w;
    float toneMappedLuminance = pixelLuminance * (1.0f + pixelLuminance / (REINMMaxWhite * REINMMaxWhite)) / (1.0f + pixelLuminance);
    color.rgb                 = toneMappedLuminance * pow(color.rgb / pixelLuminance, REINMLumSaturation);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}

float4 PS_TM_ReinhardModified_Local(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {     // Local operator technique
  float4 res;                                                         /// Output
  float4 color  = TextureColor.Sample(Sampler0, IN.txcoord0.xy);      /// HDR scene color
  float3 eBloom = TextureBloom.Sample(Sampler1, IN.txcoord0.xy).xyz;  /// ENB and Skyrim SE bloom
  float4 eAdapt = TextureAdaptation.Sample(Sampler0, IN.txcoord0.xy);  /// ENB and Skyrim SE adaptation

// Tonemapping, Reinhard Modified
    float pixelLuminance      = AvgLuma(color.rgb).w;
    float toneMappedLuminance = pixelLuminance * (1.0f + pixelLuminance / (REINMMaxWhite * REINMMaxWhite)) / (1.0f + eAdapt.x);
    color.rgb                 = toneMappedLuminance * pow(color.rgb / pixelLuminance, REINMLumSaturation);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}


float4 PS_TM_FilmicALU(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {                  // Global operator technique
  float4 res;                                                    /// Output
  float4 color = TextureColor.Sample(Sampler0, IN.txcoord0.xy);  /// HDR scene color

// Tonemapping, Filmic ALU
    color.rgb = max(0, color.rgb - 0.004f);
    color.rgb = (color.rgb * (ALUUpperTone * color.rgb + ALUGreyPoint)) / (color.rgb * (ALUUpperTone * color.rgb + ALUMiddleTone) + ALULowerTone);
    color.rgb = pow(color.rgb, 2.2f);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}

float4 PS_TM_FilmicALU_Local(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {            // Local operator technique
  float4 res;                                                         /// Output
  float4 color  = TextureColor.Sample(Sampler0, IN.txcoord0.xy);      /// HDR scene color
  float3 eBloom = TextureBloom.Sample(Sampler1, IN.txcoord0.xy).xyz;  /// ENB and Skyrim SE bloom
  float4 eAdapt = TextureAdaptation.Sample(Sampler0, IN.txcoord0.xy);  /// ENB and Skyrim SE adaptation

// Tonemapping, Filmic ALU
    color.rgb = max(0, color.rgb - 0.004f);
    color.rgb = (color.rgb * (ALUUpperTone * color.rgb + ALUGreyPoint / (1.0f + eAdapt.x))) / (color.rgb * (ALUUpperTone * eAdapt.x + ALUMiddleTone) + ALULowerTone);
    color.rgb = pow(color.rgb, 2.2f);

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}


float4 PS_TM_FilmicUncharted2D(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {          // Global operator technique
/// Time and Location interpolators
  float U2D_A = U2DShoulderStrength;
  float U2D_B = U2DLinearStrength;
  float U2D_C = U2DLinearAngle;
  float U2D_D = U2DToeStrength;
  float U2D_E = U2DToeNumerator;
  float U2D_F = U2DToeDenominator;
  float U2D_W = U2DLinearWhite;

  float4 res;                                                    /// Output
  float4 color = TextureColor.Sample(Sampler0, IN.txcoord0.xy);  /// HDR scene color

// Tonemapping, Filmic Uncharted2D
    float3 numerator   = ((color.rgb * (U2D_A * color.rgb + U2D_C * U2D_B) + U2D_D * U2D_E) / (color.rgb * (U2D_A * color.rgb + U2D_B) + U2D_D * U2D_F)) - U2D_E / U2D_F;
    float3 denominator = ((U2D_W * (U2D_A * U2D_W + U2D_C * U2D_B) + U2D_D * U2D_E) / (U2D_W * (U2D_A * U2D_W + U2D_B) + U2D_D * U2D_F)) - U2D_E / U2D_F;
    color.rgb          = numerator / denominator;

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}

float4 PS_TM_FilmicUncharted2D_Local(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {    // Local operator technique
/// Time and Location interpolators
  float U2D_A = U2DShoulderStrength;
  float U2D_B = U2DLinearStrength;
  float U2D_C = U2DLinearAngle;
  float U2D_D = U2DToeStrength;
  float U2D_E = U2DToeNumerator;
  float U2D_F = U2DToeDenominator;
  float U2D_W = U2DLinearWhite;

  float4 res;                                                         /// Output
  float4 color  = TextureColor.Sample(Sampler0, IN.txcoord0.xy);      /// HDR scene color
  float4 eBloom = TextureBloom.Sample(Sampler1, IN.txcoord0.xy);  /// ENB and Skyrim SE bloom
  float4 eAdapt = TextureAdaptation.Sample(Sampler0, IN.txcoord0.xy);  /// ENB and Skyrim SE adaptation

// Tonemapping, Filmic Uncharted2D
    float3 numerator   = ((color.rgb * (U2D_A * color.rgb + U2D_C * U2D_B) + U2D_D * U2D_E) / (color.rgb * (U2D_A * color.rgb + U2D_B) + U2D_D * U2D_F)) - U2D_E / U2D_F;
    float3 denominator = (((U2D_W / (1.0f + eAdapt.x)) * (U2D_A * (U2D_W / (1.0f + eAdapt.x)) + U2D_C * U2D_B) + U2D_D * U2D_E) / ((U2D_W / (1.0f + eAdapt.x)) * (U2D_A * (U2D_W / (1.0f + eAdapt.x)) + U2D_B) + U2D_D * U2D_F)) - U2D_E / U2D_F;
    color.rgb          = numerator / denominator;

/// OUTPUT
  res.xyz = color.xyz;
  res.w = 1.0;
  return res;
}



// TECHNIQUES
technique11 Shader_TM_1 <string UIName="TM: Logarithmic";> {                  // Global operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_Logarithmic()));
	}
}

technique11 Shader_TM_8 <string UIName="TM: Logarithmic Local";> {            // Local operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_Logarithmic_Local()));
	}
}


technique11 Shader_TM_2 <string UIName="TM: Drago Logarithmic";> {            // Global operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_DragoLogarithmic()));
	}
}

technique11 Shader_TM_9 <string UIName="TM: Drago Logarithmic Local";> {      // Local operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_DragoLogarithmic_Local()));
	}
}


technique11 Shader_TM_3 <string UIName="TM: Exponential";> {                  // Global operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_Exponential()));
	}
}

technique11 Shader_TM_10 <string UIName="TM: Exponential Local";> {           // Local operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_Exponential_Local()));
	}
}


technique11 Shader_TM_4 <string UIName="TM: Reinhard Basic";> {               // Global operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_ReinhardBasic()));
	}
}

technique11 Shader_TM_11 <string UIName="TM: Reinhard Basic Local";> {        // Local operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_ReinhardBasic_Local()));
	}
}


technique11 Shader_TM_5 <string UIName="TM: Reinhard Modified";> {            // Global operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_ReinhardModified()));
	}
}

technique11 Shader_TM_12 <string UIName="TM: Reinhard Modified Local";> {     // Local operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_ReinhardModified_Local()));
	}
}


technique11 Shader_TM_6 <string UIName="TM: Filmic-ALU";> {                   // Global operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_FilmicALU()));
	}
}

technique11 Shader_TM_13 <string UIName="TM: Filmic-ALU Local";> {            // Local operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_FilmicALU_Local()));
	}
}


technique11 Shader_TM_7 <string UIName="TM: Filmic-Uncharted2D";> {           // Global operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_FilmicUncharted2D()));
	}
}

technique11 Shader_TM_14 <string UIName="TM: Filmic-Uncharted2D Local";> {    // Local operator technique
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_TM_FilmicUncharted2D_Local()));
	}
}