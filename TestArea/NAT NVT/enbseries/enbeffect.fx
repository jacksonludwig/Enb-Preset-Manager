//********************************************************//
//                ENBSeries effect file                   //
//          visit http://enbdev.com for updates           //
//        Copyright (c) 2007-2016 Boris Vorontsov         //
//-----------------------CREDITS--------------------------//
//     Please do not redistribute without credits         //
//    Boris: For ENBSeries and his knowledge and codes    //
//    Tapioks:  Author and developer of the DNI code      //
// http://www.nexusmods.com/skyrimspecialedition/mods/4481//
// kingeric1992: Initial code of vanilla post processing  //
// phinix: Integration of Night Eye Fix                   //
// L00: Adaptation of AGCC and tweaks for Skyrim SE and   //
//           for Re-Engaged preset by Firemanaf           //
//              and author of this file                   //
// Firemanaf: Adjustment of file structure and tweaks     //
//********************************************************//
////////////////////////////////////////////////////////////
//                Natural View Tamriel-NVT ENB            //
//--------------------------------------------------------//
//            ENB-EFFECT-PROCESSING SHADER SUITE          //
//                                                        //
//               based on DNI-Shader by Tapioks           //
////////////////////////////////////////////////////////////

//Warning! In this version Weather index is not yet implemented

#define ACTIVATE_AGCC   
#ifndef POSTPROCESS
 #define POSTPROCESS	1
#endif

//+++++++++++++++++++++++++++++
//internal parameters, modify or add new
//+++++++++++++++++++++++++++++

// NIGHTS & BRIGHTNESS LEVELS
int             NightsInteriors              < string UIName="----------Nights & Interior Adjustors-----------";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0.0};
float		fNightlevel 			
< 
string UIName="Nights:     .5:Bright 1:Norm 1.5:Dark 2:Darker"; 
string UIWidget="spinner"; 			
float UIMin=0.5;  
float UIMax=2.0;  
float UIStep=0.5;
> = {1.0};

float		fInteriorlevel 			
< 
string UIName="Interiors: .5:Bright 1:Norm 1.5:Dark 2:Darker"; 
string UIWidget="spinner"; 	
float UIMin=0.5;  
float UIMax=2.0;  
float UIStep=0.5;
> = {1.0};



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Khajiit Nighteye Adjustment
int		KNEA 				< string UIName="----------Apply Nighteye Adjustment---------"; string UIWidget="spinner"; int UIMin=0; int UIMax=0;> = {0.0};
bool	KNEnable		<string UIName = "Use Nighteye Fix";>																		= {false};
float	KNDetect1		<string UIName="Params01[5].w > VALUE*0.1";string UIWidget="Spinner";float UIMin=0.0;float UIMax=2.0;>		= {0.9};
float	KNDetect2		<string UIName="Params01[4].y < VALUE";string UIWidget="Spinner";float UIMin=0.0;float UIMax=1.0;>			= {0.8};
float3	KNBalance		<string UIName="Nighteye Balance";string UIWidget="Color";>													= {0.537, 0.647, 1};
float	KNSaturation	<string UIName="Nighteye Saturation";string UIWidget="Spinner";float UIMin=0.0;float UIMax=10.0;>			= {1.0};
float	KNBrightness	<string UIName="Nighteye Brightness";string UIWidget="Spinner";float UIMin=-5.0;float UIMax=5.0;>			= {0.0};
float	KNContrast		<string UIName="Nighteye Contrast";string UIWidget="Spinner";float UIMin=0.0;float UIMax=5.0;>				= {0.99};
float	KNInBlack		<string UIName="Nighteye Low Clip";string UIWidget="Spinner";float UIMin=0.0;float UIMax=1.0;>				= {0.0};
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////



int		AGCC 				< string UIName="----------Apply Game Color Correction---------"; string UIWidget="spinner"; int UIMin=0; int UIMax=0;> = {0.0};
bool 	ENABLE_AGCC 			< string UIName = "Apply Game Color Correction";> = {false};

// DAY NIGHT INTERIOR ADJUSTORS
int             DNI              < string UIName="----------Day Night Interior Adjustors----------";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0.0};

//POSTPROCESS 1

int		DAWN 				< string UIName="-------------------Dawn Settings-------------------"; string UIWidget="spinner"; int UIMin=0; int UIMax=0;> = {0.0};

float EBrightnessV2Dawn
<
string UIName="Brightness - Dawn";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {0.9};

float EAdaptationMinV2Dawn
<
string UIName="Adaptation Min - Dawn ";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EAdaptationMaxV2Dawn
<
string UIName="Adaptation Max - Dawn";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EToneMappingCurveV2Dawn
<
string UIName="ToneMapping Curve - Dawn";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {7.0};

float EIntensityContrastV2Dawn
<
string UIName="Contrast - Dawn";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EColorSaturationV2Dawn
<
string UIName="Saturation - Dawn";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EToneMappingOversaturationV2Dawn
<
string UIName="Overbright Dampening - Dawn";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {60.0};

int		SUNRISE 				< string UIName="--------------------Sunrise Settings----------------"; string UIWidget="spinner"; int UIMin=0; int UIMax=0;> = {0.0};

float EBrightnessV2Sunrise
<
string UIName="Brightness - Sunrise";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {1.0};

float EAdaptationMinV2Sunrise
<
string UIName="Adaptation Min - Sunrise ";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EAdaptationMaxV2Sunrise
<
string UIName="Adaptation Max - Sunrise";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EToneMappingCurveV2Sunrise
<
string UIName="ToneMapping Curve - Sunrise";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {6.0};

float EIntensityContrastV2Sunrise
<
string UIName="Contrast - Sunrise";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EColorSaturationV2Sunrise
<
string UIName="Saturation - Sunrise";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EToneMappingOversaturationV2Sunrise
<
string UIName="Overbright Dampening - Sunrise";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {60.0};

int		DAY 				< string UIName="----------------------Day Settings-------------------"; string UIWidget="spinner"; int UIMin=0; int UIMax=0;> = {0.0};

float EBrightnessV2Day
<
string UIName="Brightness - Day";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {1.0};

float EAdaptationMinV2Day
<
string UIName="Adaptation Min - Day ";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EAdaptationMaxV2Day
<
string UIName="Adaptation Max - Day";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EToneMappingCurveV2Day
<
string UIName="ToneMapping Curve - Day";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {5.0};

float EIntensityContrastV2Day
<
string UIName="Contrast - Day";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EColorSaturationV2Day
<
string UIName="Saturation - Day";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EToneMappingOversaturationV2Day
<
string UIName="Overbright Dampening - Day";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {60.0};

int		SUNSET 				< string UIName="---------------------Sunset Settings----------------"; string UIWidget="spinner"; int UIMin=0; int UIMax=0;> = {0.0};

float EBrightnessV2Sunset
<
string UIName="Brightness - Sunset";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {1.00};

float EAdaptationMinV2Sunset
<
string UIName="Adaptation Min - Sunset";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.05};

float EAdaptationMaxV2Sunset
<
string UIName="Adaptation Max - Sunset";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.1};

float EToneMappingCurveV2Sunset
<
string UIName="ToneMapping Curve - Sunset";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {6.0};

float EIntensityContrastV2Sunset
<
string UIName="Contrast - Sunset";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.35};

float EColorSaturationV2Sunset
<
string UIName="Saturation - Sunset";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {0.9};

float EToneMappingOversaturationV2Sunset
<
string UIName="Overbright Dampening - Sunset";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {50.0};

int		DUSK 				< string UIName="----------------------Dusk Settings-----------------"; string UIWidget="spinner"; int UIMin=0; int UIMax=0;> = {0.0};

float EBrightnessV2Dusk
<
string UIName="Brightness - Dusk";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {0.9};

float EAdaptationMinV2Dusk
<
string UIName="Adaptation Min - Dusk";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.05};

float EAdaptationMaxV2Dusk
<
string UIName="Adaptation Max - Dusk";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.1};

float EToneMappingCurveV2Dusk
<
string UIName="ToneMapping Curve - Dusk";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {8.0};

float EIntensityContrastV2Dusk
<
string UIName="Contrast - Dusk";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.35};

float EColorSaturationV2Dusk
<
string UIName="Saturation - Dusk";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {0.9};

float EToneMappingOversaturationV2Dusk
<
string UIName="Overbright Dampening - Dusk";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {50.0};

int		NIGHT				< string UIName="----------------------Night Settings-----------------"; string UIWidget="spinner"; int UIMin=0; int UIMax=0;> = {0.0};

float EBrightnessV2Night
<
string UIName="Brightness - Night";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {0.75};

float EAdaptationMinV2Night
<
string UIName="Adaptation Min - Night";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.05};

float EAdaptationMaxV2Night
<
string UIName="Adaptation Max - Night";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.1};

float EToneMappingCurveV2Night
<
string UIName="ToneMapping Curve - Night";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {10.0};

float EIntensityContrastV2Night
<
string UIName="Contrast - Night";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.35};

float EColorSaturationV2Night
<
string UIName="Saturation - Night";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {0.9};

float EToneMappingOversaturationV2Night
<
string UIName="Overbright Dampening - Night";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {50.0};

int		INTERIOR 				< string UIName="--------------------Interior Settings----------------"; string UIWidget="spinner"; int UIMin=0; int UIMax=0;> = {0.0};

float EBrightnessV2Interior
<
string UIName="Brightness - Interior";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {1.0};

float EAdaptationMinV2Interior
<
string UIName="Adaptation Min - Interior";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.07};

float EAdaptationMaxV2Interior
<
string UIName="Adaptation Max - Interior";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.1};

float EToneMappingCurveV2Interior
<
string UIName="ToneMapping Curve - Interior";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {4.0};

float EIntensityContrastV2Interior
<
string UIName="Contrast - Interior";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.0};

float EColorSaturationV2Interior
<
string UIName="Saturation - Interior";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.0};
		
float EToneMappingOversaturationV2Interior
<
string UIName="Overbright Dampening - Interior";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {30.0};

int		ENBCOLOR 				< string UIName="-----------Color Correction Settings--------"; string UIWidget="spinner"; int UIMin=0; int UIMax=0;> = {0.0};	

#ifdef E_CC_PROCEDURAL
//parameters for ldr color correction
float	ECCGamma
<
	string UIName="CC: Gamma";
	string UIWidget="Spinner";
	float UIMin=0.2;//not zero!!!
	float UIMax=5.0;
> = {1.5};

float	ECCInBlack
<
	string UIName="CC: In black";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCInWhite
<
	string UIName="CC: In white";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCOutBlack
<
	string UIName="CC: Out black";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCOutWhite
<
	string UIName="CC: Out white";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCBrightness
<
	string UIName="CC: Brightness";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {1.0};

float	ECCContrastGrayLevel
<
	string UIName="CC: Contrast gray level";
	string UIWidget="Spinner";
	float UIMin=0.01;
	float UIMax=0.99;
> = {0.5};

float	ECCContrast
<
	string UIName="CC: Contrast";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {1.0};

float	ECCSaturation
<
	string UIName="CC: Saturation";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {1.0};

float	ECCDesaturateShadows
<
	string UIName="CC: Desaturate shadows";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float3	ECCColorBalanceShadows <
	string UIName="CC: Color balance shadows";
	string UIWidget="Color";
> = {0.5, 0.5, 0.5};

float3	ECCColorBalanceHighlights <
	string UIName="CC: Color balance highlights";
	string UIWidget="Color";
> = {0.5, 0.5, 0.5};

float3	ECCChannelMixerR <
	string UIName="CC: Channel mixer R";
	string UIWidget="Color";
> = {1.0, 0.0, 0.0};

float3	ECCChannelMixerG <
	string UIName="CC: Channel mixer G";
	string UIWidget="Color";
> = {0.0, 1.0, 0.0};

float3	ECCChannelMixerB <
	string UIName="CC: Channel mixer B";
	string UIWidget="Color";
> = {0.0, 0.0, 1.0};
#endif //E_CC_PROCEDURAL



//+++++++++++++++++++++++++++++
//external enb parameters, do not modify
//+++++++++++++++++++++++++++++
//x = generic timer in range 0..1, period of 16777216 ms (4.6 hours), y = average fps, w = frame time elapsed (in seconds)
float4	Timer;
//x = Width, y = 1/Width, z = aspect, w = 1/aspect, aspect is Width/Height
float4	ScreenSize;
//changes in range 0..1, 0 means full quality, 1 lowest dynamic quality (0.33, 0.66 are limits for quality levels)
float	AdaptiveQuality;
//x = current weather index, y = outgoing weather index, z = weather transition, w = time of the day in 24 standart hours. Weather index is value from weather ini file, for example WEATHER002 means index==2, but index==0 means that weather not captured.
float4	Weather;
//x = dawn, y = sunrise, z = day, w = sunset. Interpolators range from 0..1
float4	TimeOfDay1;
//x = dusk, y = night. Interpolators range from 0..1
float4	TimeOfDay2;
//changes in range 0..1, 0 means that night time, 1 - day time
float	ENightDayFactor;
//changes 0 or 1. 0 means that exterior, 1 - interior
float	EInteriorFactor;
float   timeweight=0.000001;
float   timevalue=0.0;



//+++++++++++++++++++++++++++++
//external enb debugging parameters for shader programmers, do not modify
//+++++++++++++++++++++++++++++
//keyboard controlled temporary variables. Press and hold key 1,2,3...8 together with PageUp or PageDown to modify. By default all set to 1.0
float4	tempF1; //0,1,2,3
float4	tempF2; //5,6,7,8
float4	tempF3; //9,0
// xy = cursor position in range 0..1 of screen;
// z = is shader editor window active;
// w = mouse buttons with values 0..7 as follows:
//    0 = none
//    1 = left
//    2 = right
//    3 = left+right
//    4 = middle
//    5 = left+middle
//    6 = right+middle
//    7 = left+right+middle (or rather cat is sitting on your mouse)
float4	tempInfo1;
// xy = cursor position of previous left mouse button click
// zw = cursor position of previous right mouse button click
float4	tempInfo2;



//+++++++++++++++++++++++++++++
//game and mod parameters, do not modify
//+++++++++++++++++++++++++++++
float4				Params01[7]; //skyrimse parameters
//x - bloom amount; y - lens amount
float4				ENBParams01; //enb parameters

float3				LumCoeff = float3(0.2125, 0.7154, 0.0721);

Texture2D			TextureColor; //hdr color
Texture2D			TextureBloom; //vanilla or enb bloom
Texture2D			TextureLens; //enb lens fx
Texture2D			TextureDepth; //scene depth
Texture2D			TextureAdaptation; //vanilla or enb adaptation
Texture2D			TextureAperture; //this frame aperture 1*1 R32F hdr red channel only. computed in depth of field shader file

SamplerState		Sampler0
{
	Filter = MIN_MAG_MIP_POINT;//MIN_MAG_MIP_LINEAR;
	AddressU = Clamp;
	AddressV = Clamp;
};
SamplerState		Sampler1
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Clamp;
	AddressV = Clamp;
};



//+++++++++++++++++++++++++++++
//
//+++++++++++++++++++++++++++++
struct VS_INPUT_POST
{
	float3 pos		: POSITION;
	float2 txcoord	: TEXCOORD0;
};
struct VS_OUTPUT_POST
{
	float4 pos		: SV_POSITION;
	float2 txcoord0	: TEXCOORD0;
};

////////////////////////////////////////////

float3 Tonemap_Filmic(float3 color, float W, float A, float B, float C, float D, float E, float F)
{
    float4 res = float4(color.rgb, W);
    res        = (res * ( A * res + C * B) + D * E) / (res * ( A * res + B) + D * F);
    res       -= E / F;
    return res.rgb / res.a;
}

float4 SkySimpleAGCC(float4 inColor, float2 inCoords)
{
	#define LUM_709  float3(0.2125, 0.7154, 0.0721)
	bool   scalebloom  = (0.5<=Params01[0].x);
    float2 scaleduv    = clamp(0.0, Params01[6].zy, Params01[6].xy * inCoords.xy);
    float4 bloom       = TextureBloom.Sample(Sampler1, (scalebloom)? inCoords.xy: scaleduv); //linear sampler
    float2 middlegray  = TextureAdaptation.Sample(Sampler1, inCoords.xy).xy; //.x == current, .y == previous
    middlegray.y = 1.0; //bypass for enbadaptation format

    float  saturation  = Params01[3].x;   /// 0 == gray scale
    float3 tint        = Params01[4].rgb;     	/// tint color
	float  tint_weight = Params01[4].w;   		// 0 == no tint
    float  contrast    = Params01[3].z;   /// 0 == no contrast
    float  brightness  = Params01[3].w;   /// intensity
    float3 fade        = Params01[5].xyz;     	/// fade current scene to specified color, mostly used in special effects
	float  fade_weight = Params01[5].w;   		// 0 == no fade

    inColor.a   = dot(inColor.rgb, LUM_709);      /// Get luminance
    inColor.rgb = lerp(inColor.a, inColor.rgb, saturation);              /// Saturation
    inColor.rgb = lerp(inColor.rgb, inColor.a * tint.rgb, tint_weight);       /// Tint
    inColor.rgb = lerp(middlegray.x, brightness * inColor.rgb, contrast);  /// Contrast & intensity
    inColor.rgb = pow(saturate(inColor.rgb), Params01[6].w); //this line is unused??
    inColor.rgb = lerp(inColor.rgb, fade, fade_weight);                   /// Fade current scene to specified color

	inColor.a = 1.0;
    inColor.rgb = saturate(inColor.rgb);

  return inColor;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
VS_OUTPUT_POST	VS_Draw(VS_INPUT_POST IN)
{
	VS_OUTPUT_POST	OUT;
	float4	pos;
	pos.xyz=IN.pos.xyz;
	pos.w=1.0;
	OUT.pos=pos;
	OUT.txcoord0.xy=IN.txcoord.xy;
	return OUT;
}



float4	PS_Draw(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
	float4	res;
	float4	color;

	color=TextureColor.Sample(Sampler0, IN.txcoord0.xy); //hdr scene color

	float3	lens;
	lens.xyz=TextureLens.Sample(Sampler1, IN.txcoord0.xy).xyz;
	color.xyz+=lens.xyz * ENBParams01.y; //lens amount

	float3	bloom=TextureBloom.Sample(Sampler1, IN.txcoord0.xy);

	bloom.xyz=bloom-color;
	bloom.xyz=max(bloom, 0.0);
	color.xyz+=bloom*ENBParams01.x; //bloom amount

	float	grayadaptation=TextureAdaptation.Sample(Sampler0, IN.txcoord0.xy).x;

#ifdef ACTIVATE_AGCC 
    if (ENABLE_AGCC==true) {
		color = SkySimpleAGCC(color, IN.txcoord0.xy);  
	}
#endif

#if (POSTPROCESS==1)

float   timeweight;
float   timevalue;


//FIRST
timeweight=0.000001;
timevalue=0.0;

timevalue+=TimeOfDay1.x * EBrightnessV2Dawn;
timevalue+=TimeOfDay1.y * EBrightnessV2Sunrise;
timevalue+=TimeOfDay1.z * EBrightnessV2Day;
timevalue+=TimeOfDay1.w * EBrightnessV2Sunset;
timevalue+=TimeOfDay2.x * EBrightnessV2Dusk;
timevalue+=TimeOfDay2.y * EBrightnessV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;

	float newEBrightnessV2;
	newEBrightnessV2=lerp((timevalue / timeweight), EBrightnessV2Interior, EInteriorFactor );

//SECOND
timeweight=0.000001;
timevalue=0.0;

	
timevalue+=TimeOfDay1.x * EColorSaturationV2Dawn;
timevalue+=TimeOfDay1.y * EColorSaturationV2Sunrise;
timevalue+=TimeOfDay1.z * EColorSaturationV2Day;
timevalue+=TimeOfDay1.w * EColorSaturationV2Sunset;
timevalue+=TimeOfDay2.x * EColorSaturationV2Dusk;
timevalue+=TimeOfDay2.y * EColorSaturationV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;

	float newEColorSaturationV2;
	newEColorSaturationV2=lerp((timevalue / timeweight), EColorSaturationV2Interior, EInteriorFactor );
	
//Third
timeweight=0.000001;
timevalue=0.0;
	
timevalue+=TimeOfDay1.x * EAdaptationMaxV2Dawn;
timevalue+=TimeOfDay1.y * EAdaptationMaxV2Sunrise;
timevalue+=TimeOfDay1.z * EAdaptationMaxV2Day;
timevalue+=TimeOfDay1.w * EAdaptationMaxV2Sunset;
timevalue+=TimeOfDay2.x * EAdaptationMaxV2Dusk;
timevalue+=TimeOfDay2.y * EAdaptationMaxV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;

	float newEAdaptationMax;
	newEAdaptationMax=lerp((timevalue / timeweight), EAdaptationMaxV2Interior, EInteriorFactor );

//Fourth
timeweight=0.000001;
timevalue=0.0;
	
timevalue+=TimeOfDay1.x * EAdaptationMinV2Dawn;
timevalue+=TimeOfDay1.y * EAdaptationMinV2Sunrise;
timevalue+=TimeOfDay1.z * EAdaptationMinV2Day;
timevalue+=TimeOfDay1.w * EAdaptationMinV2Sunset;
timevalue+=TimeOfDay2.x * EAdaptationMinV2Dusk;
timevalue+=TimeOfDay2.y * EAdaptationMinV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;
 
	float newEAdaptationMin;
	newEAdaptationMin=lerp( (timevalue / timeweight), EAdaptationMinV2Interior, EInteriorFactor );

//Fourth
timeweight=0.000001;
timevalue=0.0;
	
timevalue+=TimeOfDay1.x * EToneMappingCurveV2Dawn;
timevalue+=TimeOfDay1.y * EToneMappingCurveV2Sunrise;
timevalue+=TimeOfDay1.z * EToneMappingCurveV2Day;
timevalue+=TimeOfDay1.w * EToneMappingCurveV2Sunset;
timevalue+=TimeOfDay2.x * EToneMappingCurveV2Dusk;

timevalue+=TimeOfDay2.y * (EToneMappingCurveV2Night*fNightlevel);


timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;

	float newEToneMappingCurve;
	newEToneMappingCurve=lerp( (timevalue / timeweight), (EToneMappingCurveV2Interior*fInteriorlevel), EInteriorFactor );
	

//Fifth
timeweight=0.000001;
timevalue=0.0;
	
timevalue+=TimeOfDay1.x * EIntensityContrastV2Dawn;
timevalue+=TimeOfDay1.y * EIntensityContrastV2Sunrise;
timevalue+=TimeOfDay1.z * EIntensityContrastV2Day;
timevalue+=TimeOfDay1.w * EIntensityContrastV2Sunset;
timevalue+=TimeOfDay2.x * EIntensityContrastV2Dusk;
timevalue+=TimeOfDay2.y * EIntensityContrastV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;
	
	float newEIntensityContrastV2;
	newEIntensityContrastV2=lerp( (timevalue / timeweight), EIntensityContrastV2Interior, EInteriorFactor );

//Sixth
timeweight=0.000001;
timevalue=0.0;
	
timevalue+=TimeOfDay1.x * EToneMappingOversaturationV2Dawn;
timevalue+=TimeOfDay1.y * EToneMappingOversaturationV2Sunrise;
timevalue+=TimeOfDay1.z * EToneMappingOversaturationV2Day;
timevalue+=TimeOfDay1.w * EToneMappingOversaturationV2Sunset;
timevalue+=TimeOfDay2.x * EToneMappingOversaturationV2Dusk;
timevalue+=TimeOfDay2.y * EToneMappingOversaturationV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;

	float newEToneMappingOversaturationV2;
	newEToneMappingOversaturationV2=lerp( (timevalue / timeweight), EToneMappingOversaturationV2Interior, EInteriorFactor );

//MIXING
	grayadaptation=max(grayadaptation, 0.0);
	grayadaptation=min(grayadaptation, 50.0);
	color.xyz=color.xyz/(grayadaptation*newEAdaptationMax+newEAdaptationMin);//*tempF1.x

	color.xyz*=(newEBrightnessV2);
	color.xyz+=0.000001;
	float3 xncol=normalize(color.xyz);
	float3 scl=color.xyz/xncol.xyz;
	scl=pow(scl, newEIntensityContrastV2);
	xncol.xyz=pow(xncol.xyz, newEColorSaturationV2);
	color.xyz=scl*xncol.xyz;

	float	lumamax=newEToneMappingOversaturationV2;
	color.xyz=(color.xyz * (1.0 + color.xyz/lumamax))/(color.xyz + newEToneMappingCurve);

#endif




#ifdef E_CC_PROCEDURAL
	//activated by UseProceduralCorrection=true
	float	tempgray;
	float4	tempvar;
	float3	tempcolor;

	//+++ levels like in photoshop, including gamma, lightness, additive brightness
	color=max(color-ECCInBlack, 0.0) / max(ECCInWhite-ECCInBlack, 0.0001);
	if (ECCGamma!=1.0) color=pow(color, ECCGamma);
	color=color*(ECCOutWhite-ECCOutBlack) + ECCOutBlack;

	//+++ brightness
	color=color*ECCBrightness;

	//+++ contrast
	color=(color-ECCContrastGrayLevel) * ECCContrast + ECCContrastGrayLevel;

	//+++ saturation
	tempgray=dot(color.xyz, 0.3333);
	color=lerp(tempgray, color, ECCSaturation);

	//+++ desaturate shadows
	tempgray=dot(color.xyz, 0.3333);
	tempvar.x=saturate(1.0-tempgray);
	tempvar.x*=tempvar.x;
	tempvar.x*=tempvar.x;
	color=lerp(color, tempgray, ECCDesaturateShadows*tempvar.x);

	//+++ color balance
	color=saturate(color);
	tempgray=dot(color.xyz, 0.3333);
	float2	shadow_highlight=float2(1.0-tempgray, tempgray);
	shadow_highlight*=shadow_highlight;
	color.rgb+=(ECCColorBalanceHighlights*2.0-1.0)*color * shadow_highlight.x;
	color.rgb+=(ECCColorBalanceShadows*2.0-1.0)*(1.0-color) * shadow_highlight.y;

	//+++ channel mixer
	tempcolor=color;
	color.r=dot(tempcolor, ECCChannelMixerR);
	color.g=dot(tempcolor, ECCChannelMixerG);
	color.b=dot(tempcolor, ECCChannelMixerB);
#endif //E_CC_PROCEDURAL


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Khajiit Nighteye Correction by Phinix
	float4 kncolor = color;
// color balance	
	float3 knsat = KNBalance;
	float3 knoldcol=kncolor.xyz;
	kncolor.xyz *= knsat;
	float3 kngrey = float3(0.333,0.333,0.333);
	kncolor.xyz += (knoldcol.x-(knoldcol.x*knsat.x)) * kngrey.x;
	kncolor.xyz += (knoldcol.y-(knoldcol.y*knsat.y)) * kngrey.y;
	kncolor.xyz += (knoldcol.z-(knoldcol.z*knsat.z)) * kngrey.z;
// saturation
	float3 intensity = dot(kncolor.rgb, LumCoeff);
	kncolor.rgb = lerp(intensity, kncolor.rgb, KNSaturation);
	kncolor.rgb /= kncolor.a;
// contrast
	kncolor.rgb = ((kncolor.rgb - 0.5) * max(KNContrast, 0)) + 0.5;
// brightness
	kncolor.rgb += (KNBrightness*0.1);
	kncolor.rgb *= kncolor.a;
// low clip
	kncolor=max(kncolor-(KNInBlack*0.1), 0.0) / max(1.0-(KNInBlack*0.1), 0.0001);
// bool for output - check whitefactor (Params01[2].y) as well as fade weight (Params01[5].w)
//
// to avoid activating for wrong image space (may need tweaking)
	bool knactive = ((Params01[5].w>KNDetect1*0.1)*(Params01[4].y<KNDetect2));
	
//return color;
color = lerp(color,kncolor,(knactive)*(KNEnable));

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	res.xyz=saturate(color);
	res.w=1.0;
	return res;
}



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Vanilla post process. Do not modify
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
float4	PS_DrawOriginal(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
	float4	res;
	float4	color;

	float2	scaleduv=Params01[6].xy*IN.txcoord0.xy;
	scaleduv=max(scaleduv, 0.0);
	scaleduv=min(scaleduv, Params01[6].zy);

	color=TextureColor.Sample(Sampler0, IN.txcoord0.xy); //hdr scene color

	float4	r0, r1, r2, r3;
	r1.xy=scaleduv;
	r0.xyz = color.xyz;
	if (0.5<=Params01[0].x) r1.xy=IN.txcoord0.xy;
	r1.xyz = TextureBloom.Sample(Sampler1, r1.xy).xyz;
	r2.xy = TextureAdaptation.Sample(Sampler1, IN.txcoord0.xy).xy; //in skyrimse it two component

	r0.w=dot(float3(2.125000e-001, 7.154000e-001, 7.210000e-002), r0.xyz);
	r0.w=max(r0.w, 1.000000e-005);
	r1.w=r2.y/r2.x;
	r2.y=r0.w * r1.w;
	if (0.5<Params01[2].z) r2.z=0xffffffff; else r2.z=0;
	r3.xy=r1.w * r0.w + float2(-4.000000e-003, 1.000000e+000);
	r1.w=max(r3.x, 0.0);
	r3.xz=r1.w * 6.2 + float2(5.000000e-001, 1.700000e+000);
	r2.w=r1.w * r3.x;
	r1.w=r1.w * r3.z + 6.000000e-002;
	r1.w=r2.w / r1.w;
	r1.w=pow(r1.w, 2.2);
	r1.w=r1.w * Params01[2].y;
	r2.w=r2.y * Params01[2].y + 1.0;
	r2.y=r2.w * r2.y;
	r2.y=r2.y / r3.y;
	if (r2.z==0) r1.w=r2.y; else r1.w=r1.w;
	r0.w=r1.w / r0.w;
	r1.w=saturate(Params01[2].x - r1.w);
	r1.xyz=r1 * r1.w;
	r0.xyz=r0 * r0.w + r1;
	r1.x=dot(r0.xyz, float3(2.125000e-001, 7.154000e-001, 7.210000e-002));
	r0.w=1.0;
	r0=r0 - r1.x;
	r0=Params01[3].x * r0 + r1.x;
	r1=Params01[4] * r1.x - r0;
	r0=Params01[4].w * r1 + r0;
	r0=Params01[3].w * r0 - r2.x;
	r0=Params01[3].z * r0 + r2.x;
	r0.xyz=saturate(r0);
	r1.xyz=pow(r1.xyz, Params01[6].w);
	//active only in certain modes, like khajiit vision, otherwise Params01[5].w=0
	r1=Params01[5] - r0;
	res=Params01[5].w * r1 + r0;

//	res.xyz = color.xyz;
//	res.w=1.0;
	return res;
}

float4	PS_DrawO(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
	 //It start with loading textures:
//The UV coord of bloom texture has a scaling factor controlled by clamps and a on/off switch.

	bool   scalebloom  = (0.5<=Params01[0].x);
    float2 scaleduv    = clamp(0.0, Params01[6].zy, Params01[6].xy * IN.txcoord0.xy);
    float4 color       = TextureColor.Sample(Sampler0, IN.txcoord0.xy); //hdr scene color, point sampler
    float4 bloom       = TextureBloom.Sample(Sampler1, (scalebloom)? IN.txcoord0.xy: scaleduv); //linear sampler
    float2 middlegray  = TextureAdaptation.Sample(Sampler1, IN.txcoord0.xy).xy; //.x == current, .y == previous
    middlegray.y = 1.0; //bypass for enbadaptation format
	float DELTA		   = max(0,0.00000001); //Thank you McFly !

//then, the tonemapper"s"
//A additional switch for switching between Reinhard-modified and Filmic ALU by Heji

	bool   UseFilmic   = (0.5<Params01[2].z);
    float  WhiteFactor = Params01[2].y;
   
    float  original_lum = max( dot(LUM_709, color.rgb), DELTA);
    float  lum_scaled   = original_lum * middlegray.y / middlegray.x;
           
    float  lum_filmic = max( lum_scaled - 0.004, 0.0);
           lum_filmic = lum_filmic * (lum_filmic * 6.2 + 0.5)  / (lum_filmic * (lum_filmic * 6.2 + 1.7) + 0.06);
           lum_filmic = pow(lum_filmic, 2.2);          //de-gamma-correction for gamma-corrected tonemapper
           lum_filmic = lum_filmic * WhiteFactor;    //linear scale
   
    float lum_reinhard = lum_scaled * (lum_scaled * WhiteFactor + 1.0) / (lum_scaled + 1.0);
   
    float lum_mapped   = (UseFilmic)? lum_filmic : lum_reinhard; //if filmic
   
    color.rgb = color.rgb * lum_mapped / original_lum;
	
//then do the bloom blending, this part is identical to the old Skyrim.

	float bloomfactor = Params01[2].x;
    color.rgb = color.rgb + bloom.rgb * saturate(bloomfactor - lum_mapped); 
	
//And the imagespace modifiers, mostly the same as the old Skyrim,
//but it has a inactive process with Params01[6].w, seemly supposed to have a gamma ops there.

	float  saturation  = Params01[3].x;   // 0 == gray scale
    float  contrast    = Params01[3].z;   // 0 == no contrast
    float  brightness  = Params01[3].w;   // intensity
   
   
    float3 tint_color  = Params01[4].rgb; // tint color
    float  tint_weight = Params01[4].w;   // 0 == no tint

    float3 fade        = Params01[5].xyz; // fade current scene to specified color, mostly used in special effects
    float  fade_weight = Params01[5].w;   // 0 == no fade
   
    color.a   = dot(color.rgb, LUM_709);
    color.rgb = lerp(color.a, color.rgb, saturation);
    color.rgb = lerp(color.rgb, tint_color * color.a , tint_weight);
    color.rgb = lerp(middlegray.x, color.rgb * brightness, contrast);
    color.rgb = pow(saturate(color.rgb), Params01[6].w); //this line is unused??
    color.rgb = lerp(color.rgb, fade, fade_weight);
    color.a = 1.0;
	
	return color;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//techniques
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
technique11 Draw <string UIName="NVT-NAT Preset";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_Draw()));
	}
}



technique11 ORIGINALPOSTPROCESS <string UIName="Vanilla";> //do not modify this technique
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_DrawO()));
	}
}


