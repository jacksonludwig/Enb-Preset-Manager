//==========//
// Textures //
//==========//
Texture2D			TextureOriginal;     //color R16B16G16A16 64 bit hdr format
Texture2D			TextureColor;        //color which is output of previous technique (except when drawed to temporary render target), R16B16G16A16 64 bit hdr format
Texture2D			TextureDepth;        //scene depth R32F 32 bit hdr format
Texture2D			TextureJitter;       //blue noise
Texture2D			TextureMask;         //alpha channel is mask for skinned objects (less than 1) and amount of sss

Texture2D			RenderTargetRGBA32;  //R8G8B8A8 32 bit ldr format
Texture2D			RenderTargetRGBA64;  //R16B16G16A16 64 bit ldr format
Texture2D			RenderTargetRGBA64F; //R16B16G16A16F 64 bit hdr format
Texture2D			RenderTargetR16F;    //R16F 16 bit hdr format with red channel only
Texture2D			RenderTargetR32F;    //R32F 32 bit hdr format with red channel only
Texture2D			RenderTargetRGB32F;  //32 bit hdr format without alpha

#include "Shaders/ENBcommon.fxh"
#include "Shaders/Globals.fxh"
#include "Shaders/ReforgedUI.fxh"

UI_FLOAT(SkinGamma,             "Skin Gamma",                     0.5, 3.0, 0.5)
UI_FLOAT(SkinExposure,          "Skin Exposure",                 -2.0, 2.0, 0.0)
UI_FLOAT3(SkinTint,             "Skin Tint",                      0.55, 0.43, 0.42)
UI_FLOAT(SkinTintStrength,      "Skin Tint Power",                0.0, 1.0, 0.0)
UI_FLOAT(SkinHue,               "Skin Hue",                       0.0, 6.0, 0.0)
UI_FLOAT(HueOpacity,            "Skin Hue opacity",               0.0, 1.0, 0.0)
UI_WHITESPACE(1)
UI_BOOL(SkinSmoothing,          "Skin Smoothing",                 false)
UI_FLOAT(SkinSmoothingPower,    "Skin Smoothing Power",           0.0, 2.0, 0.0)
UI_BOOL(HighlightMasking,       "Highlight Detection",            false)
UI_FLOAT(Threshold,             "Highlight Detection Sensivity",  0.2, 1.0, 0.2)
UI_FLOAT(ThresholdRange,        "Highlight Detection Transition", 0.2, 1.0, 0.2)

//===========//
// Functions //
//===========//

#include "Shaders/SkinColor.fxh"
#include "Shaders/SkinBlur.fxh"


//============//
// Techniques //
//============//
technique11 pre <string UIName="Skin Editor";>
{
    pass p0
    {
        SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
        SetPixelShader (CompileShader(ps_5_0, PS_Skin()));
    }
}

technique11 pre1
{
    pass p0
    {
        SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
        SetPixelShader (CompileShader(ps_5_0, PS_Hblur()));
    }
}

technique11 pre2
{
    pass p0
    {
        SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
        SetPixelShader (CompileShader(ps_5_0, PS_Vblur()));
    }
}