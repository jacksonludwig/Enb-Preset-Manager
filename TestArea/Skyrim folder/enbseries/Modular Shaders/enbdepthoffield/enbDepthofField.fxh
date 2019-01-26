//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//             Contains ENB Depth of Field             //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// Boris: For ENBSeries and his knowledge and codes    //
// JawZ: Author and developer of MSL                   //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbdepthoffield.fx!
// The below list is only viable if the msHelpers.fxh is loaded/included into the enbdepthoffield.fx file!


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

  float EFocusingSensitivity  < string UIName="Focus: sensitivity to nearest";  string UIWidget="spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.5};
  float EApertureSize         < string UIName="Aperture: size";                 string UIWidget="spinner";  float UIMin=1.0;  float UIMax=16.0; > = {2.0};
  float ESensorSize           < string UIName="DoF: sensor size";               string UIWidget="spinner";  float UIMin=4.8;  float UIMax=36.0; > = {36.0};  /// kinda 1/CropFactor, 35 mm full frame 
  float EBokehSoftness        < string UIName="DoF: bokeh softness";            string UIWidget="spinner";  float UIMin=0.01;  float UIMax=1.0; > = {1.0};
  float EBlurRange            < string UIName="DoF: blur max range";            string UIWidget="spinner";  float UIMin=0.1;  float UIMax=2.0; > = {1.0};
  float fPos                  < string UIName="DoF: Focus Point";               string UIWidget="spinner";  float UIMin=0.0;  float UIMax=1.0; > = {0.5};


// ------------------- //
//    DoF Parameters   //
// ------------------- //



// ------------------- //
//    VERTEX SHADER    //
// ------------------- //

VS_OUTPUT_POST	VS_Quad(VS_INPUT_POST IN) {
	VS_OUTPUT_POST	OUT;
	float4	pos;
	pos.xyz         = IN.pos.xyz;
	pos.w           = 1.0;
	OUT.pos         = pos;
	OUT.txcoord0.xy = IN.txcoord.xy;
	return OUT;
}


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //



// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //



// ------------------- //
//    PIXEL SHADER     //
// ------------------- //

float4 PS_Aperture(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
////////////////////////////////////////////////////////////////////
//first passes to compute focus distance and aperture, temporary
//render targets are not available for them
////////////////////////////////////////////////////////////////////
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
/// output size is 1*1                                                 ///
/// TexturePrevious size is 1*1                                        ///
/// TextureCurrent not exist, so set to white 1.0                      ///
/// output and input textures are R32 float format (red channel only)  ///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
  float4 res;

  float curr;
  float prev = TexturePrevious.Sample(Sampler0, IN.txcoord0.xy).x;

/// TODO compute aperture here, from adaptation or from global variables
    curr = EApertureSize;  /// Constant in this example
    curr = max(curr, 1.0); /// Safety
    curr = 1.0 / curr;     /// Map it to 0..1 range. for brightness it must be curr*curr (2*Pi*R*R)

/// Smooth by time
    res = lerp(prev, curr, DofParameters.z); /// ApertureTime with elapsed time

/// Clamp to avoid bugs, 1 means fully open, bigger than 0 for proper adaptation later
    res = max(res, 0.0000000001);
    res = min(res, 1.0);

  res.w = 1.0;
  return res;
}

float4 PS_ReadFocus(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
/// output size is 16*16                                   ///
/// output texture is R32 float format (red channel only)  ///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
  float4 res;

/// Warning! For first person models (weapon) it's better to ignore depth to avoid wrong focusing,
/// so this is done via fpdistance

/// This example reads depth almost from center of the screen
    float2 pos;
    float  curr = 0.0;
//  float currmin = 1.0;
    const float step = 1.0 / 16.0;
    const float halfstep = 0.5 / 16.0;
    pos.x = halfstep;
    for (int x=0; x<16; x++)
    {
      pos.y = halfstep;
      for (int y=0; y<16; y++)
      {
        float2 coord = pos.xy * 0.05;
        coord += IN.txcoord0.xy * 0.05 + float2(0.5, 0.5); /// Somewhere around the center of screen
        float tempcurr = TextureDepth.SampleLevel(Sampler0, fPos, 0.0).x;

      /// Do not blur first person models like weapons and hands
        const float fpdistance = 1.0 / 0.085;
        float fpfactor = 1.0-saturate(1.0 - tempcurr * fpdistance);
        tempcurr = lerp(1.0, tempcurr, fpfactor * fpfactor);

//      currmin = min(currmin, tempcurr);
        curr += tempcurr;

        pos.y += step;
      }
      pos.x += step;
    }
    curr *= 1.0 / (16.0 * 16.0);
    res = curr;

/// Clamp to avoid bugs
    res = max(res, 0.0);
    res = min(res, 1.0);

  res.w = 1.0;
  return res;
}

float4 PS_Focus(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
/// output size is 1*1                                                 ///
/// TexturePrevious size is 1*1                                        ///
/// TextureCurrent size is 16*16                                       ///
/// output and input textures are R32 float format (red channel only)  ///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
  float4 res;

    float prev = TexturePrevious.Sample(Sampler0, IN.txcoord0.xy).x;

/// Downsample 16*16 to 1*1
    float2 pos;
    float  curr          = 0.0;
    float  currmin       = 1.0;
    const float step     = 1.0 / 16.0;
    const float halfstep = 0.5 / 16.0;
    pos.x = halfstep;
    for (int x=0; x<16; x++)
    {
      pos.y = halfstep;
      for (int y=0; y<16; y++)
      {
        float tempcurr = TextureCurrent.Sample(Sampler0, IN.txcoord0.xy + pos.xy).x;
        currmin        = min(currmin, tempcurr);
        curr          +=tempcurr;
        pos.y         += step;
      }
      pos.x += step;
    }
    curr *= 1.0 / (16.0 * 16.0);

/// Adjust sensitivity to nearest areas of the screen
    curr = lerp(curr, currmin, EFocusingSensitivity);

/// Smooth by time
    res = lerp(prev, curr, DofParameters.w); /// FocusingTime with elapsed time

/// Clamp to avoid bugs, unless it's depth
    res = max(res, 0.0);
    res = min(res, 1.0);

  res.w = 1.0;
  return res;
}

float4 PS_ComputeFactor(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
////////////////////////////////////////////////////////////////////
//multiple passes for computing depth of field, with temporary render
//targets support.
//TextureCurrent, TexturePrevious are unused
////////////////////////////////////////////////////////////////////
/// Draw to temporary render target
  float4 res;

  float depth    = TextureDepth.Sample(Sampler0, IN.txcoord0.xy).x;
  float focus    = TextureFocus.Sample(Sampler0, IN.txcoord0.xy).x;
  float aperture = TextureAperture.Sample(Sampler0, IN.txcoord0.xy).x;

/// Clamp to avoid potenrial bugs
    depth = max(depth, 0.0);
    depth = min(depth, 1.0);

/// Compute blur radius
    float scaling = EBlurRange; /// Abstract scale in screen space
    float factor  = depth - focus;

    factor = factor * ESensorSize * aperture * scaling;
/// Limit size
    float screensizelimit = ESensorSize * scaling;
    factor = max(factor, -screensizelimit);
    factor = min(factor, screensizelimit);

    res = factor;

/// Do not blur first person models like weapons
    const float fpdistance = 1.0 / 0.085;
    float fpfactor         = 1.0 - saturate(1.0 - depth * fpdistance);
    res                = res * fpfactor * fpfactor;

  res.w = 1.0;
  return res;
}

float4 PS_Dof(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target {
/// Example of blur. without any fixes of artifacts and low performance
  float4 res;

    float focusing;
    focusing = RenderTargetR16F.Sample(Sampler0, IN.txcoord0.xy).x;

    float2 sourcesizeinv;
    float2 fstepcount;
    sourcesizeinv   = ScreenSize.y;
    sourcesizeinv.y = ScreenSize.y*ScreenSize.z;
    fstepcount.x    = ScreenSize.x;
    fstepcount.y    = ScreenSize.x*ScreenSize.w;

    float2 pos;
    float2 coord;
    float4 curr   = 0.0;
    float  weight = 0.000001;

    fstepcount     = abs(focusing);
    sourcesizeinv *= focusing;

    fstepcount = min(fstepcount, 32.0);
    fstepcount = max(fstepcount, 0.0);

    int stepcountX = (int)(fstepcount.x + 1.4999);
    int stepcountY = (int)(fstepcount.y + 1.4999);
    fstepcount     = max(fstepcount, 2.0);
    float2 halfstepcountinv = 2.0 / fstepcount;
    pos.x = -1.0 + halfstepcountinv.x;
    for (int x=0; x<stepcountX; x++)
    {
      pos.y = -1.0 + halfstepcountinv.y;
      for (int y=0; y<stepcountY; y++)
      {
        float tempweight;
        float rangefactor = dot(pos.xy, pos.xy);
        coord             = pos.xy * sourcesizeinv;
        coord            += IN.txcoord0.xy;
        float4 tempcurr   = TextureColor.SampleLevel(Sampler1, coord.xy, 0.0);
        tempweight        = saturate(1001.0 - 1000.0*rangefactor);  /// Arithmetic version to cut circle from square
        tempweight       *= saturate(1.0 - rangefactor * EBokehSoftness);
        curr.xyz         += tempcurr.xyz * tempweight;
        weight           += tempweight;

        pos.y            += halfstepcountinv.y;
      }
      pos.x += halfstepcountinv.x;
    }
    curr.xyz /= weight;

    res.xyz = curr;

  res.w = 1.0;
  return res;
}


// ------------------- //
//      TECHNIQUES     //
// ------------------- //

///+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
/// Techniques are drawn one after another and they use the result of   ///
/// the previous technique as input color to the next one.  The number  ///
/// of techniques is limited to 255.  If UIName is specified, then it   ///
/// is a base technique which may have extra techniques with indexing   ///
///+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///

technique11 Aperture {   /// Write aperture with time factor, this is always first technique
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_Aperture()));
  }
}
technique11 ReadFocus {  /// Compute focus from depth of screen and may be brightness, this is always second technique´
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_ReadFocus()));
  }
}
technique11 Focus {      /// Write focus with time factor, this is always third technique
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_Focus()));
  }
}

/// DoF example. draw first to temporary texture, then compute effect in other technique.
technique11 Dof <string UIName="ENB Depth of Field"; string RenderTarget="RenderTargetR16F";> {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_ComputeFactor()));
  }
}
technique11 Dof1 {
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
    SetPixelShader(CompileShader(ps_5_0, PS_Dof()));
  }
}