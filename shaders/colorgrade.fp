#define MAXCOLOR 31.0
#define COLORS 32.0

#define LUT_WIDTH 1024.0
#define LUT_HEIGHT 32.0

#define TEXTURE_WIDTH 1024.0
#define TEXTURE_HEIGHT 1024.0

vec4 lookup(sampler2D original, vec2 texCoord, sampler2D lut, int lutIndex)
{
    vec4 px = clamp(texture(original, texCoord.xy), 0.0, 1.0);

    float cell = px.b * MAXCOLOR;
    float cell_l = floor(cell);
    float cell_h = ceil(cell);

    float half_px_x = 0.5 / TEXTURE_WIDTH;
    float half_px_y = 0.5 / TEXTURE_HEIGHT;

    float top = lutIndex * (1.0 / (TEXTURE_HEIGHT / LUT_HEIGHT));

    float r_offset = half_px_x + px.r / COLORS * (MAXCOLOR / COLORS);
    float g_offset = half_px_y + px.g / COLORS * (MAXCOLOR / COLORS) + top;

    vec2 lut_pos_l = vec2(cell_l / COLORS + r_offset, g_offset);
    vec2 lut_pos_h = vec2(cell_h / COLORS + r_offset, g_offset);

    vec4 graded_color_l = texture(lut, lut_pos_l);
    vec4 graded_color_h = texture(lut, lut_pos_h);

    return mix(graded_color_l, graded_color_h, fract(cell));
}

void main()
{
    FragColor = lookup(InputTexture, TexCoord, lut, lut_index);
}
