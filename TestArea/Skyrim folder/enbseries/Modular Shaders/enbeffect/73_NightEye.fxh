//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//              Contains Night Eye effects             //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// Matso: Author of Night Eye warping & implementation //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file is specifically only for use in the enbeffect.fx!
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

int NE  <string UIName="------------------------NIGHT EYE";  string UIWidget="Spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_NE < string UIName = "NE: Enable"; > = {false};
    float fNEMixMultDay < string UIName="NE: Mix Day";            string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0};
    float fNEMixMultNight < string UIName="NE: Mix Night";        string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0};
    float fNEMixMultInterior < string UIName="NE: Mix Interior";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0};

int NE2 < string UIName="VIGNETTE------------------------------NIGHT EYE";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
  bool ENABLE_NE_VIGNETTE < string UIName = "NE: Vignette Enable"; > = {true};
    float fNEVignetteMinDistance < string UIName="NE: Vignette Min Distance";        string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {0.5};
    float fNEVignetteMaxDistance < string UIName="NE: Vignette Max Distance";        string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {0.9};
    float fNEVignetteDistancePower < string UIName="NE: Vignette Distance Power";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.5};
    float fNEVignetteAspectRatio < string UIName="NE: Vignette Aspect Ratio Power";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0};

int NE3 < string UIName="COLOR CORRECTION----------------NIGHT EYE";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
  bool ENABLE_NE_CC < string UIName = "NE: CC Enable"; > = {false};
    float fNEBrightness < string UIName="NE: Brightness";   string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=100.0; > = {1.0};
    float fNEUpperTone < string UIName="NE: Upper Tone";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0};
//    float fNEGreyPoint < string UIName="NE: Grey Point";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=1.0; > = {1.0};
    float fNEMiddleTone < string UIName="NE: Middle Tone";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=25.0; > = {1.0};
    float fNELowerTone < string UIName="NE: Lower Tone";    string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=10.0; > = {1.0};
    float3 fNETint < string UIName="NE: Tint RGB";          string UIWidget="Color"; > = {0.5, 1.0, 1.0};
    float fNEVignetteValueMult < string UIName="NE: Vignette Value Mult";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=100.0; > = {0.6};
    float fNEVignetteMaskMult < string UIName="NE: Vignette Mask Mult";    string UIWidget="Spinner";  float UIMin=-100.0;  float UIMax=100.0; > = {1.0};

int NE8 < string UIName="DEBUG----------------------------------NIGHT EYE";   string UIWidget="Spinner";  int UIMin=0;  int UIMax=0; > = {0};
  bool ENABLE_NE_DEBUG < string UIName = "NE: Debug"; > = {false};
    float fNEparamsOffset_ED < string UIName="NE: Params01[3].w Offset [E-D]";  string UIWidget="Spinner";  float UIMin=-100.0;  float UIMax=100.0; > = {-1.3};
    float fNEparamsOffset_EN < string UIName="NE: Params01[3].w Offset [E-N]";  string UIWidget="Spinner";  float UIMin=-100.0;  float UIMax=100.0; > = {-1.3};
    float fNEparamsOffset_I < string UIName="NE: Params01[3].w Offset [I]";  string UIWidget="Spinner";  float UIMin=-100.0;  float UIMax=100.0; > = {-1.3};
    float fNEparamsMult_ED < string UIName="NE: Params01[3].w Mult [E-D]";      string UIWidget="Spinner";  float UIMin=-100.0;  float UIMax=100.0; > = {5.0};
    float fNEparamsMult_EN < string UIName="NE: Params01[3].w Mult [E-N]";      string UIWidget="Spinner";  float UIMin=-100.0;  float UIMax=100.0; > = {5.0};
    float fNEparamsMult_I < string UIName="NE: Params01[3].w Mult [I]";      string UIWidget="Spinner";  float UIMin=-100.0;  float UIMax=100.0; > = {5.0};


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //




// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //


// NIGHT EYE SETUP
float4 msNightEyeSetup(float4 color, float eAdapt, float2 txcoord0) {
/// Time and Location interpolators
  float fNEparamsOffset = lerp(lerp(fNEparamsOffset_EN, fNEparamsOffset_ED, ENightDayFactor), fNEparamsOffset_I, EInteriorFactor);
  float fNEparamsMult = lerp(lerp(fNEparamsMult_EN, fNEparamsMult_ED, ENightDayFactor), fNEparamsMult_I, EInteriorFactor);


      float2 unwarpedTxCoord = txcoord0.xy;
      float aspectRatio = ScreenSize.z;

        // The Params01[3].w value is from the game, and needs to be manipulated
        // as below to get a value from 0 (night eye off) to 1 (night eye on).
        // The Day, Night, and Interior GUI controls can be used to tune this.
		float3 nightEyeNormalized = clamp(Params01[3].w + fNEparamsOffset, 0.0, 1.0) * fNEparamsMult;

		// Interpolate night/day/interior
		float nightEyeMixMult;
		nightEyeMixMult = fNEMixMultDay * ENightDayFactor + 
			fNEMixMultNight * (1.0 - ENightDayFactor);
		nightEyeMixMult = fNEMixMultInterior * EInteriorFactor + 
			nightEyeMixMult * (1.0 - EInteriorFactor);
		float nightEyeT = clamp(nightEyeMixMult * nightEyeNormalized, 0.0, 1.0);


// NIGHTEYE IMPLEMENTATION
		[branch] if(ENABLE_NE) {
			float vignette = 0.0;

			[branch] if(ENABLE_NE_VIGNETTE) { //  Add Vignette
				float2 vignetteTxCoord = txcoord0.xy;
				float2 center = float2(0.5, 0.5);
				float2 txCorrected = float2((vignetteTxCoord.x - center.x) * 
					aspectRatio / fNEVignetteAspectRatio + center.x, vignetteTxCoord.y);
				float dist;

					dist = distance(txCorrected, center);

				float distT = linStep(fNEVignetteMinDistance, fNEVignetteMaxDistance, dist);
				vignette = pow(distT, fNEVignetteDistancePower);
			}

			[branch] if(ENABLE_NE_CC) { // Color Correct
              float4 nightEye = color;

            /// RGB color tint
                float3 colorFactor = 0.0;
                  colorFactor.r = lerp(fNETint.x, Params01[5].x, eAdapt);
                  colorFactor.g = lerp(fNETint.y, Params01[5].y, eAdapt);
                  colorFactor.b = lerp(fNETint.z, Params01[5].z, eAdapt);

                float3 newColor = colorFactor;
                float3 oldColor = nightEye.rgb;
                  nightEye.rgb *= newColor;
                  nightEye.rgb += (oldColor.r - (oldColor.r * newColor.r)) * 0.2125f;  // Luma Coeffiecent value: RED
                  nightEye.rgb += (oldColor.g - (oldColor.g * newColor.g)) * 0.7154f;  // Luma Coeffiecent value: GREEN
                  nightEye.rgb += (oldColor.b - (oldColor.b * newColor.b)) * 0.0721f;  // Luma Coeffiecent value: BLUE

            /// Intensity
                  nightEye.rgb *= fNEBrightness;

            /// Tonemapping Curve
                  nightEye.rgb = (nightEye.rgb * (fNEUpperTone * nightEye.rgb + (1 + eAdapt))) / (nightEye.rgb * (fNEUpperTone + fNEMiddleTone) + fNELowerTone);  /// Tonemapping with Highlight and Shadow controls as well as "max allowed brightness"

            /// Mask above effects with Vignette
                float mask = vignette;
                if(fNEVignetteMaskMult < 0) mask = -1.0 * (1.0 - vignette);
                  mask *= fNEVignetteMaskMult;
                  nightEye *= (1.0 - mask) + (mask * fNEVignetteValueMult);

              color.xyz = saturate((nightEye.xyz * nightEyeT) + (color.xyz * (1.0 - nightEyeT)));
			}

			[branch] if(ENABLE_NE_DEBUG) { //  Debug 
				if(unwarpedTxCoord.x > 0.95) {
					if(unwarpedTxCoord.y < 0.1) color.xyz = Params01[3].w; 
					else if(unwarpedTxCoord.y > 0.15 && unwarpedTxCoord.y < 0.25) color.xyz = nightEyeNormalized;
					else if(unwarpedTxCoord.y > 0.3 && unwarpedTxCoord.y < 0.4) color.xyz = nightEyeT;
				}
			}
		}

  return color;
}
