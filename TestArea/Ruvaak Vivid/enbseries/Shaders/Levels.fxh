/**
 * Levels version 1.6.6 MPC Edition lite
 * Original version by Christian Cann Schuldt Jensen ~ CeeJay.dk
 * Updated to 1.3+ by Kirill Yarovoy ~ v00d00m4n
 *
 * Allows you to set a new black and a white level.
 * This increases contrast, but clips any colors outside the new range to either black or white
 * and so some details in the shadows or highlights can be lost.
 *
 * The shader is very useful for expanding the 16-235 TV range to 0-255 PC range.
 * You might need it if you're playing a game meant to display on a TV with an emulator that does not do this.
 * But it's also a quick and easy way to uniformly increase the contrast of an image.
 *
 * -- Version 1.0 --
 * First release
 * -- Version 1.1 --
 * Optimized to only use 1 instruction (down from 2 - a 100% performance increase :) )
 * -- Version 1.2 --
 * Added the ability to highlight clipping regions of the image with #define HighlightClipping 1
 * 
 * -- Version 1.3 --
 * Added inddependant RGB channel levels that allow to fix impropely balanced console specific color space.
 *
 * -- Version 1.4 --
 * Added ability to upshift color range before expanding it. Needed to fix stupid Ubisoft mistake in Watch Dogs 2 where they
 * somehow downshifted color range.
 * 
 * -- Version 1.5 --
 * Changed formulas to allow gamma and output range controls.
 * 
 * -- Version 1.6 --
 * Added ACES curve, to avoid clipping.
 * 
 * -- Version 1.6.5 --
 * Ported for MPC, cleaned out broken and debug stuff.
 * 
 * -- Version 1.6.6 --
 * Made ACES useful and configurable.
 */


float4 Levels(float3 InputColor)
{
    float3 OutputColor;
  
    float3 InputBlackPoint   =lerp( lerp(InputBlackPoint_Night,   InputBlackPoint_Day,   ENightDayFactor), InputBlackPoint_Interior,   EInteriorFactor );
    float3 InputWhitePoint   =lerp( lerp(InputWhitePoint_Night,   InputWhitePoint_Day,   ENightDayFactor), InputWhitePoint_Interior,   EInteriorFactor );
    float3 InputGamma        =lerp( lerp(InputGamma_Night,        InputGamma_Day,        ENightDayFactor), InputGamma_Interior,        EInteriorFactor );
    float3 OutputBlackPoint  =lerp( lerp(OutputBlackPoint_Night,  OutputBlackPoint_Day,  ENightDayFactor), OutputBlackPoint_Interior,  EInteriorFactor );
    float3 OutputWhitePoint  =lerp( lerp(OutputWhitePoint_Night,  OutputWhitePoint_Day,  ENightDayFactor), OutputWhitePoint_Interior,  EInteriorFactor );
  
    OutputColor = pow(((InputColor ) - InputBlackPoint)/(InputWhitePoint - InputBlackPoint) , InputGamma) * (OutputWhitePoint - OutputBlackPoint) + OutputBlackPoint;


	return float4(OutputColor, 1.0);
}