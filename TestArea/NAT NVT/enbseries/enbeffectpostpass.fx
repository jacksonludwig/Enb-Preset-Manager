//********************************************************//
//                ENBSeries effect file                   //
//          visit http://enbdev.com for updates           //
//        Copyright (c) 2007-2016 Boris Vorontsov         //
//-----------------------CREDITS--------------------------//
//     Please do not redistribute without credits         //
//    Boris: For ENBSeries and his knowledge and codes    //
//    JawZ:  Author and developer of the MSL code         //
//    CeeJay.dk-Crosire-GemFx-Marty McFly-Lucifer Hawk:   //
//           Original Authors of sweeFX & Reshade code    //
//    L00 : Port and Modification of ReShade Shaders      //
//           for Re-Engaged preset by Firemanaf           //
//              and author of this file                   //
//********************************************************//
////////////////////////////////////////////////////////////
//               Natural View Tamriel-NVT ENB             //
//--------------------------------------------------------//
//             POST-PROCESSING SHADER SUITE               //
//                        0.0.1                           //
//     based on PhotoRealistic Tamriel PostProcessing     //
////////////////////////////////////////////////////////////

//++++++++++++++++++++++++++++++++++++++++++++++++++++
//       INTERNAL PARAMETERS AND NO GUI SETTINGS  //This part works like sweetfx
//++++++++++++++++++++++++++++++++++++++++++++++++++++
///LEVELS:

#define Levels_black_point 0
#define Levels_white_point 255

///CURVES:
//strenght is controlled with the gui but this two other settings don't work if they aren't defined from here
//save here, then apply changes with ENB menu to recompute the shaders.

#define Curves_mode 0 //[0|1|2] //-Choose what to apply contrast to. 0 = Luma, 1 = Chroma, 2 = both Luma and Chroma. Default is 0 (Luma)
#define Curves_formula 3 //[1|2|3|4|5|6|7|8|9|10|11] //-The contrast s-curve you want to use. 1 = Sine, 2 = Abs split, 3 = Smoothstep, 4 = Exp formula, 5 = Simplified Catmull-Rom (0,0,1,1), 6 = Perlins Smootherstep, 7 = Abs add, 8 = Techicolor Cinestyle, 9 = Parabola, 10 = Half-circles. 11 = Polynomial split. Note that Technicolor Cinestyle is practically identical to Sine, but runs slower. In fact I think the difference might only be due to rounding errors. I prefer 2 myself, but 3 is a nice alternative with a little more effect (but harsher on the highlight and shadows) and it's the fastest formula.

/// LUTS: 
Texture2D TextureLUT	 <string ResourceName = "Textures/Firelut1.png";>;  ///change the name.png here if you need to use another lut
#define ENABLE_3DLUT true
#define TuningColorLUTTileAmountX 256 
#define TuningColorLUTTileAmountY 16 
#define TuningColorLUTNorm float2(1.0/float(TuningColorLUTTileAmountX),1.0/float(TuningColorLUTTileAmountY))

//++++++++++++++++++++++++++++++++++++++++++++++++++++
//               GRAPHIC USER INTERFACE  /// 
// This where you preset the interface you use in the ENB MENU. 
// Each settings (float (usualy a variable with a name), integrer (1,2,3,4,5...), bool (yes or no, true or false, 1 or 2)) is linked to the code
// "string UIname is the string you see in the menu and can be whatever you want, but can't be the same twice"
// Uiwidget is the kind of interface, most are spinner that is the circle GUI.
// Ui min/max are here to define the minimum values and maximum values. You can use negative values if you want.
// the last value in {} is where you define the default value for the variable if it's not defined from the .fx.ini
//++++++++++++++++++++++++++++++++++++++++++++++++++++
/// BLUR SHARPENING
int SharpBlur <string UIName="-----------------------SHARP & BLUR";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_BLURRING <
    string UIName = "Enable Blurring";
  > = {false};
  bool ENABLE_SHARPENING <
    string UIName = "Enable Sharpening";
  > = {false};
  bool ENABLE_DEPTHSHARP <
    string UIName = "Enable Depth Sharpening";
  > = {false};
  bool ENABLE_LUMA <
    string UIName = "Enable Luma Sharpening";
  > = {false};
  bool VISUALIZE_SHARP <
    string UIName = "Visualize Sharpening";
  > = {false};

  float EBlurAmount <
    string UIName="Blur: amount";         string UIWidget="spinner";  float UIMin=0.0;  float UIMax=1.0;
  > = {1.0};
  float EBlurRange <
    string UIName="Blur: range";          string UIWidget="spinner";  float UIMin=0.0;  float UIMax=2.0;
  > = {1.0};
  float ESharpAmount <
    string UIName="Sharp: amount";        string UIWidget="spinner";  float UIMin=0.0;  float UIMax=4.0;
  > = {1.0};
  float ESharpRange <
    string UIName="Sharp: range";         string UIWidget="spinner";  float UIMin=0.0;  float UIMax=2.0;
  > = {1.0};
  int fSharpFDepth <
    string UIName="Sharp: From Depth";    string UIWidget="Spinner";  int UIMin=0.0;  int UIMax=100000.0;
  > = {300.0};

///VIGNETTE  
  
int Vignette <string UIName="--------------------------VIGNETTE";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
    bool ENABLE_VIGNETTE <
        string UIName = "Enable Vignette";
    > = {false};

    float EVignetteAmount <
        string UIName="Vignette: Amount";       string UIWidget="Spinner";    float UIMin=0.0;
    > = {1.0};
    float EVignetteCurve <
        string UIName="Vignette: Curve";        string UIWidget="Spinner";    float UIMin=0.0;
    > = {4.0};
    float EVignetteRadius <
        string UIName="Vignette: Radius";       string UIWidget="Spinner";    float UIMin=0.0;
    > = {1.4};
    float3 EVignetteColor <
        string UIName="Vignette: RGB Color";    string UIWidget="Color"; /// Uiwidget color is the one that give you the rectangular color preview
    > = {0.0, 0.0, 0.0};

///GRAIN	
	
int Grain <string UIName="----------------------------GRAIN";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
    bool ENABLE_GRAIN <
        string UIName = "Enable Grain";
    > = {false};
    bool VISUALIZE_GRAIN <
        string UIName = "Visualize Grain";
    > = {false};

    float fGrainIntensity <
        string UIName="Grain: Intensity";   string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.5;  float UIStep=0.001; /// Uistep defines the incremental values of the spinner
    > = {0.035};
    float fGrainSaturation <
        string UIName="Grain: Saturation";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.5;  float UIStep=0.001;
    > = {0.0};
    float fGrainMotion <
        string UIName="Grain: Motion";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.2;  float UIStep=0.001;
    > = {0.2};

///LETTERBOX	
	
int Letterbox <string UIName="------------------------LETTERBOX";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
    bool ENABLE_LETTERBOX <
        string UIName = "Enable Letterbox Bars";
    > = {false};
    float fLetterboxBarHeight <
        string UIName="Letterbox: Height in %";   string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.5;  float UIStep=0.001;
    > = {0.12};

///DITHER

int Dither <string UIName="----------------------------DITHER";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};	
bool ENABLE_DITHER <
        string UIName = "Enable Dither";
    > = {false};

    bool VISUALIZE_PATTERN <
        string UIName = "Visualize Dither Pattern";
    > = {false};
    int DITHER_METHOD <
        string UIName="Dither: Choose Method";   string UIWidget="Spinner";  int UIMin=1;  int UIMax=3;
    > = {3};	
	
	
//////  RESHADE EFFECTS GUI START HERE  ////////////// I use the original float names from ReShade 1.1 as seen in you files

///COLORTUNINGPALETTE
int LUT <string UIName="----------------------------LUT";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};	
float ELUTAmount 		< string UIName="TuningColorLUTIntensity"; string UIWidget="Spinner";float UIMin=0.0;float UIMax=1.000; float UIStep=0.01;> = {0.80};   

///HDR
int HDR <string UIName="----------------------------HDR";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};	
float HDRPower 		< string UIName="HDRPower"; string UIWidget="Spinner";float UIMin=0.0;float UIMax=8.00; float UIStep=0.01;> = {1.20};   
float radius2 		< string UIName="radius"; string UIWidget="Spinner";float UIMin=0.0;float UIMax=8.00; float UIStep=0.01;> = {0.85};   

///TECHNICOLOR
int TECHNICOLOR <string UIName="---------------------TECHNICOLOR";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};	
float Technicolor2_Red_Strength 		< string UIName="Technicolor2_Red_Strength"; string UIWidget="Spinner";float UIMin=0.05;float UIMax=1.00; float UIStep=0.01;> = {0.30};   
float Technicolor2_Green_Strength 		< string UIName="Technicolor2_Green_Strength"; string UIWidget="Spinner";float UIMin=0.05;float UIMax=1.00; float UIStep=0.01;> = {0.44};   
float Technicolor2_Blue_Strength 		< string UIName="Technicolor2_Blue_Strength"; string UIWidget="Spinner";float UIMin=0.05;float UIMax=1.00; float UIStep=0.01;> = {0.39};   
float Technicolor2_Brightness 			< string UIName="Technicolor2_Brightness"; string UIWidget="Spinner";float UIMin=0.5;float UIMax=1.5; float UIStep=0.01;> = {1.50};   
float Technicolor2_Strength 			< string UIName="Technicolor2_Strength"; string UIWidget="Spinner";float UIMin=0.0;float UIMax=1.00; float UIStep=0.01;> = {0.75};   
float Technicolor2_Saturation 			< string UIName="Technicolor2_Saturation"; string UIWidget="Spinner";float UIMin=0.0;float UIMax=1.50; float UIStep=0.01;> = {0.67};   

///DPX
int DPX <string UIName="-----------------------DPX CINEON";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};	
float Red 				< string UIName="Red"; string UIWidget="Spinner";float UIMin=1.0;float UIMax=15.00; float UIStep=0.01;> = {10.0};   
float Green 			< string UIName="Green"; string UIWidget="Spinner";float UIMin=1.0;float UIMax=15.00; float UIStep=0.01;> = {10.0};   
float Blue 				< string UIName="Blue"; string UIWidget="Spinner";float UIMin=1.0;float UIMax=15.00; float UIStep=0.01;> = {10.0};   
float ColorGamma 		< string UIName="ColorGamma"; string UIWidget="Spinner";float UIMin=0.1;float UIMax=2.5; float UIStep=0.01;> = {2.5};   
float DPXSaturation 	< string UIName="DPXSaturation"; string UIWidget="Spinner";float UIMin=0.0;float UIMax=8.00; float UIStep=0.01;> = {2.60};   
float RedC 				< string UIName="RedC"; string UIWidget="Spinner";float UIMin=0.20;float UIMax=0.60; float UIStep=0.01;> = {0.55};   
float GreenC 			< string UIName="GreenC"; string UIWidget="Spinner";float UIMin=0.20;float UIMax=0.60; float UIStep=0.01;> = {0.52};   
float BlueC 			< string UIName="BlueC"; string UIWidget="Spinner";float UIMin=0.20;float UIMax=0.60; float UIStep=0.01;> = {0.55};   
float Blend 			< string UIName="Blend"; string UIWidget="Spinner";float UIMin=0.0;float UIMax=1.0; float UIStep=0.01;> = {0.15};   

///LIFTGAMMAGAIN
int LGG <string UIName="---LIFTGAMMAGAIN: X:Red Y:Green Z:Blue";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};	
float3 RGB_Lift 		< string UIName="RGB_Lift"; string UIWidget="Spinner";float UIMin=0.0;float UIMax=2.0; float UIStep=0.001;> = {1.010, 1.005, 1.000};   
float3 RGB_Gamma 		< string UIName="RGB_Gamma"; string UIWidget="Spinner";float UIMin=0.0;float UIMax=2.0; float UIStep=0.001;> = {1.030, 1.025, 1.020};   
float3 RGB_Gain 		< string UIName="RGB_Gain"; string UIWidget="Spinner";float UIMin=0.0;float UIMax=2.0; float UIStep=0.001;> = {1.020, 1.015, 1.010};   

///CURVES
int CURVES <string UIName="-----------------------CURVES";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};	
float Curves_contrast 	< string UIName="Curves_contrast"; string UIWidget="Spinner";float UIMin=-1.0;float UIMax=1.00; float UIStep=0.01;> = {0.30};   
	
///REINHARD
int REINHARD <string UIName="-----------------------REINHARD";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};	
float ReinhardLinearSlope 			< string UIName="ReinhardLinearSlope"; string UIWidget="Spinner";float UIMin=1.0;float UIMax=5.00; float UIStep=0.01;> = {1.05};   
float ReinhardLinearWhitepoint 		< string UIName="ReinhardLinearWhitepoint"; string UIWidget="Spinner";float UIMin=-100.0;float UIMax=100.00; float UIStep=0.01;> = {1.10};   
float ReinhardLinearPoint 			< string UIName="ReinhardLinearPoint"; string UIWidget="Spinner";float UIMin=-100.0;float UIMax=100.00; float UIStep=0.001;> = {0.001};   

///SMAA
int empty_SMAA <string UIName="----------------------------SMAA";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// EXTERNAL PARAMETERS BEGINS HERE, SHOULD NOT BE MODIFIED UNLESS YOU KNOW WHAT YOU ARE DOING
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/// This is where you define constant variables for your preset. Most of them are from Boris and are used from the binaries to read game's datas:

float4 Timer;            /// x = generic timer in range 0..1, period of 16777216 ms (4.6 hours), y = average fps, w = frame time elapsed (in seconds)
float4 ScreenSize;       /// x = Width, y = 1/Width, z = aspect, w = 1/aspect, aspect is Width/Height
float4 Weather;          /// x = current weather index, y = outgoing weather index, z = weather transition, w = time of the day in 24 standart hours. Weather index is value from weather ini file, for example WEATHER002 means index==2, but index==0 means that weather not captured.
float4 TimeOfDay1;       /// x = dawn, y = sunrise, z = day, w = sunset. Interpolators range from 0..1
float4 TimeOfDay2;       /// x = dusk, y = night. Interpolators range from 0..1
float  ENightDayFactor;  /// Changes in range 0..1, 0 means that night time, 1 - day time
float  EInteriorFactor;  /// Changes 0 or 1. 0 means that exterior, 1 - interior

// External ENB debugging paramaters
float4 tempF1;     /// 0,1,2,3  // Keyboard controlled temporary variables.
float4 tempF2;     /// 5,6,7,8  // Press and hold key 1,2,3...8 together with PageUp or PageDown to modify.
float4 tempF3;     /// 9,0
float4 tempInfo1;  /// xy = cursor position in range 0..1 of screen, z = is shader editor window active, w = mouse buttons with values 0..7
/// tempInfo1 assigned mouse button values
///    0 = none
///    1 = left
///    2 = right
///    3 = left+right
///    4 = middle
///    5 = left+middle
///    6 = right+middle
///    7 = left+right+middle (or rather cat is sitting on your mouse)
float4 tempInfo2;
/// xy = cursor position of previous left mouse button click
/// zw = cursor position of previous right mouse button click


// TEXTURES
/// Textures are basically "what visual the code will use as input or output"
Texture2D TextureOriginal;  /// LDR color /// This is the original colors straight from the game
Texture2D TextureColor;     /// LDR color which is output of previous technique /// this is the colors that has been altered in the previous shader in the load order
Texture2D TextureDepth;     /// scene depth /// this is a special texture for Depth only, used by DOF. There is other texture like TextureBloom etc

/// I tell the binaries that I use a texture for the LUT and that texture is a file located in in a particular place:
//Texture2D TextureLUT	 <string ResourceName = "Textures/Firelut.png";>;  

/// Temporary textures which can be set as render target for techniques via annotations like <string RenderTarget="RenderTargetRGBA32";>
Texture2D RenderTargetRGBA32;   /// R8G8B8A8 32 bit ldr format
Texture2D RenderTargetRGBA64;   /// R16B16G16A16 64 bit ldr format
Texture2D RenderTargetRGBA64F;  /// R16B16G16A16F 64 bit hdr format
Texture2D RenderTargetR16F;     /// R16F 16 bit hdr format with red channel only
Texture2D RenderTargetR32F;     /// R32F 32 bit hdr format with red channel only
Texture2D RenderTargetRGB32F;   /// 32 bit hdr format without alpha


// SAMPLERS
/// Samplers are like some sort of separated canals with different properties where you can load and use textures in different ways
SamplerState Sampler0
{
  Filter=MIN_MAG_MIP_POINT;  AddressU=Clamp;  AddressV=Clamp;  /// MIN_MAG_MIP_LINEAR;
};
SamplerState Sampler1
{
  Filter=MIN_MAG_MIP_LINEAR;  AddressU=Clamp;  AddressV=Clamp;
};

/// I tell the binaries I make a new canal (because I need it to load specifically the LUT texture later) :

SamplerState SamplerLut
{
   Filter=MIN_MAG_MIP_LINEAR;  AddressU=Clamp;  AddressV=Clamp;
};

// DATA STRUCTURE
// This is voodoo to tell the binaries how to read the informations of the functions (I think)
struct VS_INPUT_POST
{
  float3 pos     : POSITION;
  float2 txcoord : TEXCOORD0;
};
struct VS_OUTPUT_POST
{
  float4 pos      : SV_POSITION;
  float2 txcoord0 : TEXCOORD0;
};


// HELPER FUNCTIONS
/// This is where you define the functions of the shaders and their code.
/// Include the additional shader files containing all helper functions and constants
   #include "/Modular Shaders/msHelpers.fxh"
   #include "enbsmaa.fx" 

float4 enbBlur(float4 inColor, float2 inCoord)
{
if (ENABLE_BLURRING==false) return float4(TextureColor.Sample(Sampler0, inCoord.xy));

  float4 color;
  float4 centercolor;
  float2 pixeloffset = ScreenSize.y;
  pixeloffset.y     *= ScreenSize.z;

    centercolor = TextureColor.Sample(Sampler0, inCoord.xy);
    color       = 0.0;
    float2 offsets[4]=
    {
      float2(-1.0,-1.0),
      float2(-1.0, 1.0),
      float2( 1.0,-1.0),
      float2( 1.0, 1.0),
    };
    for (int i=0; i<4; i++)
    {
      float2 coord = offsets[i].xy * pixeloffset.xy * EBlurRange + inCoord.xy;
      color.xyz += TextureColor.Sample(Sampler1, coord.xy);
    }
    color.xyz += centercolor.xyz;
    color.xyz *= 0.2;

    inColor.xyz = lerp(centercolor.xyz, color.xyz, EBlurAmount);

  return inColor;
}

float4 enbSharpen(float4 inColor, float2 inCoord)
{
if (ENABLE_SHARPENING==false) return float4(TextureColor.Sample(Sampler0, inCoord.xy));

  float4 color;
  float4 centercolor;
  float2 pixeloffset = ScreenSize.y;
  pixeloffset.y     *= ScreenSize.z;

/// Simple depth implementation
  float Depth = TextureDepth.Sample(Sampler0, inCoord.xy ).x;
  float linDepthFromS = linearDepth(Depth, 0.5f, fSharpFDepth);

    centercolor = TextureColor.Sample(Sampler0, inCoord.xy);
    color       = 0.0;
    float2 offsets[4]=
    {
      float2(-1.0,-1.0),
      float2(-1.0, 1.0),
      float2( 1.0,-1.0),
      float2( 1.0, 1.0),
    };
    for (int i=0; i<4; i++)
    {
      float2 coord = offsets[i].xy * pixeloffset.xy * ESharpRange + inCoord.xy;
      color.xyz   += TextureColor.Sample(Sampler1, coord.xy);
    }
    color.xyz *= 0.25;

    float diffgray = dot((centercolor.xyz - color.xyz), 0.3333);

/// Apply depth based sharpening
    if (ENABLE_DEPTHSHARP==true)  diffgray = diffgray * (1.0f - linDepthFromS);

/// Simply does not blend the pre-sharpening scene with the post-sharpening scene together,
/// not true conversion to and from and Luma sharpening.
	if (ENABLE_LUMA==false) {
		inColor.xyz = ESharpAmount * centercolor.xyz * diffgray + centercolor.xyz;
	} else {
        inColor.xyz = ESharpAmount * diffgray + centercolor.xyz;
    }

	if (VISUALIZE_SHARP==true && ENABLE_LUMA==false) {
		inColor.rgb = ESharpAmount * centercolor.xyz * diffgray;
	} else if (VISUALIZE_SHARP==true && ENABLE_LUMA==true) {
        inColor.rgb = ESharpAmount * diffgray;
    }

  return inColor;
}

float4 msVignette(float4 inColor, float2 inTexCoords)
{
  if (ENABLE_VIGNETTE==true)
  {
    float3 origcolor = inColor;

      float2 uv      = (inTexCoords.xy - 0.5f) * EVignetteRadius;
      float vignette = saturate(dot(uv.xy, uv.xy));
      vignette       = pow(vignette, EVignetteCurve);
      inColor.xyz    = lerp(origcolor.xyz, EVignetteColor, vignette * EVignetteAmount);
  }

  return inColor;
}

float3 msGrain(float3 inColor, float2 inTexCoords)
{
  if (ENABLE_GRAIN==true)
  {
    float  GrainTimerSeed    = Timer.x * fGrainMotion;
    float2 GrainTexCoordSeed = inTexCoords.xy * 1.0f;

    float2 GrainSeed1  = GrainTexCoordSeed + float2( 0.0f, GrainTimerSeed );
    float2 GrainSeed2  = GrainTexCoordSeed + float2( GrainTimerSeed, 0.0f );
    float2 GrainSeed3  = GrainTexCoordSeed + float2( GrainTimerSeed, GrainTimerSeed );
    float  GrainNoise1 = random( GrainSeed1 );
    float  GrainNoise2 = random( GrainSeed2 );
    float  GrainNoise3 = random( GrainSeed3 );
    float  GrainNoise4 = ( GrainNoise1 + GrainNoise2 + GrainNoise3 ) * 0.333333333f;
    float3 GrainNoise  = float3( GrainNoise4, GrainNoise4, GrainNoise4 );
    float3 GrainColor  = float3( GrainNoise1, GrainNoise2, GrainNoise3 );

    inColor += ( lerp( GrainNoise, GrainColor, fGrainSaturation ) * fGrainIntensity ) - ( fGrainIntensity * 0.5f);

	if (VISUALIZE_GRAIN==true) inColor.rgb = (lerp(GrainNoise, GrainColor, fGrainSaturation) * fGrainIntensity) - (fGrainIntensity * 0.5f);
  }

  return inColor;
}

float4 msLetterbox(float4 inColor, float2 inTexCoords)
{
  if (ENABLE_LETTERBOX==true)
  {
    if (inTexCoords.y > 1.0f - fLetterboxBarHeight || inTexCoords.y  < fLetterboxBarHeight) inColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
  }

  return inColor;
}

//////////////////////// RESHADE FUNCTIONS //////////////////////////////////////////////////////

//-----------------------LEVELS------------------------//
// by Christian Cann Schuldt Jensen ~ CeeJay.dk        //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//

   #define black_point_float ( Levels_black_point / 255.0 )

#if (Levels_white_point == Levels_black_point) //avoid division by zero if the white and black point are the same
  #define white_point_float ( 255.0 / 0.00025)
#else
  #define white_point_float ( 255.0 / (Levels_white_point - Levels_black_point))
#endif

float4 LevelsPass( float4 colorInput )
{
  colorInput.rgb = colorInput.rgb * white_point_float - (black_point_float *  white_point_float);

  #if (Levels_highlight_clipping == 1)

    float3 clipped_colors = any(colorInput.rgb > saturate(colorInput.rgb)) //any colors whiter than white?
                    ? float3(1.0, 0.0, 0.0)
                    : colorInput.rgb;
                    
    clipped_colors = all(colorInput.rgb > saturate(colorInput.rgb)) //all colors whiter than white?
                    ? float3(1.0, 1.0, 0.0)
                    : clipped_colors;
                    
    clipped_colors = any(colorInput.rgb < saturate(colorInput.rgb)) //any colors blacker than black?
                    ? float3(0.0, 0.0, 1.0)
                    : clipped_colors;
                    
    clipped_colors = all(colorInput.rgb < saturate(colorInput.rgb)) //all colors blacker than black?
                    ? float3(0.0, 1.0, 1.0)
                    : clipped_colors;                    
                    
    colorInput.rgb = clipped_colors;
    
  #endif

  return colorInput;
}

//-----------------------CURVES------------------------//
// by Christian Cann Schuldt Jensen ~ CeeJay.dk        //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//

   float4 CurvesPass( float4 colorInput )
{
  float3 lumCoeff = float3(0.2126, 0.7152, 0.0722);  //Values to calculate luma with
  float Curves_contrast_blend = Curves_contrast;
  
  #ifndef PI
    #define PI 3.1415927
  #endif

   /*-----------------------------------------------------------.
  /               Separation of Luma and Chroma                 /
  '-----------------------------------------------------------*/

  // -- Calculate Luma and Chroma if needed --
  #if Curves_mode != 2

    //calculate luma (grey)
    float luma = dot(lumCoeff, colorInput.rgb);

    //calculate chroma
	  float3 chroma = colorInput.rgb - luma;
  #endif

  // -- Which value to put through the contrast formula? --
  // I name it x because makes it easier to copy-paste to Graphtoy or Wolfram Alpha or another graphing program
  #if Curves_mode == 2
	  float3 x = colorInput.rgb; //if the curve should be applied to both Luma and Chroma
	#elif Curves_mode == 1
	  float3 x = chroma; //if the curve should be applied to Chroma
	  x = x * 0.5 + 0.5; //adjust range of Chroma from -1 -> 1 to 0 -> 1
  #else // Curves_mode == 0
    float x = luma; //if the curve should be applied to Luma
  #endif

   /*-----------------------------------------------------------.
  /                     Contrast formulas                       /
  '-----------------------------------------------------------*/

  // -- Curve 1 --
  #if Curves_formula == 1
    x = sin(PI * 0.5 * x); // Sin - 721 amd fps, +vign 536 nv
    x *= x;
    
    //x = 0.5 - 0.5*cos(PI*x);
    //x = 0.5 * -sin(PI * -x + (PI*0.5)) + 0.5;
  #endif

  // -- Curve 2 --
  #if Curves_formula == 2
    x = x - 0.5;  
    x = ( x / (0.5 + abs(x)) ) + 0.5;
    
    //x = ( (x - 0.5) / (0.5 + abs(x-0.5)) ) + 0.5;
  #endif

  // -- Curve 3 --
  #if Curves_formula == 3
    //x = smoothstep(0.0,1.0,x); //smoothstep
    x = x*x*(3.0-2.0*x); //faster smoothstep alternative - 776 amd fps, +vign 536 nv
    //x = x - 2.0 * (x - 1.0) * x* (x- 0.5);  //2.0 is contrast. Range is 0.0 to 2.0
  #endif

  // -- Curve 4 --
  #if Curves_formula == 4
    x = (1.0524 * exp(6.0 * x) - 1.05248) / (exp(6.0 * x) + 20.0855); //exp formula
  #endif

  // -- Curve 5 --
  #if Curves_formula == 5
    //x = 0.5 * (x + 3.0 * x * x - 2.0 * x * x * x); //a simplified catmull-rom (0,0,1,1) - btw smoothstep can also be expressed as a simplified catmull-rom using (1,0,1,0)
    //x = (0.5 * x) + (1.5 -x) * x*x; //estrin form - faster version
    x = x * (x * (1.5-x) + 0.5); //horner form - fastest version

    Curves_contrast_blend = Curves_contrast * 2.0; //I multiply by two to give it a strength closer to the other curves.
  #endif

 	// -- Curve 6 --
  #if Curves_formula == 6
    x = x*x*x*(x*(x*6.0 - 15.0) + 10.0); //Perlins smootherstep
	#endif

	// -- Curve 7 --
  #if Curves_formula == 7
    //x = ((x-0.5) / ((0.5/(4.0/3.0)) + abs((x-0.5)*1.25))) + 0.5;
	x = x - 0.5;
	x = x / ((abs(x)*1.25) + 0.375 ) + 0.5;
	//x = ( (x-0.5) / ((abs(x-0.5)*1.25) + (0.5/(4.0/3.0))) ) + 0.5;
  #endif

  // -- Curve 8 --
  #if Curves_formula == 8
    x = (x * (x * (x * (x * (x * (x * (1.6 * x - 7.2) + 10.8) - 4.2) - 3.6) + 2.7) - 1.8) + 2.7) * x * x; //Techicolor Cinestyle - almost identical to curve 1
  #endif

  // -- Curve 9 --
  #if Curves_formula == 9
    x =  -0.5 * (x*2.0-1.0) * (abs(x*2.0-1.0)-2.0) + 0.5; //parabola
  #endif

  // -- Curve 10 --
  #if Curves_formula == 10 //Half-circles

    #if Curves_mode == 0

			float xstep = step(x,0.5); //tenary might be faster here
			float xstep_shift = (xstep - 0.5);

			/*
			float xstep = (x < 0.5) ? 1.0 : 0.0; //tenary version
			float xstep_shift = (x < 0.5) ? 0.5 : -0.5;
			*/

			float shifted_x = x + xstep_shift;
	  
	  
    #else
			float3 xstep = step(x,0.5);
			float3 xstep_shift = (xstep - 0.5);
	  
			/*
			float3 xstep = float3(0.0,0.0,0.0);
			xstep.r = (x.r < 0.5) ? 1.0 : 0.0;
			xstep.g = (x.g < 0.5) ? 1.0 : 0.0;
			xstep.b = (x.b < 0.5) ? 1.0 : 0.0;
			float3 xstep_shift = float3(0.0,0.0,0.0);
			xstep_shift.r = (x.r < 0.5) ? 0.5 : -0.5;
			xstep_shift.g = (x.g < 0.5) ? 0.5 : -0.5;
			xstep_shift.b = (x.b < 0.5) ? 0.5 : -0.5;
			*/

			float3 shifted_x = x + xstep_shift;
    #endif

	x = abs(xstep - sqrt(-shifted_x * shifted_x + shifted_x) ) - xstep_shift;

  //x = abs(step(x,0.5)-sqrt(-(x+step(x,0.5)-0.5)*(x+step(x,0.5)-0.5)+(x+step(x,0.5)-0.5)))-(step(x,0.5)-0.5); //single line version of the above
    
  //x = 0.5 + (sign(x-0.5)) * sqrt(0.25-(x-trunc(x*2))*(x-trunc(x*2))); //worse
  
  /* // if/else - even worse
  if (x-0.5)
  x = 0.5-sqrt(0.25-x*x);
  else
  x = 0.5+sqrt(0.25-(x-1)*(x-1));
	*/

  //x = (abs(step(0.5,x)-clamp( 1-sqrt(1-abs(step(0.5,x)- frac(x*2%1)) * abs(step(0.5,x)- frac(x*2%1))),0 ,1))+ step(0.5,x) )*0.5; //worst so far
	
	//TODO: Check if I could use an abs split instead of step. It might be more efficient
	
	Curves_contrast_blend = Curves_contrast * 0.5; //I divide by two to give it a strength closer to the other curves.
  #endif
  
    // -- Curve 11 --
  #if Curves_formula == 11 //
  	#if Curves_mode == 0
			float a = 0.0;
			float b = 0.0;
		#else
			float3 a = float3(0.0,0.0,0.0);
			float3 b = float3(0.0,0.0,0.0);
		#endif

    a = x * x * 2.0;
    b = (2.0 * -x + 4.0) * x - 1.0;
    x = (x < 0.5) ? a : b;
  #endif


  // -- Curve 21 --
  #if Curves_formula == 21 //Cubic catmull
    float a = 1.00; //control point 1
    float b = 0.00; //start point
    float c = 1.00; //endpoint
    float d = 0.20; //control point 2
    x = 0.5 * ((-a + 3*b -3*c + d)*x*x*x + (2*a -5*b + 4*c - d)*x*x + (-a+c)*x + 2*b); //A customizable cubic catmull-rom spline
  #endif

  // -- Curve 22 --
  #if Curves_formula == 22 //Cubic Bezier spline
    float a = 0.00; //start point
    float b = 0.00; //control point 1
    float c = 1.00; //control point 2
    float d = 1.00; //endpoint

    float r  = (1-x);
	float r2 = r*r;
	float r3 = r2 * r;
	float x2 = x*x;
	float x3 = x2*x;
	//x = dot(float4(a,b,c,d),float4(r3,3*r2*x,3*r*x2,x3));

	//x = a * r*r*r + r * (3 * b * r * x + 3 * c * x*x) + d * x*x*x;
	//x = a*(1-x)*(1-x)*(1-x) +(1-x) * (3*b * (1-x) * x + 3 * c * x*x) + d * x*x*x;
	x = a*(1-x)*(1-x)*(1-x) + 3*b*(1-x)*(1-x)*x + 3*c*(1-x)*x*x + d*x*x*x;
  #endif

  // -- Curve 23 --
  #if Curves_formula == 23 //Cubic Bezier spline - alternative implementation.
    float3 a = float3(0.00,0.00,0.00); //start point
    float3 b = float3(0.25,0.15,0.85); //control point 1
    float3 c = float3(0.75,0.85,0.15); //control point 2
    float3 d = float3(1.00,1.00,1.00); //endpoint

    float3 ab = lerp(a,b,x);           // point between a and b
    float3 bc = lerp(b,c,x);           // point between b and c
    float3 cd = lerp(c,d,x);           // point between c and d
    float3 abbc = lerp(ab,bc,x);       // point between ab and bc
    float3 bccd = lerp(bc,cd,x);       // point between bc and cd
    float3 dest = lerp(abbc,bccd,x);   // point on the bezier-curve
    x = dest;
  #endif

  // -- Curve 24 --
  #if Curves_formula == 24
    x = 1.0 / (1.0 + exp(-(x * 10.0 - 5.0))); //alternative exp formula
  #endif

   /*-----------------------------------------------------------.
  /                 Joining of Luma and Chroma                  /
  '-----------------------------------------------------------*/

  #if Curves_mode == 2 //Both Luma and Chroma
	float3 color = x;  //if the curve should be applied to both Luma and Chroma
	colorInput.rgb = lerp(colorInput.rgb, color, Curves_contrast_blend); //Blend by Curves_contrast

  #elif Curves_mode == 1 //Only Chroma
	x = x * 2.0 - 1.0; //adjust the Chroma range back to -1 -> 1
	float3 color = luma + x; //Luma + Chroma
	colorInput.rgb = lerp(colorInput.rgb, color, Curves_contrast_blend); //Blend by Curves_contrast

  #else // Curves_mode == 0 //Only Luma
    x = lerp(luma, x, Curves_contrast_blend); //Blend by Curves_contrast
    colorInput.rgb = x + chroma; //Luma + Chroma

  #endif

  //Return the result
  return colorInput;
}

//--------------------------HDR------------------------//
// by Christian Cann Schuldt Jensen ~ CeeJay.dk        //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//

   float4 HDRPass( float4 colorInput, float2 Tex )
{
	
	float3 c_center = TextureColor.Sample(Sampler0, Tex).rgb; //reuse SMAA center sample or lumasharpen center sample?
	//float3 c_center = colorInput.rgb; //or just the input?
	
	//float3 bloom_sum1 = float3(0.0, 0.0, 0.0); //don't initialize to 0 - use the first tex2D to do that
	//float3 bloom_sum2 = float3(0.0, 0.0, 0.0); //don't initialize to 0 - use the first tex2D to do that
	//Tex += float2(0, 0); // +0 ? .. oh riiiight - that will surely do something useful
	
	float radius1 = 0.793;
	float3 bloom_sum1 = TextureColor.Sample(Sampler0, Tex + float2(1.5, -1.5) * radius1).rgb;
	bloom_sum1 += TextureColor.Sample(Sampler0, Tex + float2(-1.5, -1.5) * radius1).rgb; //rearrange sample order to minimize ALU and maximize cache usage
	bloom_sum1 += TextureColor.Sample(Sampler0, Tex + float2(1.5, 1.5) * radius1).rgb;
	bloom_sum1 += TextureColor.Sample(Sampler0, Tex + float2(-1.5, 1.5) * radius1).rgb;
	
	bloom_sum1 += TextureColor.Sample(Sampler0, Tex + float2(0, -2.5) * radius1).rgb;
	bloom_sum1 += TextureColor.Sample(Sampler0, Tex + float2(0, 2.5) * radius1).rgb;
	bloom_sum1 += TextureColor.Sample(Sampler0, Tex + float2(-2.5, 0) * radius1).rgb;
	bloom_sum1 += TextureColor.Sample(Sampler0, Tex + float2(2.5, 0) * radius1).rgb;
	
	bloom_sum1 *= 0.005;
	
	float3 bloom_sum2 = TextureColor.Sample(Sampler0, Tex + float2(1.5, -1.5) * radius2).rgb;
	bloom_sum2 += TextureColor.Sample(Sampler0, Tex + float2(-1.5, -1.5) * radius2).rgb;
	bloom_sum2 += TextureColor.Sample(Sampler0, Tex + float2(1.5, 1.5) * radius2).rgb;
	bloom_sum2 += TextureColor.Sample(Sampler0, Tex + float2(-1.5, 1.5) * radius2).rgb;


	bloom_sum2 += TextureColor.Sample(Sampler0, Tex + float2(0, -2.5) * radius2).rgb;	
	bloom_sum2 += TextureColor.Sample(Sampler0, Tex + float2(0, 2.5) * radius2).rgb;
	bloom_sum2 += TextureColor.Sample(Sampler0, Tex + float2(-2.5, 0) * radius2).rgb;
	bloom_sum2 += TextureColor.Sample(Sampler0, Tex + float2(2.5, 0) * radius2).rgb;

	bloom_sum2 *= 0.010;
	
	float dist = radius2 - radius1;
	
	float3 HDR = (c_center + (bloom_sum2 - bloom_sum1)) * dist;
	float3 blend = HDR + colorInput.rgb;
	colorInput.rgb = pow(abs(blend), abs(HDRPower)) + HDR; // pow - don't use fractions for HDRpower
	
	return saturate(colorInput);
	
}

//-----------------------DITHER------------------------//
// JawZ: Author and developer of this file             //
// CeeJay.dk: Author of Dither code                    //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//

float3 msDither(float3 inColor, float2 inTexCoords)
{
    float  dither_bit = 8.0;  //Number of bits per channel. Should be 8 for most monitors.

  /// Ordered Dithering
    if (DITHER_METHOD==1)
    {
    //Calculate grid position
      float grid_position = frac(dot(inTexCoords, (ScreenSize.x * float2(1.0/16.0,10.0/36.0))) + 0.25 );

    //Calculate how big the shift should be
      float dither_shift = (0.25) * (1.0 / (pow(2, dither_bit) - 1.0));

    //Shift the individual colors differently, thus making it even harder to see the dithering pattern
      float3 dither_shift_RGB = float3(dither_shift, -dither_shift, dither_shift);  // Subpixel dithering

    //modify shift acording to grid position.
      dither_shift_RGB = lerp(2.0 * dither_shift_RGB, -2.0 * dither_shift_RGB, grid_position);  // Shift acording to grid position.

    //shift the color by dither_shift
      inColor.rgb += dither_shift_RGB;

    //Debugging features
      if (VISUALIZE_PATTERN==true)
      {
        inColor.rgb = (dither_shift_RGB * 2.0 * (pow(2,dither_bit) - 1.0) ) + 0.5;  // Visualize the RGB shift
        inColor.rgb = grid_position;  // Visualize the grid
      }
    }

  /// Random Dithering
    else if (DITHER_METHOD==2)
    {
    //Pseudo Random Number Generator
      // -- PRNG 1 - Reference --
      float seed = dot(inTexCoords, float2(12.9898,78.233));  // I could add more salt here if I wanted to
      float sine = sin(seed);                                 // cos also works well. Sincos too if you want 2D noise.
      float noise = frac(sine * 43758.5453 + inTexCoords.x);  // inTexCoords.x is just some additional salt - it can be taken out.

    //Calculate how big the shift should be
      float dither_shift = (1.0 / (pow(2,dither_bit) - 1.0));  // Using noise to determine shift. Will be 1/255 if set to 8-bit.
      float dither_shift_half = (dither_shift * 0.5);          // The noise should vary between +- 0.5
      dither_shift = dither_shift * noise - dither_shift_half; // MAD

    //shift the color by dither_shift
      inColor.rgb += float3(-dither_shift, dither_shift, -dither_shift);  // Subpixel dithering

    //Debugging features
      if (VISUALIZE_PATTERN==true)   inColor.rgb = noise;  // Visualize the noise
    }

  /// New Dithering
    else if (DITHER_METHOD==3)
    {
    //Calculate grid position
      float grid_position = frac(dot(inTexCoords,(ScreenSize.x) * float2(0.75, 0.5) + (0.00025)));  // (0.6,0.8) is good too - TODO : experiment with values

    //Calculate how big the shift should be
      float dither_shift = (0.25) * (1.0 / (pow(2,dither_bit) - 1.0));              // 0.25 seems good both when using math and when eyeballing it. So does 0.75 btw.
      dither_shift = lerp(2.0 * dither_shift, -2.0 * dither_shift, grid_position);  // Shift according to grid position.

    //shift the color by dither_shift
      inColor.rgb += float3(dither_shift, -dither_shift, dither_shift);  // Subpixel dithering

    //Debugging features
      if (VISUALIZE_PATTERN==true) inColor.rgb = grid_position;  // Visualize the grid
    }

  return inColor;
}

//-----------------------LUT-------------------------//

float3 LUTfunc(float3 inColor)
{
    float4 ColorLUTDst = float4((inColor.rg*float(TuningColorLUTTileAmountY-1)+0.5f)*TuningColorLUTNorm,inColor.b*float(TuningColorLUTTileAmountY-1),1);
    ColorLUTDst.x += trunc(ColorLUTDst.z)*TuningColorLUTNorm.y;
	ColorLUTDst = lerp(
      TextureLUT.SampleLevel(SamplerLut, ColorLUTDst.xy, 0),
      TextureLUT.SampleLevel(SamplerLut, float2(ColorLUTDst.x+TuningColorLUTNorm.y,ColorLUTDst.y), 0),frac(ColorLUTDst.z));
	  
	return lerp(inColor.xyz, ColorLUTDst.xyz, ELUTAmount);
}
	
//----------------LiftGammaGAIN------------------------//
//             by 3an and CeeJay.dk                    //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//	

float4 LiftGammaGainPass( float4 colorInput )
{
	// -- Get input --
	float3 color = colorInput.rgb;
	
	// -- Lift --
	//color = color + (RGB_Lift / 2.0 - 0.5) * (1.0 - color); 
	color = color * (1.5-0.5 * RGB_Lift) + 0.5 * RGB_Lift - 0.5;
	color = saturate(color); //isn't strictly necessary, but doesn't cost performance.
	
	// -- Gain --
	color *= RGB_Gain; 
	
	// -- Gamma --
	colorInput.rgb = pow(color, 1.0 / RGB_Gamma); //Gamma
	
	// -- Return output --
	//return (colorInput);
	return saturate(colorInput);
}	

//----------------ReinhardLinear------------------------//
//             by Ubisoft and Gilcher Pascal           //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//

float4 ReinhardLinearToneMapping(float4 colorInput)
{
	float3 x = colorInput.rgb;

    	const float W = ReinhardLinearWhitepoint;	        // Linear White Point Value
    	const float L = ReinhardLinearPoint;           // Linear point
    	const float C = ReinhardLinearSlope;           // Slope of the linear section
    	const float K = (1 - L * C) / C; // Scale (fixed so that the derivatives of the Reinhard and linear functions are the same at x = L)
    	float3 reinhard = L * C + (1 - L * C) * (1 + K * (x - L) / ((W - L) * (W - L))) * (x - L) / (x - L + K);

    	// gamma space or not?
    	colorInput.rgb = (x > L) ? reinhard : C * x;
	return colorInput;
}
	
//----------------Technicolor2------------------------//
//                  by Prod80                         //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
	
float4 Technicolor2(float4 colorInput)
{
	float3 Color_Strength = float3(Technicolor2_Red_Strength,Technicolor2_Green_Strength,Technicolor2_Blue_Strength);
	float3 source = saturate(colorInput.rgb);
	float3 temp = 1.0 - source;
	float3 target = temp.grg;
	float3 target2 = temp.bbr;
	float3 temp2 = source.rgb * target.rgb;
	temp2.rgb *= target2.rgb;

	temp.rgb = temp2.rgb * Color_Strength;
	temp2.rgb *= Technicolor2_Brightness;

	target.rgb = temp.grg;
	target2.rgb = temp.bbr;

	temp.rgb = source.rgb - target.rgb;
	temp.rgb += temp2.rgb;
	temp2.rgb = temp.rgb - target2.rgb;

	colorInput.rgb = lerp(source.rgb, temp2.rgb, Technicolor2_Strength);

	colorInput.rgb = lerp(dot(colorInput.rgb, 0.333), colorInput.rgb, Technicolor2_Saturation); 
	
	return colorInput;
}
	
//-------------------DPX CINEON------------------------//
//             by Loadus and CeeJay.dk                 //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//	

static const float3x3 RGB = float3x3
(
2.67147117265996,-1.26723605786241,-0.410995602172227,
-1.02510702934664,1.98409116241089,0.0439502493584124,
0.0610009456429445,-0.223670750812863,1.15902104167061
);

static const float3x3 XYZ = float3x3
(
0.500303383543316,0.338097573222739,0.164589779545857,
0.257968894274758,0.676195259144706,0.0658358459823868,
0.0234517888692628,0.1126992737203,0.866839673124201
);

float4 DPXPass(float4 InputColor){

	float DPXContrast = 0.1;

	float DPXGamma = 1.0;

	float RedCurve = Red;
	float GreenCurve = Green;
	float BlueCurve = Blue;
	
	float3 RGB_Curve = float3(Red,Green,Blue);
	float3 RGB_C = float3(RedC,GreenC,BlueC);

	float3 B = InputColor.rgb;
	//float3 Bn = B; // I used InputColor.rgb instead.

	B = pow(abs(B), 1.0/DPXGamma);

  B = B * (1.0 - DPXContrast) + (0.5 * DPXContrast);


    //B = (1.0 /(1.0 + exp(- RGB_Curve * (B - RGB_C))) - (1.0 / (1.0 + exp(RGB_Curve / 2.0))))/(1.0 - 2.0 * (1.0 / (1.0 + exp(RGB_Curve / 2.0))));
	
    float3 Btemp = (1.0 / (1.0 + exp(RGB_Curve / 2.0)));	  
	  B = ((1.0 / (1.0 + exp(-RGB_Curve * (B - RGB_C)))) / (-2.0 * Btemp + 1.0)) + (-Btemp / (-2.0 * Btemp + 1.0));


     //TODO use faster code for conversion between RGB/HSV  -  see http://www.chilliant.com/rgb2hsv.html
	   float value = max(max(B.r, B.g), B.b);
	   float3 color = B / value;
	
	   color = pow(abs(color), 1.0/ColorGamma);
	
	   float3 c0 = color * value;

	   c0 = mul(XYZ, c0);

	   float luma = dot(c0, float3(0.30, 0.59, 0.11)); //Use BT 709 instead?

 	   //float3 chroma = c0 - luma;
	   //c0 = chroma * DPXSaturation + luma;
	   c0 = (1.0 - DPXSaturation) * luma + DPXSaturation * c0;
	   
	   c0 = mul(RGB, c0);
	
	InputColor.rgb = lerp(InputColor.rgb, c0, Blend);

	return InputColor;
}	
	
// VERTEX SHADER
/// Another voodoo thing to tell the binaries how to read the pixel shaders (I think)
VS_OUTPUT_POST VS_PostProcess(VS_INPUT_POST IN)
{
  VS_OUTPUT_POST OUT;

    float4 pos;
    pos.xyz = IN.pos.xyz;
    pos.w = 1.0;
    OUT.pos = pos;
    OUT.txcoord0.xy = IN.txcoord.xy;

  return OUT;
}


// PIXEL SHADERS
/// Pixel shaders are the part of the code where you tell the binaries what to do with the functions above mentionned
float4 PS_Blur(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
  float4 res;

    res = enbBlur(res, IN.txcoord0.xy);

  res.w = 1.0;
  return res;
}

float4 PS_Sharp(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
  float4 res;

    res = enbSharpen(res, IN.txcoord0.xy);

  res.w = 1.0;
  return res;
}


/// Post Effects
float4 PS_PostFX(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
  float4 res;

    res     = TextureColor.Sample(Sampler0, IN.txcoord0.xy);
	
    res     = msVignette(res, IN.txcoord0.xy);
    res.rgb = msGrain(res.rgb, IN.txcoord0.xy);
	res 	= LevelsPass(res);
	res 	= Technicolor2(res);
	res 	= DPXPass (res);
	res 	= LiftGammaGainPass (res);
	res 	= CurvesPass(res);
    res 	= ReinhardLinearToneMapping (res);
	
    res.rgb = LUTfunc(saturate(res.rgb));
 	res 	= HDRPass(res,IN.txcoord0.xy);
	res.rgb = msDither(res.rgb,  IN.txcoord0.xy);
    res     = msLetterbox(res, IN.txcoord0.xy);
	
  res.w = 1.0;
  return res;
}



// TECHNIQUES
///+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
/// Techniques are drawn one after another and they use the result of   ///
/// the previous technique as input color to the next one.  The number  ///
/// of techniques is limited to 255.  If UIName is specified, then it   ///
/// is a base technique which may have extra techniques with indexing   ///
///+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///

/// This is where you finally load the pixel shaders and tell the sequence of their order

technique11 BlurSharp <string UIName="NVT-NAT-SMAA ON";>  /// First  Blur Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Blur()));
  }
}

technique11 BlurSharp1  /// Second Blur Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Blur()));
  }
}

technique11 BlurSharp2  /// First Sharpening Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Sharp()));
  }
}

technique11 BlurSharp3 <string RenderTarget= SMAA_STRING(SMAA_EDGE_TEX);>
{
    pass Clear
    {
        SetVertexShader(CompileShader(vs_5_0, VS_SMAAClear()));
        SetPixelShader(CompileShader(ps_5_0, PS_SMAAClear()));
    }

    pass EdgeDetection
    {
        SetVertexShader(CompileShader(vs_5_0, VS_SMAAEdgeDetection()));
        SetPixelShader(CompileShader(ps_5_0, PS_SMAAEdgeDetection()));
    }
}

technique11 BlurSharp4 <string RenderTarget=SMAA_STRING(SMAA_BLEND_TEX);>
{
    pass Clear
    {
        SetVertexShader(CompileShader(vs_5_0, VS_SMAAClear()));
        SetPixelShader(CompileShader(ps_5_0, PS_SMAAClear()));
    }
    
    pass BlendingWeightCalculation
    {
        SetVertexShader(CompileShader(vs_5_0, VS_SMAABlendingWeightCalculation()));
        SetPixelShader(CompileShader(ps_5_0, PS_SMAABlendingWeightCalculation()));
    }
}

technique11 BlurSharp5
{
    pass NeighborhoodBlending
    {
        SetVertexShader(CompileShader(vs_5_0, VS_SMAANeighborhoodBlending()));
        SetPixelShader(CompileShader(ps_5_0, PS_SMAANeighborhoodBlending()));
    }
}

technique11 BlurSharp6  ///  Post effects
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_PostFX()));
  }
}

technique11 NVT <string UIName="NVT-NAT-SMAA OFF";>  /// First  Blur Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Blur()));
  }
}

technique11 NVT1  /// Second Blur Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Blur()));
  }
}

technique11 NVT2  /// First Sharpening Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Sharp()));
  }
}

technique11 NVT3  /// Post effects
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_PostFX()));
  }
}