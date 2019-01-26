//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//            Contains Histogram Adaptation            //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// kingeric1992: Histogram based adaptation author     //
//----------------------INFO LINKS---------------------//
// Histogram: https://goo.gl/3DvhSz                    //
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

int HA <string UIName="----------------HISTOGRAM ADAPTATION";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
    float Bias          < string UIName="ADAPT: Auto Exposure Bias (log2 scale)"; > = {0.0};
    float MaxBrightness < string UIName="ADAPT: Max Brightness (log2 scale)";  float UIMin= -9.0; float UIMax=3.0; > = {1.0};
    float MinBrightness < string UIName="ADAPT: Min Brightness (log2 scale)";  float UIMin= -9.0; float UIMax=3.0; > = {-4.0};
    float LowPercent    < string UIName="ADAPT: Low Percent";                  float UIMin=  0.5; float UIMax=1.0; > = {0.80};
    float HighPercent   < string UIName="ADAPT: High Percent";                 float UIMin=  0.5; float UIMax=1.0; > = {0.95};

// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //




// ------------------- //
//    VERTEX SHADER    //
// ------------------- //

void VS_Quad(inout float4 pos : SV_POSITION, inout float2 txcoord0 : TEXCOORD0) {
    pos.w     = 1.0;
    txcoord0 -= 7.0 / 256.0;
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
float4 PS_Downsample( float4 pos : SV_POSITION, float2 txcoord0 : TEXCOORD0) : SV_Target {
	float4 res = 0.0;
    float4 coord = { txcoord0.xyy, 1.0 / 128.0 };

	for (int x = 0; x < 8; x++) {
		coord.y = coord.z;
		for (int y = 0; y < 8; y++) {
			float4 color = TextureCurrent.Sample(Sampler1, coord.xy);
			res += max( color.r, max(color.g, color.b));
			coord.y += coord.w;
		}
		coord.x += coord.w;
	}

  return log2(res) - 6.0;  // log2(res / 64.0)
}

///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
/// output size is 1*1                                                 ///
/// TexturePrevious size is 1*1                                        ///
/// TextureCurrent size is 16*16                                       ///
/// output and input textures are R32 float format (red channel only)  ///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
float4 PS_Histogram() : SV_Target {
    float4 coord = {1.0 / 32.0, 1.0 / 32.0, 1.0 / 32.0, 1.0 / 16.0};
    float4 bin[16];

    for(int k = 0; k < 16; k++) {
        bin[k] = float4(0.0, 0.0, 0.0, 0.0);
    }

    [loop]
    for(int i = 0; i < 16.0; i++) {
        coord.y = coord.z;
        [loop]
        for(int j = 0; j < 16.0; j++) {
            float color = TextureCurrent.SampleLevel(Sampler0, coord.xy, 0.0).r;
            float level = saturate(( color + 5.0 ) / 7) * 63; // [-5, 2]  // Skyrim luminance detection range
//            float level = saturate(( color + 9.0 ) / 12) * 63; // [-9, 3]  // Fallout 4 luminance detection range
            bin[ level * 0.25 ] += float4(0.0, 1.0, 2.0, 3.0) == float4(trunc(level % 4).xxxx); //bitwise ?
            coord.y  += coord.w;
        }
        coord.x += coord.w;
    }

    float2 adaptAnchor = 0.5; //.x = high, .y = low
    float2 accumulate  = float2( HighPercent - 1.0, LowPercent - 1.0) * 256.0;

    [loop]
    for(int l=15; l>0; l--) {
        accumulate += bin[l].w;
        adaptAnchor = (accumulate.xy < bin[l].ww)? l * 4.0 + accumulate.xy / bin[l].ww + 3.0: adaptAnchor;

        accumulate += bin[l].z;
        adaptAnchor = (accumulate.xy < bin[l].zz)? l * 4.0 + accumulate.xy / bin[l].zz + 2.0: adaptAnchor;

        accumulate += bin[l].y;
        adaptAnchor = (accumulate.xy < bin[l].yy)? l * 4.0 + accumulate.xy / bin[l].yy + 1.0: adaptAnchor;

        accumulate += bin[l].x;
        adaptAnchor = (accumulate.xy < bin[l].xx)? l * 4.0 + accumulate.xy / bin[l].xx + 0.0: adaptAnchor;
    }

    float adapt = (adaptAnchor.x + adaptAnchor.y) * 0.5 / 63.0  * 7.0 - 5.0;  // Skyrim luminance detection range
//    float adapt = (adaptAnchor.x + adaptAnchor.y) * 0.5 / 63.0  * 12.0 - 9.0;  // Fallout 4 luminance detection range
          adapt =  pow(2.0, clamp( adapt, MinBrightness, MaxBrightness) + Bias);  // min max on log2 scale

  return lerp(TexturePrevious.Sample(Sampler0, 0.5).x, adapt, AdaptationParameters.w);
}


// ------------------- //
//     TECNHIQUES      //
// ------------------- //

technique11 Downsample
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Downsample()));
	}
}

technique11 Draw  <string UIName="Histogram Adaptation";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Histogram()));
	}
}