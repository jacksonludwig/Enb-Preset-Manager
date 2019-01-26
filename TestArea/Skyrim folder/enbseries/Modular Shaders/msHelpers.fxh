//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//       Contains helper functions and constants       //
//           used by the Modular Shader files          //
//-----------------------CREDITS-----------------------//
// JawZ: Author and developer of MSL                   //
// Erik Reinhard: Photographic Tone Reproduction       //
// Michael Stark: Photographic Tone Reproduction       //
// Peter Shirley: Photographic Tone Reproduction       //
// James Ferwerda: Photographic Tone Reproduction      //
// easyrgb.com: Example of the RGB>XYZ>Yxy color space //
// Charles Poynton: Color FAQ                          //
// Prod80: For code inspiration and general help       //
// kingeric1992: For codes, inspiration and help       //
// CeeJay.dk: Split Screen                             //
// Matso: Texture atlas tiles sampling system          //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//


// This helper file can be included in any ENBSeries .fx and .txt shader file.


// ------------------- //
//   GUI ANNOTATIONS   //
// ------------------- //


// ------------------- //
//   HELPER CONSTANTS  //
// ------------------- //

// PI, required to calculate Gaussian weight
  static const float PI = 3.1415926535897932384626433832795;

  
#define TOD_SUNRISE_TIME  7.0
#define TOD_DAY_TIME      13.0
#define TOD_SUNSET_TIME   19.0
#define TOD_NIGHT_TIME    1.0
#define TOD_DAWN_DURATION 2.0
#define TOD_DUSK_DURATION 2.0
	
	
// Matso texture atlas tiles sampling system
/// Size of a tile (in a fraction of the whole texture) defines a number of tiles fitted into a texture.
/// Number of tiles is given as a power of 2 of given, user defined number (tiles granularity). For granularity 3 we have 9 tiles.
/// Tiles, like any texture coordinates, are addressed from lower-left corner of an image, meaning float2(0, 0) is first tile on the bottom-left of the atlas.
#define fAtlasTilesGranularitySym  1.0                 // Number of tiles per row/column - NEVER ZERO!!!!!!!!!
#define fAtlasTilesGranularityAsy  float2(1.0, 1.0)    // Number of tiles per row and column accordingly - NEVER ZERO!!!!!!!!!
#define GetAtlasAddress            GetAtlasAddressSym  // Aliases

// ------------------- //
//   HELPER FUNCTIONS  //
// ------------------- //

// Returns (TOD factor sunrise, TOD factor day, TOD factor sunset, TOD factor night)
float4 TODfactors() {
  float4 weight = Weather.w;

    weight.xy -= TOD_SUNRISE_TIME;
    weight.zw -= TOD_SUNSET_TIME;
    weight    /= float4(-TOD_DAWN_DURATION, TOD_DAY_TIME - TOD_SUNRISE_TIME, TOD_DAY_TIME - TOD_SUNSET_TIME, TOD_DUSK_DURATION); 
    weight     = saturate(weight);
    weight.yz  = sin(weight.yz * 1.57);// pi/2
    weight.xw  = 1 - weight.xw;

  return float4( weight.x*(1-weight.y), weight.y*weight.z, (1-weight.z)*weight.w, 1-weight.w*weight.x);
}

// Hack value used in Interior specific factor functions
float InteriorFactor(float4 Params013) {
/// Similar to EInteriorFactor

/// Implementation example;
///   float fBrightness = lerp(Exterior, Interior, InteriorFactor(Params013[3]))
///   color.xyz *= fBrightness;

    float valIntDunHack=0;
    if (Params013.w>=1.000190 && Params013.w<=1.000210) valIntDunHack=1;  /// Interior, Params013[3].w - Brightness

  return valIntDunHack;
}

// Hack value used in Dungeon specific factor functions
float DungeonFactor(float4 Params013) {
/// Similar to EInteriorFactor

/// Implementation example;
///   float fBrightness = lerp(InteriorExterior, Dungeon, DungeonFactor(Params013[3]))
///   color.xyz *= fBrightness;

    float valIntDunHack=0;
    if (Params013.w>=1.000090 && Params013.w<=1.000110) valIntDunHack=1;  /// Dungeon, Params013[3].w - Contrast

  return valIntDunHack;
}

// TOD Factor, using TimeOfDay1&2
float TOD(float4 TODE1, float2 TODE2) {
/// Splits a variable into Dawn, Sunrise, Day, Sunset, Dusk and Night variables
/// As well as seperating them between Exterior and Interior locations

/// Implementation example;
///   float fBrightness = TOD1(fBrightness_1, fBrightness_2);
///   color.xyz *= fBrightness;

/// Creates these variables, with 1 component;
/// Exterior - Dawn, Sunrise, Day, Sunset, Dusk, Night

  float timeweight=0.000001;
  float timevalue=0.0;

	timevalue += TimeOfDay1.x * TODE1.x; // Dawn
	timevalue += TimeOfDay1.y * TODE1.y; // Sunrise
	timevalue += TimeOfDay1.z * TODE1.z; // Day
	timevalue += TimeOfDay1.w * TODE1.w; // Sunset
	timevalue += TimeOfDay2.x * TODE2.x; // Dusk
	timevalue += TimeOfDay2.y * TODE2.y; // Night

	timeweight += TimeOfDay1.x;
	timeweight += TimeOfDay1.y;
	timeweight += TimeOfDay1.z;
	timeweight += TimeOfDay1.w;
	timeweight += TimeOfDay2.x;
	timeweight += TimeOfDay2.y;

  return (timevalue / timeweight);
}

// TOD Factor, using TimeOfDay1&2
float TODe41i41d41(float4 Params013, float4 TODE, float4 TODI, float4 TODD) {
/// Splits a variable into Dawn, Sunrise, Day, Sunset, Dusk and Night variables
/// As well as seperating them between Exterior and Interior locations

/// Implementation example;
///   float fBrightness = TOD2(Params013[3], fBrightness_E, fBrightness_I, fBrightness_D);
///   color.xyz *= fBrightness;

/// Creates these variables, with 1 component;
/// Exterior - Sunrise, Day, Sunset, Night
/// Interior - Sunrise, Day, Sunset, Night
/// Dungeon  - Sunrise, Day, Sunset, Night

  float3 timeweight = 0.000001;
  float3 timevalue = 0.0;

  // Exterior
	timevalue.x += TimeOfDay1.y * TODE.x; // Sunrise
	timevalue.x += TimeOfDay1.z * TODE.y; // Day
	timevalue.x += TimeOfDay1.w * TODE.z; // Sunset
	timevalue.x += TimeOfDay2.y * TODE.w; // Night

  // Interior
	timevalue.y += TimeOfDay1.y * TODI.x; // Sunrise
	timevalue.y += TimeOfDay1.z * TODI.y; // Day
	timevalue.y += TimeOfDay1.w * TODI.z; // Sunset
	timevalue.y += TimeOfDay2.y * TODI.w; // Night

  // Dungeon
	timevalue.z += TimeOfDay1.y * TODD.x; // Sunrise
	timevalue.z += TimeOfDay1.z * TODD.y; // Day
	timevalue.z += TimeOfDay1.w * TODD.z; // Sunset
	timevalue.z += TimeOfDay2.y * TODD.w; // Night

	timeweight += TimeOfDay1.y;
	timeweight += TimeOfDay1.z;
	timeweight += TimeOfDay1.w;
	timeweight += TimeOfDay2.y;

  return lerp(lerp((timevalue.x / timeweight.x), (timevalue.y / timeweight.y), EInteriorFactor), (timevalue.z / timeweight.z), DungeonFactor(Params013));
}

// TOD Factor, using TimeOfDay1&2
float TODe41i11d11(float4 Params013, float4 TODE, float INT, float DUN) {
/// Splits a variable into Dawn, Sunrise, Day, Sunset, Dusk and Night variables
/// As well as adding Interior and Dungeon variables with Night and Day seperation

/// Implementation example;
///   float fBrightness = TOD3(Params013[3], fBrightness_E, fBrightness_I, fBrightness_D);
///   color.rgb *= fBrightness;

/// Creates these variables, with 1 component;
/// Exterior - Sunrise, Day, Sunset, Night
/// Interior
/// Dungeon

  float timeweight=0.000001;
  float timevalue=0.0;

  // Exterior
	timevalue += TimeOfDay1.y * TODE.x; // Sunrise
	timevalue += TimeOfDay1.z * TODE.y; // Day
	timevalue += TimeOfDay1.w * TODE.z; // Sunset
	timevalue += TimeOfDay2.y * TODE.w; // Night

	timeweight += TimeOfDay1.y;
	timeweight += TimeOfDay1.z;
	timeweight += TimeOfDay1.w;
	timeweight += TimeOfDay2.y;

  return lerp(lerp((timevalue / timeweight), INT, EInteriorFactor), DUN, DungeonFactor(Params013));
}

// TOD Factor, using TimeOfDay1&2
float TODe41i21d21(float4 Params013, float4 TODE, float2 INT, float2 DUN) {
/// Splits a variable into Dawn, Sunrise, Day, Sunset, Dusk and Night variables
/// As well as adding Interior and Dungeon variables with Night and Day seperation

/// Implementation example;
///   float fBrightness = TOD3(Params013[3], fBrightness_E, fBrightness_I, fBrightness_D);
///   color.rgb *= fBrightness;

/// Creates these variables, with 1 component;
/// Exterior - Sunrise, Day, Sunset, Night
/// Interior - Day, Night
/// Dungeon - Day, Night

  float timeweight=0.000001;
  float timevalue=0.0;

  // Exterior
	timevalue += TimeOfDay1.y * TODE.x; // Sunrise
	timevalue += TimeOfDay1.z * TODE.y; // Day
	timevalue += TimeOfDay1.w * TODE.z; // Sunset
	timevalue += TimeOfDay2.y * TODE.w; // Night

	timeweight += TimeOfDay1.y;
	timeweight += TimeOfDay1.z;
	timeweight += TimeOfDay1.w;
	timeweight += TimeOfDay2.y;

  return lerp(lerp((timevalue / timeweight), lerp(INT.y, INT.x, ENightDayFactor), EInteriorFactor), lerp(DUN.y, DUN.x, ENightDayFactor), DungeonFactor(Params013));
}

// TOD Factor, using TimeOfDay1&2
float3 TODe43i13d13(float4 Params013, float3 TODE_Sr, float3 TODE_D, float3 TODE_Ss, float3 TODE_N, float3 INT, float3 DUN) {
/// Splits a variable into Dawn, Sunrise, Day, Sunset, Dusk and Night variables
/// As well as adding Interior and Dungeon variables with Night and Day seperation

/// Implementation example;
///   float fBrightness = TOD3(Params013[3], fBrightness_ESr, fBrightness_ED, fBrightness_Sr, fBrightness_N, fBrightness_ID, fBrightness_IN, fBrightness_DD, fBrightness_DN);
///   color.rgb *= fBrightness;

/// Creates these variables, with 3 components;
/// Exterior - Sunrise.rgb, Day.rgb, Sunset.rgb, Night.rgb
/// Interior.rgb
/// Dungeon.rgb

  float3 timeweight = 0.000001;
  float3 timevalue = 0.0;

  // Exterior
	timevalue += TimeOfDay1.y * TODE_Sr; // Sunrise
	timevalue += TimeOfDay1.z * TODE_D;  // Day
	timevalue += TimeOfDay1.w * TODE_Ss; // Sunset
	timevalue += TimeOfDay2.y * TODE_N;  // Night

	timeweight += TimeOfDay1.y;
	timeweight += TimeOfDay1.z;
	timeweight += TimeOfDay1.w;
	timeweight += TimeOfDay2.y;

  return lerp(lerp((timevalue / timeweight), INT, EInteriorFactor), DUN, DungeonFactor(Params013));
}

// TOD Factor, using TimeOfDay1&2
float4 TODe44i14d14(float4 Params013, float4 TODE_Sr, float4 TODE_D, float4 TODE_Ss, float4 TODE_N, float4 INT, float4 DUN) {
/// Splits a variable into Dawn, Sunrise, Day, Sunset, Dusk and Night variables
/// As well as adding Interior and Dungeon variables with Night and Day seperation

/// Implementation example;
///   float fBrightness = TOD3(Params013[3], fBrightness_ESr, fBrightness_ED, fBrightness_Sr, fBrightness_N, fBrightness_ID, fBrightness_IN, fBrightness_DD, fBrightness_DN);
///   color.rgb *= fBrightness;

/// Creates these variables, with 4 components;
/// Exterior - Sunrise.rgba, Day.rgba, Sunset.rgba, Night.rgba
/// Interior - Sunrise.rgba, Day.rgba, Sunset.rgba, Night.rgba
/// Dungeon  - Sunrise.rgba, Day.rgba, Sunset.rgba, Night.rgba

  float4 timeweight = 0.000001;
  float4 timevalue = 0.0;

  // Exterior
	timevalue += TimeOfDay1.y * TODE_Sr; // Sunrise
	timevalue += TimeOfDay1.z * TODE_D;  // Day
	timevalue += TimeOfDay1.w * TODE_Ss; // Sunset
	timevalue += TimeOfDay2.y * TODE_N;  // Night

	timeweight += TimeOfDay1.y;
	timeweight += TimeOfDay1.z;
	timeweight += TimeOfDay1.w;
	timeweight += TimeOfDay2.y;

  return lerp(lerp((timevalue / timeweight), INT, EInteriorFactor), DUN, DungeonFactor(Params013));
}

// Exterior, Interior and Dungeon Factor
float EID1(float4 Params013, float Ext, float Int, float Dun) {
/// Using hack values that is only available through the use of ELE/Enhanced Lighting for ENB
/// Without ELE the Dungeon factor will not function.

/// Implementation example;
///   float fBrightness = TOD3(Params013[3], fBrightness_E, fBrightness_I, fBrightness_D);
///   color.rgb *= fBrightness;

/// Creates these variables, with 1 component;
/// Exterior, Interior, Dungeon

  return lerp(lerp(Ext, Int, EInteriorFactor), Dun, DungeonFactor(Params013));
}

// TOD Factor, using Weather.w / Weather time
float TODWe41i41d41(float4 Params013, float4 Ext, float4 Int, float4 Dun) {
/// Splits a variable into Sunrise, Day, Sunset and night variables
/// As well as seperating them between Exterior, Interior and Dungeon locations
/// Using hack values that is only available through the use of ELE/Enhanced Lighting for ENB
/// Without ELE the Dungeon factor will not function.

/// Implementation example;
///   float fBrightness = TOD3(Params013[3], fBrightness_E, fBrightness_I, fBrightness_D);
///   color.rgb *= fBrightness;

/// Creates these variables, with 1 component;
/// Exterior - Sunrise, Day, Sunset, Night
/// Interior - Sunrise, Day, Sunset, Night
/// Dungeon  - Sunrise, Day, Sunset, Night

  return lerp(lerp(dot(TODfactors(), Ext), dot(TODfactors(), Int), EInteriorFactor), dot(TODfactors(), Dun), DungeonFactor(Params013));
}

// TOD Factor, using Weather.w / Weather time
float TODWe41i11d11(float4 Params013, float4 Ext, float Int, float Dun) {
/// Splits a variable into Sunrise, Day, Sunset and night variables
/// As well as seperating them between Exterior, Interior and Dungeon locations
/// Using hack values that is only available through the use of ELE/Enhanced Lighting for ENB
/// Without ELE the Dungeon factor will not function.

/// Implementation example;
///   float fBrightness = TOD3(Params013[3], fBrightness_E, fBrightness_I, fBrightness_D);
///   color.rgb *= fBrightness;

/// Creates these variables, with 1 component;
/// Exterior - Sunrise, Day, Sunset, Night
/// Interior
/// Dungeon

  return lerp(lerp(dot(TODfactors(), Ext), Int, EInteriorFactor), Dun, DungeonFactor(Params013));
}

// TOD Factor, using Weather.w / Weather time
float3 TODEIDe43i13d13(float4 Params013, float3 Sr_E, float3 D_E, float3 Ss_E, float3 N_E, float3 INT, float3 DUN) {
/// Splits a variable into Sunrise, Day, Sunset and night variables
/// As well as seperating them between Exterior, Interior and Dungeon locations
/// Using hack values that is only available through the use of ELE/Enhanced Lighting for ENB
/// Without ELE the Dungeon factor will not function.

/// Implementation example;
///   float fBrightness = TOD3(Params013[3], fBrightness_E, fBrightness_I, fBrightness_D);
///   color.rgb *= fBrightness;

/// Creates these variables, with 1 component;
/// Exterior - Sunrise.rgb, Day.rgb, Sunset.rgb, Night.rgb
/// Interior.rgb
/// Dungeon.rgb

  return lerp(lerp(mul(TODfactors(), float4x3(Sr_E, D_E, Ss_E, N_E)), INT, EInteriorFactor), DUN, DungeonFactor(Params013));
}

// TOD Factor, using Weather.w / Weather time
float TODE1(float4 Ext) {
/// Splits a variable into Sunrise, Day, Sunset and Night variables

/// Implementation example;
///   float fBrightness = TOD3(fBrightness_E);
///   color.rgb *= fBrightness;

/// Creates these variables, with 1 component;
/// Exterior - Sunrise, Day, Sunset, Night

  return dot(TODfactors(), Ext);
}

/*
// Compute the average of the 4 necessary samples
float4 GreyScale(Texture2D texDepth, float2 txcoord0) {
    float average = 0.0f;
    float maximum = -1e20;
    float4 lum    = 0.0f;

        lum = texDepth.Sample(Sampler0, txcoord0.xy);

        float GreyValue = max(max(lum.r, lum.g), lum.b);                                             /// Compute the luminance component as per the HSL colour space
        //float GreyValue = max(lum.r, max(lum.g, lum.b));                                           /// Take the maximum value of the incoming, same as computing the brightness/value for an HSV/HSB conversion
        //float GreyValue = 0.5f * (max(lum.r, max(lum.g, lum.b)) + min(lum.r, min(lum.g, lum.b)));  /// Compute the luminance component as per the HSL colour space
        //float GreyValue = length(lum.rgb);                                                         /// Use the magnitude of the colour

        maximum = max( maximum, GreyValue );
        average += (0.25f * log( 1e-5 + GreyValue )); /// 1e-5 necessary to stop the singularity at GreyValue=0
        average = exp( average );

    return float4( average, maximum, 0.0f, 1.0f ); /// Output the luminance to the render target
}
*/

// Luma coefficient gray value, for use with color perception effects. Multiple versions
float4 AvgLuma(float3 color) {
/// Implementation example;
///   color.rgb = AvgLuma(color.rgb).x // or .y or ,z or .w never ever .xyzw!;

  return float4(dot(color, float3(0.2125f, 0.7154f, 0.0721f)),                 /// Perform a weighted average
                max(color.r, max(color.g, color.b)),                       /// Take the maximum value of the incoming value
                max(max(color.x, color.y), color.z),                       /// Compute the luminance component as per the HSL colour space
                sqrt((color.x*color.x*0.2125f)+(color.y*color.y*0.7154f)+(color.z*color.z*0.0721f)));
}

// Calculate the log-average luminance of the scene
float3 LogLuma(float3 color) {
/// Implementation example;
///   color.rgb = LogLuma(color.rgb);

    float ScreenX     = ScreenSize.y;
    float sHeight     = ScreenSize.x * ScreenSize.w;
    float ScreenY     = 1.0f / sHeight;
    float ScenePixels = ScreenX * ScreenY;

  return exp(ScenePixels + (log(1e-5 + color.rgb)));
}

// RGB to XYZ conversion
float3 RGBtoXYZ(float3 color) {
/// Implementation example;
///   float3 XYZ = RGBtoXYZ(color.rgb);

  static const float3x3 RGB2XYZ = {0.412453f, 0.357580f, 0.180423f,
                                   0.212671f,  0.715160f, 0.072169f,
                                   0.019334f, 0.119193f,  0.950227f};
  return mul(RGB2XYZ, color.rgb);
}

// XYZ to Yxy conversion
float3 XYZtoYxy(float3 XYZ) {
/// Implementation example;
///   color.rgb = XYZtoYxy(XYZ.xyz);

   float4 Yxy = 0.0f;

   Yxy.r = XYZ.g;                                  /// Copy luminance Y
   Yxy.g = XYZ.r / (XYZ.r + XYZ.g + XYZ.b ); /// x = X / (X + Y + Z)
   Yxy.b = XYZ.g / (XYZ.r + XYZ.g + XYZ.b ); /// y = Y / (X + Y + Z)

  return Yxy.rgb;
}

// Yxy to XYZ conversion
float3 YxytoXYZ(float3 XYZ, float3 Yxy) {
/// Implementation example;
///   color.rgb = YxytoXYZ(XYZ.xyz, Yxy.rgb);

    XYZ.r = Yxy.r * Yxy.g / Yxy. b;                /// X = Y * x / y
    XYZ.g = Yxy.r;                                     /// Copy luminance Y
    XYZ.b = Yxy.r * (1 - Yxy.g - Yxy.b) / Yxy.b; /// Z = Y * (1-x-y) / y

  return XYZ;
  return Yxy;
}

// XYZ to RGB conversion
float3 XYZtoRGB(float3 XYZ) {
/// Implementation example;
///   color.rgb = XYZtoRGB(XYZ.xyz);

  static const float3x3 XYZ2RGB  = {3.240479f, -1.537150f, -0.498535f,
                                    -0.969256f, 1.875992f, 0.041556f, 
                                    0.055648f, -0.204043f, 1.057311f};
  return mul(XYZ2RGB, XYZ);
}

// RGB to Yxy conversion
float3 RGBtoYxy(float3 color) {
/// Implementation example;
///   float3 Yxy = RGBtoYxy(color.rgb);

  /// RGB to XYZ conversion
    static const float3x3 RGB2XYZ = {0.412453f, 0.357580f, 0.180423f,
                                     0.212671f,  0.715160f, 0.072169f,
                                     0.019334f, 0.119193f,  0.950227f};

    float3 XYZ = mul(RGB2XYZ, color.rgb);

 /// XYZ to Yxy conversion
   float4 Yxy = 0.0f;

   Yxy.r = XYZ.y;                                  /// Copy luminance Y
   Yxy.g = XYZ.x / (XYZ.x + XYZ.y + XYZ.z ); /// x = X / (X + Y + Z)
   Yxy.b = XYZ.y / (XYZ.x + XYZ.y + XYZ.z ); /// y = Y / (X + Y + Z)

  return Yxy.rgb;
}

// Yxy to RGB conversion
float3 YxytoRGB(float3 Yxy) {
/// Implementation example;
///   color.rgb = YxytoRGB(Yxy.rgb);

  /// Yxy to XYZ conversion
   float3 XYZ = 0.0f;

    XYZ.r = Yxy.r * Yxy.g / Yxy. b;              /// X = Y * x / y
    XYZ.g = Yxy.r;                               /// Copy luminance Y
    XYZ.b = Yxy.r * (1 - Yxy.g - Yxy.b) / Yxy.b; /// Z = Y * (1-x-y) / y

  /// XYZ to RGB conversion
    static const float3x3 XYZ2RGB = {3.240479f, -1.537150f, -0.498535f,
                                     -0.969256f, 1.875992f, 0.041556f, 
                                     0.055648f, -0.204043f, 1.057311f};

  return mul(XYZ2RGB, XYZ);
}

// RGB to HSL conversion
float3 RGBToHSL(float3 color) {
/// Implementation example;
///   color.rgb = RGBToHSL(color.rgb);

    float3 hsl; /// init to 0 to avoid warnings ? (and reverse if + remove first part)

    float fmin = min(min(color.r, color.g), color.b);
    float fmax = max(max(color.r, color.g), color.b);
    float delta = fmax - fmin;

    hsl.z = (fmax + fmin) / 2.0;

    if (delta == 0.0) { /// No chroma
        hsl.x = 0.0;  /// Hue
        hsl.y = 0.0;  /// Saturation
    } else { /// Chromatic data
        if (hsl.z < 0.5)
            hsl.y = delta / (fmax + fmin); /// Saturation
        else
            hsl.y = delta / (2.0 - fmax - fmin); /// Saturation

        float deltaR = (((fmax - color.r) / 6.0) + (delta / 2.0)) / delta;
        float deltaG = (((fmax - color.g) / 6.0) + (delta / 2.0)) / delta;
        float deltaB = (((fmax - color.b) / 6.0) + (delta / 2.0)) / delta;

        if (color.r == fmax )
            hsl.x = deltaB - deltaG; /// Hue
        else if (color.g == fmax)
            hsl.x = (1.0 / 3.0) + deltaR - deltaB; /// Hue
        else if (color.b == fmax)
            hsl.x = (2.0 / 3.0) + deltaG - deltaR; /// Hue

        if (hsl.x < 0.0)
            hsl.x += 1.0; /// Hue
        else if (hsl.x > 1.0)
            hsl.x -= 1.0; /// Hue
    }

  return hsl;
}

// HUE to RGB conversion
float HueToRGB(float f1, float f2, float hue) {
/// Implementation example;
///   VAR = HueToRGB(f1, f2, hsl);

    if (hue < 0.0)
        hue += 1.0;
    else if (hue > 1.0)
        hue -= 1.0;
    float res;
    if ((6.0 * hue) < 1.0)
        res = f1 + (f2 - f1) * 6.0 * hue;
    else if ((2.0 * hue) < 1.0)
        res = f2;
    else if ((3.0 * hue) < 2.0)
        res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
    else
        res = f1;

  return res;
}

// HSL to RGB conversion
float3 HSLToRGB(float3 hsl) {
/// Implementation example;
///   VAR = HSLToRGB(float3(HSLBase.x, HSLBase.y, HSLBlend.z));

    float3 rgb;

    if (hsl.y == 0.0)
        rgb = float3(hsl.z, hsl.z, hsl.z); // Luminance
    else {
        float f2;

        if (hsl.z < 0.5)
            f2 = hsl.z * (1.0 + hsl.y);
        else
        f2 = (hsl.z + hsl.y) - (hsl.y * hsl.z);

        float f1 = 2.0 * hsl.z - f2;

        rgb.r = HueToRGB(f1, f2, hsl.x + (1.0/3.0));
        rgb.g = HueToRGB(f1, f2, hsl.x);
        rgb.b= HueToRGB(f1, f2, hsl.x - (1.0/3.0));
    }

  return rgb;
}

// RGB to HSV conversion
float RGBCVtoHUE(in float3 RGB, in float C, in float V) {
/// Implementation example;
///   VAR = RGBCVtoHUE(RGB, C, HSV.z);

  float3 Delta = (V - RGB) / C;
    Delta.rgb -= Delta.brg;
    Delta.rgb += float3(2.0f, 4.0f, 6.0f);
    Delta.brg  = step(V, RGB) * Delta.brg;

  float H;
    H = max(Delta.r, max(Delta.g, Delta.b));

  return frac(H / 6.0f);
}

// RGB to HSV conversion
float3 RGBtoHSV(in float3 RGB) {
/// Implementation example;
///   VAR = RGBtoHSV(color.rgb);

  float3 HSV = 0.0f;
    HSV.z    = max(RGB.r, max(RGB.g, RGB.b));
    float M  = min(RGB.r, min(RGB.g, RGB.b));
    float C  = HSV.z - M;

  if (C != 0.0f) {
    HSV.x = RGBCVtoHUE(RGB, C, HSV.z);
    HSV.y = C / HSV.z;
  }

  return HSV;
}

// RGB to HSV conversion
float3 HUEtoRGBhsv(in float H) {
/// Implementation example;
///   VAR = HUEtoRGBhsv(HSV.xyz);

    float R = abs(H * 6.0f - 3.0f) - 1.0f;
    float G = 2.0f - abs(H * 6.0f - 2.0f);
    float B = 2.0f - abs(H * 6.0f - 4.0f);

  return saturate(float3(R,G,B));
}

// RGB to HSV conversion
float3 HSVtoRGB(in float3 HSV) {
/// Implementation example;
///   VAR = HSVtoRGB(HSV.xyz);

    float3 RGB = HUEtoRGBhsv(HSV.x);

  return ((RGB - 1.0f) * HSV.y + 1.0f) * HSV.z;
}

// Luminance Blend
float3 BlendLuma(float3 base, float3 blend) {
/// Implementation example;
///   VAR = BlendLuma(HSLBase.xyz, HSLBlend.xyz);

    float3 HSLBase  = RGBToHSL(base);
    float3 HSLBlend = RGBToHSL(blend);

  return HSLToRGB(float3(HSLBase.x, HSLBase.y, HSLBlend.z));
}

// Pseudo Random Number generator
float random(in float2 uv) {
/// Implementation example;
///   VAR = random(IN.txcoord0.xy);

    float2 noise = (frac(sin(dot(uv , float2(12.9898,78.233) * 2.0)) * 43758.5453));

  return abs(noise.x + noise.y) * 0.5;
}

// Random Noise generator
float randomNoise(in float3 uvw) {
	float3 noise = (frac(sin(dot(uvw ,float3(12.9898,78.233, 42.2442)*2.0)) * 43758.5453));
	return abs(noise.x + noise.y + noise.z) * 0.3333;
}

// Linear step
float linStep(float minVal, float maxVal, float coords) {
	return saturate((coords - minVal) / (maxVal - minVal));
}

// ALU noise in Next-gen post processing in COD:AW
float InterleavedGradientNoise(float2 uv) {
/// Implementation example;
///   VAR = InterleavedGradientNoise(txcoord0.xy);

    float3 magic = { 0.06711056, 0.00583715, 52.9829189 };
    return frac( magic.z * frac( dot( uv, magic.xy ) ) );
}

// Linear depth
float linearDepth(float nonLinDepth, float depthNearVar, float depthFarVar) {
/// Implementation example;
///   VAR = linearDepth(eDepth, fFromFarDepth, fFromNearDepth);

  return (2.0 * depthNearVar) / (depthFarVar + depthNearVar - nonLinDepth * (depthFarVar - depthNearVar));
}

// Split screen, show applied effects only on a specified area of the screen. ENBSeries before and user altered After
float4 SplitScreen(float4 color2, float4 color, float2 txcoord0, float inVar) {
    return (txcoord0.x < inVar) ? color2 : color;
}

// Clip Mode. Show which pixels are over and under exposed.
float3 ClipMode(float3 color) {
    if (color.x >= 0.99999 && color.y >= 0.99999 && color.z >= 0.99999) color.xyz = float3(1.0f, 0.0f, 0.0f);
    if (color.x <= 0.00001 && color.y <= 0.00001 && color.z <= 0.00001) color.xyz = float3(0.0f, 0.0f, 1.0f);

  return color;
}

// Visulize Depth. Shows the available depth buffer.
float3 ShowDepth(float3 color, Texture2D texDepth, float2 txcoord0, float fDepthfromFar, float fDepthFromNear) {
    float devDepth    = texDepth.Sample(Sampler0, txcoord0.xy).x;
    float devLinDepth = linearDepth(devDepth, fDepthfromFar, fDepthFromNear);
    color.rgb       = float3(1, 0, 0) * devLinDepth;

  return color;
}

// ENBSeries default bloom and lens blur
float3 FuncBlur(Texture2D inTextureBloom, float2 uvsrc, float srcsize, float destsize) {
	const float	scale=4.0; //blurring range, samples count (performance) is factor of scale*scale
	//const float	srcsize=1024.0; //in current example just blur input texture of 1024*1024 size
	//const float	destsize=1024.0; //for last stage render target must be always 1024*1024

	float2	invtargetsize=scale/srcsize;
	invtargetsize.y*=ScreenSize.z; //correct by aspect ratio

	float2	fstepcount;
	fstepcount=srcsize;

	fstepcount*=invtargetsize;
	fstepcount=min(fstepcount, 16.0);
	fstepcount=max(fstepcount, 2.0);

	int	stepcountX=(int)(fstepcount.x+0.4999);
	int	stepcountY=(int)(fstepcount.y+0.4999);

	fstepcount=1.0/fstepcount;
	float4	curr=0.0;
	curr.w=0.000001;
	float2	pos;
	float2	halfstep=0.5*fstepcount.xy;
	pos.x=-0.5+halfstep.x;
	invtargetsize *= 2.0;
	for (int x=0; x<stepcountX; x++)
	{
		pos.y=-0.5+halfstep.y;
		for (int y=0; y<stepcountY; y++)
		{
			float2	coord=pos.xy * invtargetsize + uvsrc.xy;
			float3	tempcurr=inTextureBloom.Sample(Sampler1, coord.xy).xyz;
			float	tempweight;
			float2	dpos=pos.xy*2.0;
			float	rangefactor=dot(dpos.xy, dpos.xy);
			//loosing many pixels here, don't program such unefficient cycle yourself!
			tempweight=saturate(1001.0 - 1000.0*rangefactor);//arithmetic version to cut circle from square
			tempweight*=saturate(1.0 - rangefactor); //softness, without it bloom looks like bokeh dof
			curr.xyz+=tempcurr.xyz * tempweight;
			curr.w+=tempweight;

			pos.y+=fstepcount.y;
		}
		pos.x+=fstepcount.x;
	}
	curr.xyz/=curr.w;

	//curr.xyz=inTextureBloom.Sample(Sampler1, uvsrc.xy);

  return curr.xyz;
}

// ENBSeries default bloom and lens blur
float enbBlurLO(Texture2D inTextureBloom, float2 uvsrc, float srcsize, float destsize) {
/// Only applied to one channel, alpha
/// Enables a blur method that is used for Local Tonemapping operators

	const float	scale = 4.0; //blurring range, samples count (performance) is factor of scale*scale

	float2 invtargetsize = scale / srcsize;
	invtargetsize.y *= ScreenSize.z; //correct by aspect ratio

	float2 fstepcount;
	fstepcount = srcsize;

	fstepcount *= invtargetsize;
	fstepcount = min(fstepcount, 16.0);
	fstepcount = max(fstepcount, 2.0);

	int	stepcountX = (int)(fstepcount.x+0.4999);
	int	stepcountY = (int)(fstepcount.y+0.4999);

	fstepcount = 1.0 / fstepcount;
	float curr = 0.0;
	float cDelta = 0.000001;
	float2 pos;
	float2 halfstep = 0.5 * fstepcount.xy;
	pos.x = -0.5 + halfstep.x;
	invtargetsize *= 2.0;
	for (int x = 0; x < stepcountX; x++)
	{
		pos.y = -0.5+halfstep.y;
		for (int y = 0; y < stepcountY; y++)
		{
			float2 coord = pos.xy * invtargetsize + uvsrc.xy;
			float tempcurr = inTextureBloom.Sample(Sampler1, coord.xy);
			float tempweight;
			float2 dpos = pos.xy*2.0;
			float rangefactor = dot(dpos.xy, dpos.xy);
			//loosing many pixels here, don't program such unefficient cycle yourself!
			tempweight = saturate(1001.0 - 1000.0 * rangefactor);//arithmetic version to cut circle from square
			tempweight *= saturate(1.0 - rangefactor); //softness, without it bloom looks like bokeh dof
			curr += tempcurr * tempweight;
			cDelta += tempweight;

			pos.y += fstepcount.y;
		}
		pos.x += fstepcount.x;
	}
	curr /= cDelta;

  return curr;
}

// Texture atlas tiles sampling
float2 GetAtlasAddressSym(float2 tile, float2 txcoord0) {  // Note that there can be tiles in tiles :)
/// Returns address of a texture sample within a given tile. Tiles are square (equaly sized).
/// Parameters:
///	'tile' - address of a tile, e.g. float2(1, 3) means tile in second column and forth row [float2],
///	'txcoord0' - sample position within a tile, like a normal texture coordinate [float2].
/// Tile address (first argument) have to be an integer vector (in a float one), e.g. float2(1, 3), indexed from 0 (e.g. 0, 1, 2 for 3 tiles in a row/column).

/// By calling this function several times, like so:
///	float2 address = AtlasAddress_func(tile0, AtlasAddress_func(tile1, txcoord0));
/// tiles can be devided into smaller ones and so on.

	return saturate((tile / fAtlasTilesGranularitySym) + txcoord0);
}

// Returns address of a texture sample within a given tile. Tiles can be rectangular
float2 GetAtlasAddressAsy(float2 tile, float2 txcoord0) {
/// Parameters:
///	'tile' - address of a tile, e.g. float2(1, 3) means tile in second column and forth row [float2],
///	'txcoord0' - sample position within a tile, like a normal texture coordinate [float2].
/// Tile address (first argument) have to be an integer vector (in a float one), e.g. float2(1, 3), indexed from 0 (e.g. 0, 1, 2 for 3 tiles in a row/column).
/// This version allow sampling of rectangular tiles, should the granularity be different for columns and rows.

	return saturate((tile / fAtlasTilesGranularityAsy) + txcoord0);
}

// Anamorphic sampling
float2 GetAnamorphicAddress(int axis, float blur, float2 txcoord0) {
/// Returns a 2D coordines stretched along one of the axis.
/// Parameters:
///	'axis' - axis to stretch the coordinates along (0 is axis X - horizontal, 1 is axis Y - vertical) [int],
///	'blur' - the amount of which the coordinates will be stretched [float],
///	'txcoord0' - the coordinates to be stretched [float2].

	txcoord0 = 2.0 * txcoord0 - 1.0;
	if (!axis) txcoord0.x /= -blur;
	else txcoord0.y /= -blur;
	txcoord0 = 0.5 * txcoord0 + 0.5;

  return txcoord0;
}

// Chromatic aberration sampling.
/// TODO: ...
/*
void GetChromaticAberrationAddresses(out float3x3 outCoords, 
									 float baseRadius, 
									 float falloffRadius, 
									 float4 chroma, 
									 float chromaPower, 
									 float2 coords)
{
	float d = distance(coords, float2(0.5, 0.5));
	float f = smoothstep(baseRadius, falloffRadius, d);
	float3 cv = pow(f + chroma, chromaPower);
	
	float2 tr = ((2.0 * coords - 1.0) * cv.r) * 0.5 + 0.5;
	float2 tg = ((2.0 * coords - 1.0) * cv.g) * 0.5 + 0.5;
	float2 tb = ((2.0 * coords - 1.0) * cv.b) * 0.5 + 0.5;
	
	outCoords = float3x3(float3(tr.x, tr.y, 0.0f), float3(tg.x, tg.y, 0.0f), float3(tb.x, tb.y, 0.0f));
}
*/