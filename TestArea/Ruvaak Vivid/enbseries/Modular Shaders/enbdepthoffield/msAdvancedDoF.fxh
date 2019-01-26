//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//           Contains Advanced Depth of Field          //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// Marty McFly: Advanced Depth of Field author         //
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

int DOFrow <string UIName="--------------ADVANCED DEPTH OF FIELD";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
//Non UI-able vars (actually possible but requires dynamic branching which wastes resources even when effects are not used).
//Use APPLY EFFECTS in enbseries.ini window if changes do not apply. Remember that this reverts all unsaved changes made in UI ("Save Configuration" to make sure).
//#define bADOF_ShapePreviewWindowEnable	0    //[0 or 1] Enables a small window that previews how the current bokeh shape looks like, makes understanding of shape params easier.
#define bADOF_ShapeWeightEnable          	0    //[0 or 1] Enables bokeh shape weight bias and shifts color to the shape borders.
#define bADOF_ShapeChromaEnable          	1    //[0 or 1] Enables chromatic aberration at bokeh shape borders.
#define iADOF_ShapeChromaOrder           	3    //[1 to 6] Switches through the possible R G B shifts.
#define iADOF_ShapeChromaMode            	1    //[0 or 1] 0 : per bokeh sample (very slow. high quality) | 1 : derivative based (fast, maybe artifacts)
#define iADOF_FocusMode                  	0    //[0 to 1] 0: gp65cj042/Marty McFly focusing | 1: Tilt Shift
#define iADOF_MaskMode                   	1    //[0 or 1] 0: AMD modified | 1: Marty McFly '16 //Blur masking prevents focus pixels to spread color into blurred areas.
#define bADOF_BlurDependingOnPixelSize   	0    //[0 or 1] 0: blur radius factor of screen size | 1: blur radius factor of pixel size ( = different perceived blur radius if using different fullscreen resolutions, because pixels have different size relative to screen)
#define bADOF_AutofocusSmoothingEnable   	0    //[0 or 1] Because of hysteresis, AF adjusts faster from near to far than far to near. This tries to compensate that behaviour but can never be mathematically correct.

//UI vars
#if(iADOF_FocusMode == 0)//Marty McFly (gp65cj04 modified) Focusing
bool    bADOF_AutofocusEnable           < string UIName="DOF: Enable Autofocus"; > = {true};
float2	fADOF_AutofocusCenter           < string UIName="DOF: Autofocus sample center";          string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.00;  float UIMax=1.00;  > = {0.5,0.5};
int	iADOF_AutofocusSamples              < string UIName="DOF: Autofocus sample count";           string UIWidget="spinner";  int UIMin=0;  int UIMax=10;  > = {6};
float	fADOF_AutofocusRadius           < string UIName="DOF: Autofocus sample radius";          string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.00;  float UIMax=0.50;  > = {0.05};
float	fADOF_ManualfocusDepth          < string UIName="DOF: Manual focus depth";               string UIWidget="Spinner";  float UIStep=0.001;  float UIMin=0.00;  float UIMax=1.0;  > = {0.05};
float	fADOF_NearBlurCurve             < string UIName="DOF: Near blur curve";                  string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.00;  float UIMax=20.0;  > = {1.0};
float	fADOF_FarBlurCurve              < string UIName="DOF: Far blur curve";                   string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.00;  float UIMax=20.0;  > = {1.4};
float	fADOF_NearBlurMult              < string UIName="DOF: Near blur mult";                   string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.00;  float UIMax=1.0;  > = {0.0};
float	fADOF_FarBlurMult               < string UIName="DOF: Far blur mult";                    string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.00;  float UIMax=1.0;  > = {1.0};
float	fADOF_InfiniteFocus             < string UIName="DOF: Infinite depth distance";          string UIWidget="Spinner";  float UIStep=0.001;  float UIMin=0.00;  float UIMax=1.0;  > = {0.015};
#endif
#if(iADOF_FocusMode == 1)//Marty McFly Tilt Shift
float	fADOF_TiltShiftPosition         < string UIName="DOF: Tilt Shift Axis Position";         string UIWidget="Spinner";  float UIStep=0.01;	float UIMin=-1.0;  float UIMax=1.0;  > = {0.0};
float	fADOF_TiltShiftWidth            < string UIName="DOF: Tilt Shift Focus Width";           string UIWidget="Spinner";  float UIStep=0.01;	float UIMin=0.0;  float UIMax=1.0;  > = {0.0};
float	fADOF_TiltShiftRotation         < string UIName="DOF: Tilt Shift Axis Rotation (\xB0)";  string UIWidget="Spinner";  float UIStep=1.00;	float UIMin=0.0;  float UIMax=180.0;  > = {0.0};
float	fADOF_TiltShiftBlurCurve        < string UIName="DOF: Tilt Shift Blur Curve";            string UIWidget="Spinner";  float UIStep=0.01;	float UIMin=0.01;  float UIMax=10.0;  > = {2.0};
#endif
float	fADOF_BokehCurve                < string UIName="DOF: Bokeh Intensity";                  string UIWidget="Spinner";  float UIStep=0.1;  float UIMin=1.0;  float UIMax=10.0;  > = {4.5};
bool    bADOF_ShapePreviewWindowEnable  < string UIName="DOF: Enable Bokeh shape preview window"; > = {false};
float	fADOF_ShapeRadius               < string UIName="DOF: Bokeh shape max size";             string UIWidget="Spinner";  float UIStep=0.1;  float UIMin=0.0;  float UIMax=50.0;  > = {15.0};
int     iADOF_ShapeVertices             < string UIName="DOF: Bokeh shape vertices";             string UIWidget="spinner";  int UIMin=3;  int UIMax=9;  > = {6};
int     iADOF_ShapeQuality              < string UIName="DOF: Bokeh shape quality";              string UIWidget="spinner";  int UIMin=2;  int UIMax=25;  > = {5};
float	fADOF_ShapeCurvatureAmount      < string UIName="DOF: Bokeh shape curvature";            string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=-1.0;  float UIMax=1.0;  > = {1.0};
float	fADOF_ShapeRotation             < string UIName="DOF: Bokeh shape rotation (\xB0)";      string UIWidget="Spinner";  float UIStep=1;  float UIMin=0;  float UIMax=360;  > = {15};
float	fADOF_ShapeAnamorphRatio        < string UIName="DOF: Bokeh shape aspect ratio";         string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.0;  float UIMax=1.0;  > = {1.0};
#if(bADOF_ShapeWeightEnable != 0)
 float	fADOF_ShapeWeightCurve          < string UIName="DOF: Bokeh shape weight curve";         string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.50;  float UIMax=8.0;  > = {3.0};
 float	fADOF_ShapeWeightAmount         < string UIName="DOF: Bokeh shape weight amount";        string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.00;	float UIMax=1.0;  > = {0.65};
#endif
#if(bADOF_ShapeChromaEnable != 0)
 float	fADOF_ShapeChromaAmount         < string UIName="DOF: Shape chroma amount";              string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.00;  float UIMax=0.50;  > = {0.15};
#endif
float	fADOF_RenderResolutionMult      < string UIName="DOF: Blur render res mult";             string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.5;  float UIMax=1.0;  > = {0.5};
float	fADOF_SmootheningAmount         < string UIName="DOF: Gaussian postblur width";          string UIWidget="Spinner";  float UIStep=0.01;  float UIMin=0.1;  float UIMax=5.0;  > = {1.0};

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//redefine disabled UI vars
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#if (bADOF_ShapeChromaEnable == 0)
 #define fADOF_ShapeChromaAmount 0.0
#endif


// ------------------- //
//    DoF Parameters   //
// ------------------- //

#define PixelSize 		 float2(ScreenSize.y,ScreenSize.y*ScreenSize.z)
#define DepthParameters  float4(1.0,3000.0,-2999.0f,0.0) //x = near plane, y = far plane, z = -(y-x), w = unused


// ------------------- //
//    VERTEX SHADER    //
// ------------------- //

void VS_DOF(in float3 inpos : POSITION, inout float2 txcoord0 : TEXCOORD0, out float4 outpos : SV_POSITION) {
	outpos = float4(inpos.xyz, 1.0);
}

// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

float GetLinearDepth(float2 coords) {
	float depth = TextureDepth.SampleLevel(Sampler1, coords.xy,0).x;
	depth *= rcp(DepthParameters.y + depth * DepthParameters.z);
	return depth;
}

float3 RemoveFireflies(Texture2D inputtex, float2 texcoord) {
	float3 blockTL = 0, blockTR = 0, blockBR = 0, blockBL = 0, blockCC = 0;
	float3 tex;

	//unrolled for parallelization
	tex = inputtex.Sample(Sampler1, texcoord.xy + float2(-2, -2) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockTL += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2( 0, -2) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockTL += tex; blockTR += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2( 2, -2) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockTR += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2(-2,  0) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockTL += tex; blockBL += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2( 0,  0) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockTL += tex; blockTR += tex; blockBR += tex; blockBL += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2( 2,  0) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockTR += tex; blockBR += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2(-2,  2) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockBL += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2( 0,  2) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockBL += tex; blockBR += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2( 2,  2) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockBR += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2(-1, -1) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockCC += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2( 1, -1) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockCC += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2( 1,  1) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockCC += tex;

	tex = inputtex.Sample(Sampler1, texcoord.xy + float2(-1,  1) * PixelSize).rgb;
	tex /= 1.0 + max(tex.x,max(tex.y,tex.z));
	blockCC += tex;

	blockTL /= 4.0; blockTR /= 4.0; blockBR /= 4.0; blockBL /= 4.0; blockCC /= 4.0;

	blockTL /= (1 - max(blockTL.x,max(blockTL.y,blockTL.z)));
	blockTR /= (1 - max(blockTR.x,max(blockTR.y,blockTR.z)));
	blockBR /= (1 - max(blockBR.x,max(blockBR.y,blockBR.z)));
	blockBL /= (1 - max(blockBL.x,max(blockBL.y,blockBL.z)));
	blockCC /= (1 - max(blockCC.x,max(blockCC.y,blockCC.z)));

	return 0.5 * blockCC + 0.125 * (blockTL + blockTR + blockBR + blockBL);
}

float GetCoC(float2 texcoord) {
        float   scenecoc 	= 0.0;

        #if(iADOF_FocusMode == 0)
                float	scenedepth	= GetLinearDepth(texcoord.xy);
        	float	scenefocus	= TextureFocus.Sample(Sampler0, texcoord.xy).x;

                //scenefocus = saturate(scenefocus/fADOF_InfiniteFocus);
                scenedepth = saturate(scenedepth/fADOF_InfiniteFocus);

	        float farBlurDepth = scenefocus*pow(4.0,fADOF_FarBlurCurve);

                if(scenedepth < scenefocus)
	        {
	        	//scenecoc = (scenedepth - scenefocus) / scenefocus;
                        scenecoc = scenedepth*rcp(scenefocus) + (-1.0); //faster
	        	scenecoc *= fADOF_NearBlurMult;
	        }
	        else
	        {
	        	//scenecoc=(scenedepth - scenefocus)/(farBlurDepth - scenefocus);
                        scenecoc=scenedepth*(1.0/(farBlurDepth-scenefocus)) + (-scenefocus/(farBlurDepth-scenefocus)); //faster
	        	scenecoc *= fADOF_FarBlurMult;
	        	scenecoc=saturate(scenecoc);
	        }
	        scenecoc = (scenedepth < 0.00000001) ? 0.0 : scenecoc; //first person models, that epsilon is handpicked, do not change
        #elif(iADOF_FocusMode == 1)
                float2 ncoord = texcoord.xy * 2.0 - 1.0;
                //ncoord.x *= ScreenSize.z;

                float2 matrixVector;
                sincos(fADOF_TiltShiftRotation*0.0174533,matrixVector.x,matrixVector.y);
                float2x2 axisrot = float2x2(matrixVector.y,-matrixVector.x,matrixVector.xy);

                ncoord.xy = mul(ncoord.xy,axisrot);
                ncoord.y += fADOF_TiltShiftPosition;

                scenecoc = abs(ncoord.y);
                scenecoc = saturate((scenecoc - fADOF_TiltShiftWidth) / (1.00001 - fADOF_TiltShiftWidth));
                scenecoc = pow(scenecoc,fADOF_TiltShiftBlurCurve);
        #endif

	scenecoc = saturate(scenecoc * 0.5 + 0.5);
	return scenecoc;
}

float4 colortexSampleChroma(Texture2D colortex, float2 sourcecoord, float2 offsetcoord, float3 chromaoffsets) { // new function
	float4 res 		= 0.0;
	float2 Rsample 		= colortex.SampleLevel(Sampler1, sourcecoord.xy + offsetcoord.xy * chromaoffsets.x,0).xw;
	float2 Gsample 		= colortex.SampleLevel(Sampler1, sourcecoord.xy + offsetcoord.xy * chromaoffsets.y,0).yw;
	float2 Bsample 		= colortex.SampleLevel(Sampler1, sourcecoord.xy + offsetcoord.xy * chromaoffsets.z,0).zw;
	res.xyz 		= float3(Rsample.x,Gsample.x,Bsample.x);
	res.w 			= min(Rsample.y,min(Gsample.y,Bsample.y)); //best for masking
	return res;
}

float3 GetChromaticAberrationOffsets() {
        float3 chromaoffsets = float3(1.0 - fADOF_ShapeChromaAmount, 1.0, 1.0 + fADOF_ShapeChromaAmount);
        #if(  iADOF_ShapeChromaOrder == 2)
               chromaoffsets.xyz = chromaoffsets.zxy;
        #elif(iADOF_ShapeChromaOrder == 3)
               chromaoffsets.xyz = chromaoffsets.yzx;
        #elif(iADOF_ShapeChromaOrder == 4)
               chromaoffsets.xyz = chromaoffsets.xzy;
        #elif(iADOF_ShapeChromaOrder == 5)
               chromaoffsets.xyz = chromaoffsets.yxz;
        #elif(iADOF_ShapeChromaOrder == 6)
               chromaoffsets.xyz = chromaoffsets.zyx;
        #else
               chromaoffsets.xyz = chromaoffsets.xyz;
        #endif
        return chromaoffsets;
}

float3 BokehBlur(Texture2D colortex, float2 coords, float discRadius, float centerDepth) {
	float4 res 			= float4(pow(colortex.Sample(Sampler1, coords.xy).xyz,fADOF_BokehCurve), 1.0f);
	int ringCount			= round(lerp(1.0,(float)iADOF_ShapeQuality,discRadius/fADOF_ShapeRadius));
	float ringIncrement		= rcp(ringCount);
        #if(bADOF_BlurDependingOnPixelSize == 1)
                float2 discRadiusInPixels	= discRadius*(PixelSize.xy*float2(fADOF_ShapeAnamorphRatio,1.0f));
        #else
                float2 discRadiusInPixels	= discRadius*float2(fADOF_ShapeAnamorphRatio,ScreenSize.z)*0.0006;
        #endif
	float Alpha                     = 6.2831853 / iADOF_ShapeVertices;

        float2 currentVertex,nextVertex,matrixVector;
	sincos(fADOF_ShapeRotation*0.0174533,currentVertex.y,currentVertex.x);
	sincos(Alpha,matrixVector.x,matrixVector.y);

	float2x2 rotMatrix = float2x2(matrixVector.y,-matrixVector.x,matrixVector.x,matrixVector.y);

        #if(bADOF_ShapeWeightEnable != 0)
               res.w = saturate(1.0f-fADOF_ShapeWeightAmount*ringCount);
               res.xyz *= res.w;
	#endif

        #if(bADOF_ShapeChromaEnable != 0 && iADOF_ShapeChromaMode == 0)
                float3 chromaoffsets = GetChromaticAberrationOffsets();
	#endif

	[fastopt]
	for(float iRings = 1; iRings <= ringCount && iRings <= 25; iRings++)
	{
		float radiusCoeff = iRings*ringIncrement;

		[fastopt]
		for (int iVertices = 1; iVertices <= iADOF_ShapeVertices && iVertices <= 9; iVertices++)
		{
			nextVertex = mul(currentVertex.xy, rotMatrix);

			[fastopt]
			for (float iSamplesPerRing = 0; iSamplesPerRing < iRings && iSamplesPerRing < 25; iSamplesPerRing++)
			{
				float2 sampleOffset = lerp(currentVertex,nextVertex,iSamplesPerRing/iRings);
				sampleOffset *= lerp(1.0,rsqrt(dot(sampleOffset,sampleOffset)),fADOF_ShapeCurvatureAmount);

				#if(bADOF_ShapeChromaEnable != 0 && iADOF_ShapeChromaMode == 0)
				        float4 tap = colortexSampleChroma(colortex, coords.xy, (sampleOffset.xy * discRadiusInPixels) * radiusCoeff, chromaoffsets);
				#else
				        float4 tap = colortex.SampleLevel(Sampler1, coords.xy + (sampleOffset.xy * discRadiusInPixels) * radiusCoeff,0);
				#endif

                                #if(iADOF_FocusMode == 0)
                                        #if(iADOF_MaskMode == 0)
				                float tapcoc = tap.w * 2.0 - 1.0;
				                tap.w = (tap.w >= centerDepth * 0.99) ? 1.0 : (tapcoc*tapcoc)*(tapcoc*tapcoc); //why the brackets, you ask?
                                        #elif(iADOF_MaskMode == 1)
                                                float tapradius = abs(tap.w*2.0-1.0) * fADOF_ShapeRadius;
                                                tap.w = (tapradius*2.0 >= discRadius || tap.w < 0.5) ? 1.0 : 0.0;
                                        #endif
                                #elif(iADOF_FocusMode == 1)
                                        tap.w = 1.0;
                                #endif

				#if(bADOF_ShapeWeightEnable != 0)
				tap.w *= lerp(1.0,pow(radiusCoeff,fADOF_ShapeWeightCurve),fADOF_ShapeWeightAmount);
				#endif

				res.xyz += pow(tap.xyz,fADOF_BokehCurve)*tap.w;
				res.w += tap.w;
			}

			currentVertex = nextVertex;
		}
	}
        res.xyz = pow(max(0.0,res.xyz/res.w),rcp(fADOF_BokehCurve));
	return res.xyz;
}

float drawdot(float2 coord, float2 center) {
        return smoothstep(0.0025,0.000,length((coord-center)*float2(1.0,ScreenSize.w)));
}

//modified version for preview window.
float3 BokehBlurPreview(Texture2D colortex, float2 coords, float discRadius, float2 centerofshape) {
        float4 res 			= float4(drawdot(coords.xy,centerofshape).xxx,1.0); //float4(colortex.Sample(Sampler1, coords.xy).xyz, 1.0f);
	int ringCount			= iADOF_ShapeQuality;
	float ringIncrement		= rcp(ringCount);
	float2 discRadiusInPixels	= discRadius*(PixelSize.xy*float2(fADOF_ShapeAnamorphRatio,1.0f));
	float Alpha                     = 6.2831853 / iADOF_ShapeVertices;

        float2 currentVertex,nextVertex,matrixVector;
	sincos(fADOF_ShapeRotation*0.0174533,currentVertex.y,currentVertex.x);
	sincos(Alpha,matrixVector.x,matrixVector.y);

	float2x2 rotMatrix = float2x2(matrixVector.y,-matrixVector.x,matrixVector.x,matrixVector.y);

        #if(bADOF_ShapeWeightEnable != 0)
               res.w = saturate(1.0f-fADOF_ShapeWeightAmount*ringCount);
               res.xyz *= res.w;
	#endif

        #if(bADOF_ShapeChromaEnable != 0 && iADOF_ShapeChromaMode == 0)
                float3 chromaoffsets = GetChromaticAberrationOffsets();
                chromaoffsets = clamp(chromaoffsets,0.85,1.15); //let's not fuck up the window
	#endif

	[fastopt]
	for(float iRings = 1; iRings <= ringCount && iRings <= 25; iRings++)
	{
		float radiusCoeff = iRings*ringIncrement;

		[fastopt]
		for (int iVertices = 1; iVertices <= iADOF_ShapeVertices && iVertices <= 9; iVertices++)
		{
			nextVertex = mul(currentVertex.xy, rotMatrix);

			[fastopt]
			for (float iSamplesPerRing = 0; iSamplesPerRing < iRings && iSamplesPerRing < 25; iSamplesPerRing++)
			{
				float2 sampleOffset = lerp(currentVertex,nextVertex,iSamplesPerRing/iRings);
				sampleOffset *= lerp(1.0,rsqrt(dot(sampleOffset,sampleOffset)),fADOF_ShapeCurvatureAmount);

                                float2 sampleCoord = centerofshape + (sampleOffset.xy * discRadiusInPixels) * radiusCoeff;
                                #if(bADOF_ShapeChromaEnable != 0  && iADOF_ShapeChromaMode == 0)
                                        res.x += drawdot(coords.xy,centerofshape + (sampleOffset.xy * discRadiusInPixels) * radiusCoeff*chromaoffsets.x);
                                        res.y += drawdot(coords.xy,centerofshape + (sampleOffset.xy * discRadiusInPixels) * radiusCoeff*chromaoffsets.y);
                                        res.z += drawdot(coords.xy,centerofshape + (sampleOffset.xy * discRadiusInPixels) * radiusCoeff*chromaoffsets.z);
                                #else
                                        res.xyz += drawdot(coords.xy,sampleCoord);
                                #endif
			}

			currentVertex = nextVertex;
		}
	}
	return saturate(res.xyz);
}


// ------------------- //
//    PIXEL SHADER     //
// ------------------- //

//? -> 1x1 R32F
float4 PS_Aperture(float2 texcoord : TEXCOORD0) : SV_Target {
	//as I don't use aperture and deleting the technique causes weird things to happen, don't waste resources :v
	return 1;
}

//fullres -> 16x16 R32F
float4 PS_ReadFocus(float2 texcoord : TEXCOORD0) : SV_Target {
#if(iADOF_FocusMode == 0)
	float scenefocus 	= fADOF_ManualfocusDepth;
	float2 coords 		= 0.0;

	if(bADOF_AutofocusEnable != 0)
	{
		scenefocus =  saturate(GetLinearDepth(fADOF_AutofocusCenter.xy)/fADOF_InfiniteFocus);
		float2 offsetVector = float2(1.0,0.0) * fADOF_AutofocusRadius;
		float Alpha = 6.2831853 / iADOF_AutofocusSamples;
		float2x2 rotMatrix = float2x2(cos(Alpha),-sin(Alpha),sin(Alpha),cos(Alpha));

		for(int i=0; i<iADOF_AutofocusSamples; i++)
		{
			float2 currentOffset = fADOF_AutofocusCenter + offsetVector.xy;
			scenefocus += saturate(GetLinearDepth(currentOffset)/fADOF_InfiniteFocus);
			offsetVector = mul(offsetVector,rotMatrix);
		}

		scenefocus /= iADOF_AutofocusSamples;
	}

	scenefocus = saturate(scenefocus);
	return scenefocus;
#endif
        return 0.0;
}

//16x16 -> 1x1 R32F
float4 PS_Focus(float2 texcoord : TEXCOORD0) : SV_Target {
        #if(iADOF_FocusMode == 0)
	       float prevFocus = TexturePrevious.Sample(Sampler1, texcoord.xy).x;
	       float currFocus = TextureCurrent.Sample(Sampler1, texcoord.xy).x;

                float res = 0.0f;
                res = lerp(prevFocus,currFocus,DofParameters.w);
                #if(bADOF_AutofocusSmoothingEnable != 0)
                        if(prevFocus < currFocus) res = lerp(prevFocus,currFocus,DofParameters.w*lerp(0.03f,0.35f,saturate(currFocus/prevFocus)) / pow(2.5f,fADOF_FarBlurCurve));
                #endif
	       res = saturate(res);
	       return res;
        #endif
        return 0.0f;
}

float4 PS_CoC(float2 texcoord : TEXCOORD0) : SV_Target {
	return float4(RemoveFireflies(TextureColor, texcoord).xyz,GetCoC(texcoord.xy));
}

float4 PS_DoF_Main(float2 texcoord : TEXCOORD0) : SV_Target {
	float2 scaledcoord = texcoord.xy / fADOF_RenderResolutionMult;
        clip(!all(saturate(-scaledcoord * scaledcoord + scaledcoord)) ? -1:1);

	float4 scenecolor = TextureColor.Sample(Sampler1, scaledcoord.xy);

	float centerDepth = scenecolor.w;
	float blurAmount = abs(centerDepth * 2.0 - 1.0);
	float discRadius = blurAmount * fADOF_ShapeRadius;

        #if(iADOF_FocusMode == 0)
	       discRadius*=(centerDepth < 0.5) ? (1.0 / max(fADOF_NearBlurCurve * 2.0, 1.0)) : 1.0;
        #endif

        clip((discRadius<1.0)?-1:1);

	scenecolor.xyz = BokehBlur(TextureColor,scaledcoord.xy, discRadius, centerDepth);
	scenecolor.w = centerDepth;

	return scenecolor;
}

float4 PS_DoF_Combine(float2 texcoord : TEXCOORD0) : SV_Target {
	float4 blurredcolor 		= TextureColor.Sample(Sampler1, texcoord.xy*fADOF_RenderResolutionMult);
	float4 unblurredcolor		= TextureOriginal.Sample(Sampler1, texcoord.xy);
	float4 scenecolor		= 0.0;
	float centerDepth		= GetCoC(texcoord.xy);

	float discRadius = abs(centerDepth * 2.0 - 1.0) * fADOF_ShapeRadius;
        #if(iADOF_FocusMode == 0)
	       discRadius*=(centerDepth < 0.5) ? (1.0 / max(fADOF_NearBlurCurve * 2.0, 1.0)) : 1.0;
        #endif
	//1.0 + 0.05 epsilon because discard at 1.0 in PS_DoF_Main
	scenecolor.xyz = lerp(blurredcolor.xyz, unblurredcolor.xyz,smoothstep(4.0,1.05,discRadius));
        scenecolor.w = centerDepth;

	return scenecolor;
}

float4 PS_DoF_Smoothen(float2 texcoord : TEXCOORD0) : SV_Target {
	float4 scenecolor 		= TextureColor.Sample(Sampler1, texcoord.xy);

	float centerDepth = scenecolor.w;
	float blurAmount = abs(centerDepth * 2.0 - 1.0);
	float blurFactor = smoothstep(0.0,0.15,blurAmount)*fADOF_SmootheningAmount;

	scenecolor = 0.0;

	float offsets[5] = {-3.2307692308, -1.3846153846, 0.0, 1.3846153846, 3.2307692308};
	float weights[3] = {0.2270270270, 0.3162162162, 0.0702702703};

	float chromaamount = 1.3;

	for(int x=-2; x<=2; x++)
	for(int y=-2; y<=2; y++)
	{
		float2 coord = float2(x,y);
		float2 actualoffset = float2(offsets[x+2],offsets[abs(y+2)])*blurFactor*PixelSize.xy;
		float weight = weights[abs(x)] * weights[abs(y)];

                float4 tap = TextureColor.SampleLevel(Sampler1, texcoord.xy + actualoffset,0);
                float tapblurAmount = abs(tap.w * 2.0 - 1.0);
                #if(iADOF_FocusMode == 0)
                        weight *= smoothstep(-0.0001,0.0,tapblurAmount-blurAmount);
                #endif
                scenecolor.xyz += tap.xyz * weight;
                scenecolor.w += weight;
	}
	scenecolor.xyz /= scenecolor.w;

        #if(bADOF_ShapeChromaEnable == 0 || iADOF_ShapeChromaMode == 0)
                if(bADOF_ShapePreviewWindowEnable)
                {
                        float2 newcoord = 1.0 - texcoord.xy;
                        newcoord.x *= ScreenSize.z;
                        scenecolor.xyz *= max(smoothstep(0.2,0.21,newcoord.x),smoothstep(0.2,0.21,newcoord.y));
                        scenecolor.xyz += BokehBlurPreview(TextureColor, texcoord.xy, 0.023*ScreenSize.x*ScreenSize.z, 1.0 - float2(0.1*ScreenSize.w,0.1));
                }
        #endif

        scenecolor.w = centerDepth;
	return scenecolor;
}

float4 PS_DoF_PostChroma(float2 texcoord : TEXCOORD0) : SV_Target {
	float4 scenecolor 		= TextureColor.Sample(Sampler1, texcoord.xy);
        float centerDepth = scenecolor.w;
        float discRadius = abs(centerDepth * 2.0 - 1.0) * fADOF_ShapeRadius;
        #if(iADOF_FocusMode == 0)
               discRadius*=(centerDepth < 0.5) ? (1.0 / max(fADOF_NearBlurCurve * 2.0, 1.0)) : 1.0;
        #endif

        //this basically calculates the gradient of the luma height field
        //to determine where big changes in luma are (bokeh shape borders)
        //and shifts colors perpendiculary to these borders.
        //First blur, then chroma, otherwise separated samples of bokeh filter
        //might screw up sample directions.

        float sampleL,sampleT,sampleC;
        float3 sampleOffset = float3(PixelSize.xy,0.0);

        sampleL = dot(0.333,TextureColor.Sample(Sampler1,texcoord.xy - sampleOffset.xz).xyz);
        sampleT = dot(0.333,TextureColor.Sample(Sampler1,texcoord.xy - sampleOffset.zy).xyz);
        sampleC = dot(0.333,scenecolor.xyz);

        float2 derivativeXY = float2(sampleC-sampleL,sampleC-sampleT) / sampleOffset.xy;

        float normalScale = saturate(4.0 * sampleC)*0.7;
        float3 embossNormal = normalize(float3(derivativeXY,rcp(normalScale)));

        float2 gradientVector = normalize(embossNormal.xy); //actually -res but who cares...

        float4 chromasample[2] = {TextureColor.Sample(Sampler1, texcoord.xy + gradientVector.xy * PixelSize.xy * discRadius * fADOF_ShapeChromaAmount * 0.5), //match mode 0
                                  TextureColor.Sample(Sampler1, texcoord.xy - gradientVector.xy * PixelSize.xy * discRadius * fADOF_ShapeChromaAmount * 0.5)};

        chromasample[0].xyz = lerp(scenecolor.xyz,chromasample[0].xyz,saturate(abs(chromasample[0].w*4.0-2.0)));
        chromasample[1].xyz = lerp(scenecolor.xyz,chromasample[1].xyz,saturate(abs(chromasample[1].w*4.0-2.0)));

        //todo: restructure order to match mode 0 definition
        #if(  iADOF_ShapeChromaOrder == 2)
                scenecolor.xyz = float3(scenecolor.x,chromasample[0].z,chromasample[1].y).xzy;
        #elif(iADOF_ShapeChromaOrder == 3)
                scenecolor.xyz = float3(scenecolor.y,chromasample[0].x,chromasample[1].z).yxz;
        #elif(iADOF_ShapeChromaOrder == 4)
                scenecolor.xyz = float3(scenecolor.z,chromasample[0].y,chromasample[1].x).zyx;
        #elif(iADOF_ShapeChromaOrder == 5)
                scenecolor.xyz = float3(scenecolor.z,chromasample[0].x,chromasample[1].y).yzx;
        #elif(iADOF_ShapeChromaOrder == 6)
                scenecolor.xyz = float3(scenecolor.y,chromasample[0].z,chromasample[1].x).zxy;
        #else
                scenecolor.xyz = float3(scenecolor.x,chromasample[0].y,chromasample[1].z).xyz;
        #endif

        //#if(bADOF_ShapeChromaEnable != 0 && iADOF_ShapeChromaMode == 1) //checked for in tech section already
        if(bADOF_ShapePreviewWindowEnable)
        {
                float2 newcoord = 1.0 - texcoord.xy;
                newcoord.x *= ScreenSize.z;
                scenecolor.xyz *= max(smoothstep(0.2,0.21,newcoord.x),smoothstep(0.2,0.21,newcoord.y));
                scenecolor.xyz += BokehBlurPreview(TextureColor, texcoord.xy, 0.023*ScreenSize.x*ScreenSize.z, 1.0 - float2(0.1*ScreenSize.w,0.1));
        }
        //#endif

	return scenecolor;
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

/// Aperture and Focus
technique11 Aperture {   /// Write aperture with time factor, this is always first technique
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
    SetPixelShader(CompileShader(ps_5_0, PS_Aperture()));
  }
}

technique11 ReadFocus {  /// Compute focus from depth of screen and may be brightness, this is always second technique´
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
    SetPixelShader(CompileShader(ps_5_0, PS_ReadFocus()));
  }
}

technique11 Focus {      /// Write focus with time factor, this is always third technique
  pass p0 {
    SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
    SetPixelShader(CompileShader(ps_5_0, PS_Focus()));
  }
}

/// Depth of Field
technique11 DOF <string UIName="Marty McFly's ADOF";> {
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_CoC()));
	}
}

technique11 DOF1 {
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_DoF_Main()));
	}
}

technique11 DOF2 {
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_DoF_Combine()));
	}
}

technique11 DOF3 {
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_DoF_Smoothen()));
	}
}

#if(bADOF_ShapeChromaEnable != 0 && iADOF_ShapeChromaMode == 1)
technique11 DOF4 {
	pass p0 {
		SetVertexShader(CompileShader(vs_5_0, VS_DOF()));
		SetPixelShader(CompileShader(ps_5_0, PS_DoF_PostChroma()));
	}
}
#endif