//=======================================================================================================//
//  __________                            __     ________         .__                                    //
//  \______   \__ _____  _______  _____  |  | __ \______ \ _____  |  |__   _____ _____  _____    ____    //
//   |       _/  |  \  \/ /\__  \ \__  \ |  |/ /  |    |  \\__  \ |  |  \ /     \\__  \ \__  \  /    \   //
//   |    |   \  |  /\   /  / __ \_/ __ \|    <   |    `   \/ __ \|   Y  \  Y Y  \/ __ \_/ __ \|   |  \  //
//   |____|_  /____/  \_/  (____  (____  /__|_ \ /_______  (____  /___|  /__|_|  (____  (____  /___|  /  //
//          \/                  \/     \/     \/         \/     \/     \/      \/     \/     \/     \/   //
//============================================= Credits =================================================//
// DragensRuvaak: Autor of Ruvaak Dahmaan ENB                                                            //
// JawZ: Autor of MSL                                                                                    //
// Kingeric1992: AGCC code                                                                               //
// Aiyen: Autor of Skylight enb                                                                          //
// Boris: Autor of ENB                                                                                   //
// Adyss: File Setup, and futer edits and Tweaks for Ruvaak Dahmaan ENB                                  //
//=======================================================================================================//

bool USE_AGCC        <string UIName="Toggle AGCC";                     > = {false};
bool USE_ECC         <string UIName="Toggle ECC";                      > = {false};
bool USE_PP2         <string UIName="Toggle PP2";                      > = {false};
bool USE_OLDBLOOM    <string UIName="Use old Bloom blending method";   > = {false};
bool USE_ALU         <string UIName="Toggle Filmic ALU";               > = {false};
bool USE_ACES        <string UIName="Toggle Filmic ACES";              > = {false};
bool USE_Tonemapping <string UIName="Filmic Tonemapper";      > = {false};

float  empty                         <string UIName="----- Day -----";                 string UIWidget="spinner";  float UIMin=0.0;     float UIMax=0.0;         > = {0.0};

float ShoulderStrengthDay <		
	string UIName="Shoulder Strength Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.26};
float LinearStrengthDay <		
	string UIName="Linear Strength Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=5.0; float UIStep=0.01;
> = {0.33};
float LinearAngleDay <		
	string UIName="Linear Angle Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=1.0; float UIStep=0.01;
> = {0.09};
float ToeStrengthDay <		
	string UIName="Toe Strength Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.52};
float ToeNumeratorDay <		
	string UIName="Toe Numerator Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=0.5; float UIStep=0.001;
> = {0.115};
float ToeDenominatorDay <		
	string UIName="Toe Denominator Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {1.08};
float LinearWhiteDay <		
	string UIName="White Level Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=20.0; float UIStep=0.01;
> = {4.0};

float	ECCGamma_Day
<
	string UIName="Gamma Day";
	string UIWidget="Spinner";
	float UIMin=0.2;
	float UIMax=5.0;
> = {1.0};

float	ECCInBlack_Day
<
	string UIName="In black Day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCInWhite_Day
<
	string UIName="In white Day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCOutBlack_Day
<
	string UIName="Out black Day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCOutWhite_Day
<
	string UIName="Out white Day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCDesaturateShadows_Day
<
	string UIName="Desaturate shadows Day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};


float EAdaptationMinV2_Day <		
	string UIName="Adaptation Mix Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.02};

float EAdaptationMaxV2_Day <		
	string UIName="Adaptation Max Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.5};

float EToneMappingCurveV2_Day <		
	string UIName="Tonemapping Curve Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=20.0; float UIStep=0.01;
> = {5.00};

float EIntensityContrastV2_Day <		
	string UIName="Contrast Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=5.0; float UIStep=0.01;
> = {1.20};

float EColorSaturationV2_Day <		
	string UIName="Saturation Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=5.0; float UIStep=0.01;
> = {1.20};

float EToneMappingOversaturationV2_Day <		
	string UIName="Overbright Dampening Day"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=300.0; float UIStep=0.05;
> = {180.0};

float  empty2                        <string UIName="----- Night -----";               string UIWidget="spinner";  float UIMin=0.0;     float UIMax=0.0;         > = {0.0};

float ShoulderStrengthNight <		
	string UIName="Shoulder Strength Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.26};
float LinearStrengthNight <		
	string UIName="Linear Strength Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=5.0; float UIStep=0.01;
> = {0.33};
float LinearAngleNight <		
	string UIName="Linear Angle Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=1.0; float UIStep=0.01;
> = {0.09};
float ToeStrengthNight <		
	string UIName="Toe Strength Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.52};
float ToeNumeratorNight <		
	string UIName="Toe Numerator Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=0.5; float UIStep=0.001;
> = {0.115};
float ToeDenominatorNight <		
	string UIName="Toe Denominator Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {1.08};
float LinearWhiteNight <		
	string UIName="White Level Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=20.0; float UIStep=0.01;
> = {4.0};

float	ECCGamma_Night
<
	string UIName="Gamma Night";
	string UIWidget="Spinner";
	float UIMin=0.2;
	float UIMax=5.0;
> = {1.0};

float	ECCInBlack_Night
<
	string UIName="In black Night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCInWhite_Night
<
	string UIName="In white Night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCOutBlack_Night
<
	string UIName="Out black Night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCOutWhite_Night
<
	string UIName="Out white Night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCDesaturateShadows_Night
<
	string UIName="Desaturate shadows Night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};


float EAdaptationMinV2_Night <		
	string UIName="Adaptation Mix Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.02};

float EAdaptationMaxV2_Night <		
	string UIName="Adaptation Max Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.5};

float EToneMappingCurveV2_Night <		
	string UIName="Tonemapping Curve Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=20.0; float UIStep=0.01;
> = {5.00};

float EIntensityContrastV2_Night <		
	string UIName="Contrast Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=50.0; float UIStep=0.01;
> = {1.20};

float EColorSaturationV2_Night <		
	string UIName="Saturation Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=5.0; float UIStep=0.01;
> = {1.20};

float EToneMappingOversaturationV2_Night <		
	string UIName="Overbright Dampening Night"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=300.0; float UIStep=0.05;
> = {180.0};

float  empty3                        <string UIName="----- Interior -----";            string UIWidget="spinner";  float UIMin=0.0;     float UIMax=0.0;         > = {0.0};

float ShoulderStrengthInt <		
	string UIName="Shoulder Strength Int"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.26};
float LinearStrengthInt <		
	string UIName="Linear Strength Int"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=5.0; float UIStep=0.01;
> = {0.33};
float LinearAngleInt <		
	string UIName="Linear Angle Int"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=1.0; float UIStep=0.01;
> = {0.09};
float ToeStrengthInt <		
	string UIName="Toe Strength Int"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.52};
float ToeNumeratorInt <		
	string UIName="Toe Numerator Int"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=0.5; float UIStep=0.001;
> = {0.115};
float ToeDenominatorInt <		
	string UIName="Toe Denominator Int"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {1.08};
float LinearWhiteInt <		
	string UIName="White Level Int"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=20.0; float UIStep=0.01;
> = {4.0};

float	ECCGamma_Interior
<
	string UIName="Gamma Interior";
	string UIWidget="Spinner";
	float UIMin=0.2;
	float UIMax=5.0;
> = {1.0};

float	ECCInBlack_Interior
<
	string UIName="In black Interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCInWhite_Interior
<
	string UIName="In white Interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCOutBlack_Interior
<
	string UIName="Out black Interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCOutWhite_Interior
<
	string UIName="Out white Interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCDesaturateShadows_Interior
<
	string UIName="Desaturate shadows Interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};


float EAdaptationMinV2_Interior <		
	string UIName="Adaptation Mix Interior"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.02};

float EAdaptationMaxV2_Interior <		
	string UIName="Adaptation Max Interior"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=2.0; float UIStep=0.01;
> = {0.5};

float EToneMappingCurveV2_Interior <		
	string UIName="Tonemapping Curve Interior"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=20.0; float UIStep=0.01;
> = {5.00};

float EIntensityContrastV2_Interior <		
	string UIName="Contrast Interior"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=50.0; float UIStep=0.01;
> = {1.20};

float EColorSaturationV2_Interior <		
	string UIName="Saturation Interior"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=5.0; float UIStep=0.01;
> = {1.20};

float EToneMappingOversaturationV2_Interior <		
	string UIName="Overbright Dampening Interior"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=300.0; float UIStep=0.05;
> = {180.0};


//========================================//
// External enb parameters, do not modify //
//========================================//
float4	Timer;
float4	ScreenSize;
float	AdaptiveQuality;
float4	Weather;
float4	TimeOfDay1;
float4	TimeOfDay2;
float	ENightDayFactor;
float	EInteriorFactor;

float4	tempF1; //0,1,2,3
float4	tempF2; //5,6,7,8
float4	tempF3; //9,0

float4	tempInfo1;
float4	tempInfo2;

float4				Params01[7]; //skyrimse parameters
float4				ENBParams01; //enb parameters

//======================//
// Textures and Sampler //
//======================//
Texture2D			TextureColor;      //hdr color
Texture2D			TextureBloom;      //vanilla or enb bloom
Texture2D			TextureLens;       //enb lens fx
Texture2D			TextureDepth;      //scene depth
Texture2D			TextureAdaptation; //vanilla or enb adaptation
Texture2D			TextureAperture;   //this frame aperture 1*1 R32F hdr red channel only. computed in depth of field shader file

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

//===================//
// Struct and Vertex //
//===================//
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

//================//
// Include Helper //
//================//
#include "Modular Shaders/adyHelper.fxh"
#include "Modular Shaders/msHelpers.fxh"

#define LUM_709  float3(0.2125, 0.7154, 0.0721)

	float3 ToneFunc(float3 x, float DN, float INEX)
	{
	
	float ShoulderStrength = lerp( lerp( ShoulderStrengthDay, ShoulderStrengthNight, DN), ShoulderStrengthInt, INEX );
	float LinearStrength = lerp( lerp( LinearStrengthDay, LinearStrengthNight, DN), LinearStrengthInt, INEX );
	float LinearAngle = lerp( lerp( LinearAngleDay, LinearAngleNight, DN), LinearAngleInt, INEX );
	float ToeStrength = lerp( lerp( ToeStrengthDay, ToeStrengthNight, DN), ToeStrengthInt, INEX );
	float ToeNumerator = lerp( lerp( ToeNumeratorDay, ToeNumeratorNight, DN), ToeNumeratorInt, INEX );
	float ToeDenominator = lerp( lerp( ToeDenominatorDay, ToeDenominatorNight, DN), ToeDenominatorInt, INEX );
	
		float A = ShoulderStrength;
		float B = LinearStrength;
		float C = LinearAngle;
		float D = ToeStrength;
		float E = ToeNumerator;
		float F = ToeDenominator;
		return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F)) - E/F;
	}


	float3 ToneMapFilmic(float3 Color, float DN, float INEX)
	{
		float LinearWhite = lerp( lerp( LinearWhiteDay, LinearWhiteNight, DN), LinearWhiteInt, INEX );
		float3 numerator = ToneFunc(Color, DN, INEX);        
		float3 denominator = ToneFunc(LinearWhite, DN, INEX);
		return numerator / denominator;
	}

//==============//
// Pixel Shader //
//==============//
float4	PS_RuvaakDahmaan(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
	float4	Output;
	float	tempgray;
	float4	tempvar;
	float3	tempcolor;
	float4 color            = TextureColor.Sample      (Sampler0, IN.txcoord0.xy); 
	float4 linearcolor      = TextureColor.Sample      (Sampler1, IN.txcoord0.xy); 
    bool   scalebloom       = (0.5<=Params01[0].x);
    float2 scaleduv         = clamp(0.0, Params01[6].zy, Params01[6].xy * IN.txcoord0.xy);
    float4 bloom            = TextureBloom.Sample      (Sampler0, (scalebloom)? IN.txcoord0.xy: scaleduv);
    float2 middlegray       = TextureAdaptation.Sample (Sampler1, IN.txcoord0.xy).xy;
	float3 lens             = TextureLens.Sample       (Sampler1, IN.txcoord0.xy).xyz;
    middlegray.y            = 1.0;
	float DELTA             = max(0, 0.00000001);
	float	grayadaptation  = TextureAdaptation.Sample(Sampler0, IN.txcoord0.xy).x;
	
	color.xyz+=lens.xyz * ENBParams01.y; // Lens
	
	// DNI Splits
	float  EAdaptationMinV2                  =lerp( lerp(EAdaptationMinV2_Night,                  EAdaptationMinV2_Day,                  ENightDayFactor), EAdaptationMinV2_Interior,                  EInteriorFactor );
	float  EAdaptationMaxV2                  =lerp( lerp(EAdaptationMaxV2_Night,                  EAdaptationMaxV2_Day,                  ENightDayFactor), EAdaptationMaxV2_Interior,                  EInteriorFactor );
	float  EToneMappingCurveV2               =lerp( lerp(EToneMappingCurveV2_Night,               EToneMappingCurveV2_Day,               ENightDayFactor), EToneMappingCurveV2_Interior,               EInteriorFactor );
	float  EIntensityContrastV2              =lerp( lerp(EIntensityContrastV2_Night,              EIntensityContrastV2_Day,              ENightDayFactor), EIntensityContrastV2_Interior,              EInteriorFactor );
	float  EColorSaturationV2                =lerp( lerp(EColorSaturationV2_Night,                EColorSaturationV2_Day,                ENightDayFactor), EColorSaturationV2_Interior,                EInteriorFactor );
	float  EToneMappingOversaturationV2      =lerp( lerp(EToneMappingOversaturationV2_Night,      EToneMappingOversaturationV2_Day,      ENightDayFactor), EToneMappingOversaturationV2_Interior,      EInteriorFactor );
	float  ECCGamma                          =lerp( lerp(ECCGamma_Night,                          ECCGamma_Day,                          ENightDayFactor), ECCGamma_Interior,                          EInteriorFactor );
	float  ECCInBlack                        =lerp( lerp(ECCInBlack_Night,                        ECCInBlack_Day,                        ENightDayFactor), ECCInBlack_Interior,                        EInteriorFactor );
	float  ECCInWhite                        =lerp( lerp(ECCInWhite_Night,                        ECCInWhite_Day,                        ENightDayFactor), ECCInWhite_Interior,                        EInteriorFactor );
	float  ECCOutBlack                       =lerp( lerp(ECCOutBlack_Night,                       ECCOutBlack_Day,                       ENightDayFactor), ECCOutBlack_Interior,                       EInteriorFactor );
	float  ECCOutWhite                       =lerp( lerp(ECCOutWhite_Night,                       ECCOutWhite_Day,                       ENightDayFactor), ECCOutWhite_Interior,                       EInteriorFactor );
	float  ECCDesaturateShadows              =lerp( lerp(ECCDesaturateShadows_Night,              ECCDesaturateShadows_Day,              ENightDayFactor), ECCDesaturateShadows_Interior,              EInteriorFactor );
	
	if (USE_PP2==true) {
	grayadaptation=max(grayadaptation, 0.0);
	grayadaptation=min(grayadaptation, 50.0);
	color.xyz=color.xyz/(grayadaptation*EAdaptationMaxV2+EAdaptationMinV2);

	color.xyz+=0.000001;
	float3 xncol=normalize(color.xyz);
	float3 scl=color.xyz/xncol.xyz;
	scl=pow(scl, EIntensityContrastV2);
	xncol.xyz=pow(xncol.xyz, EColorSaturationV2);
	color.xyz=scl*xncol.xyz;

	float	lumamax=EToneMappingOversaturationV2;
	color.xyz=(color.xyz * (1.0 + color.xyz/lumamax))/(color.xyz + EToneMappingCurveV2);
	}

	if (USE_AGCC==true) {
    float  saturation       = Params01[3].x;   /// 0 == gray scale
    float  contrast         = Params01[3].z;   /// 0 == no contrast
    float  brightness       = Params01[3].w;   /// intensity
    float3 tint_color       = Params01[4].rgb; /// tint color
    float  tint_weight      = Params01[4].w;   /// 0 == no tint
    float3 fade             = Params01[5].xyz; /// fade current scene to specified color, mostly used in special effects
    float  fade_weight      = Params01[5].w;   /// 0 == no fade

    color.a                 = dot (color.rgb, LUM_709);
    color.rgb               = lerp(color.a, color.rgb, saturation);
    color.rgb               = lerp(color.rgb, tint_color * color.a , tint_weight);
    color.rgb               = lerp(middlegray.x, color.rgb * brightness, contrast);
    color.rgb               = lerp(color.rgb, fade, fade_weight);
    color.a             	= 1.0;
	}

	if (USE_OLDBLOOM==true) {
	bloom.xyz=bloom-color;
	bloom.xyz=max(bloom, 0.0);
	color.xyz+=bloom*ENBParams01.x; //bloom amount
	}
	
	if (USE_OLDBLOOM==false) {
	float bloomfactor       = ENBParams01.x;
    color.rgb               = color.rgb + bloom.rgb * saturate(bloomfactor); 
	}
	
	if (USE_ECC==true) {
	color=max(color-ECCInBlack, 0.0) / max(ECCInWhite-ECCInBlack, 0.0001);
	if (ECCGamma!=1.0) color=pow(color, ECCGamma);
	color=color*(ECCOutWhite-ECCOutBlack) + ECCOutBlack;
	
	// desaturate shadows
	tempgray=dot(color.xyz, 0.3333);
	tempvar.x=saturate(1.0-tempgray);
	tempvar.x*=tempvar.x;
	tempvar.x*=tempvar.x;
	color=lerp(color, tempgray, ECCDesaturateShadows*tempvar.x);
	}
	
	if (USE_ALU==true) {
	color.rgb = TM_FilmicALU(color);
	}
    
	if (USE_ACES==true) {
	color.rgb = ACESFilmRec2020(color);
	}
	
	if (USE_Tonemapping==true) {
	color.xyz =	ToneMapFilmic(color.xyz, 1 - ENightDayFactor, EInteriorFactor);
	}

	Output.xyz=saturate(color);
	Output.w=1.0;
	return Output;
}

//============//
// techniques //
//============//
technique11 Draw <string UIName="Ruvaak Dahmaan";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader (CompileShader(ps_5_0, PS_RuvaakDahmaan()));
	}
}
