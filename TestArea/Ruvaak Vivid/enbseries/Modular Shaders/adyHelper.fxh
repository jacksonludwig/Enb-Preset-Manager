// Small collection of Functions by Adyss
// Filmic ALU by HEJI ported to HLSL by Kingeric1992

struct TM_FilmicALU_struct { 
    float a, b, c, d, e, f, g, w; 
};

static const TM_FilmicALU_struct TM_FilmicALU_ACES = {
    0.9, 0.018, 0.875, 0.354, 0.14, 1.0, 0.0, 4.0
};

static const TM_FilmicALU_struct TM_FilmicALU_Default  = {
    6.2, 0.5, 6.2, 1.7, 0.06, 2.2, 0.004, 4.0
};

float4 TM_FlimicALU_func(float4 color, const TM_FilmicALU_struct i) {
    float4 l = max(color - i.g, 0.0);
    return pow(saturate( l*(i.a*l+i.b) / 
                       ( l*(i.c*l+i.d) + i.e)), i.f);
}

float3 TM_FilmicALU( float3 color, const TM_FilmicALU_struct i = TM_FilmicALU_Default ) { 
     float4 res = TM_FlimicALU_func(float4(color, i.w), i);
     return res.rgb/res.a;
}


float3 ACESFilmRec2020( float3 x )
{
    float a = 15.8f;
    float b = 2.12f;
    float c = 1.2f;
    float d = 5.92f;
    float e = 1.9f;
    return ( x * ( a * x + b ) ) / ( x * ( c * x + d ) + e );
}

float3 LinToLog( float3 LinearColor )
{
    const float LinearRange = 14;
    const float LinearGrey = 0.18;
    const float ExposureGrey = 444;

    float3 LogColor = ( 300 * log10( LinearColor * (1 - .0108) + .0108 ) + 685 ) / 1023;    // Cineon
    LogColor = saturate( LogColor );

    return LogColor;
}