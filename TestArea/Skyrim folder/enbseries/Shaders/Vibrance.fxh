//=======================//
// Vibrance by Ceejay.dk //
//=======================//

float3 Vibrance(float3 color)
{

	if (USE_Vibrance==true)
	{
    float Vibrance              =lerp( lerp(Vibrance_Night,             Vibrance_Day,             ENightDayFactor), Vibrance_Interior,             EInteriorFactor );
    float3 VibranceRGBBalance   =lerp( lerp(VibranceRGBBalance_Night,   VibranceRGBBalance_Day,   ENightDayFactor), VibranceRGBBalance_Interior,   EInteriorFactor );
  
	const float3 coefLuma = float3(0.212656, 0.715158, 0.072186);
	float luma = dot(coefLuma, color);

	float max_color = max(color.r, max(color.g, color.b)); // Find the strongest color
	float min_color = min(color.r, min(color.g, color.b)); // Find the weakest color

	float color_saturation = max_color - min_color; // The difference between the two is the saturation

	// Extrapolate between luma and original by 1 + (1-saturation) - current
	float3 coeffVibrance = float3(VibranceRGBBalance * Vibrance);
	color = lerp(luma, color, 1.0 + (coeffVibrance * (1.0 - (sign(coeffVibrance) * color_saturation))));
    }
	return color;
}
