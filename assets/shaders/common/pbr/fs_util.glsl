#ifndef F_FS_UTIL_GLS
#define F_FS_UTIL_GLS

#include "/common/inputs/entity.glsl"
#include "/common/inputs/material.glsl"
#include "/common/inputs/textures/emission_map.glsl"
#include "/common/alpha_mode.glsl"
#include "/common/fs_tonemapping.glsl"

vec4 get_base_color(vec4 albedoColor)
{
	vec4 colorMod = get_instance_color();
	vec4 baseColor = albedoColor;
	if(is_material_translucent()) {
		uint alphaMode = u_material.material.alphaMode;
		if(colorMod.a < 1.0)
			alphaMode = ALPHA_MODE_BLEND;
		baseColor.a = apply_alpha_mode(baseColor.a * colorMod.a * u_material.material.color.a, alphaMode, u_material.material.alphaCutoff) * colorMod.a;
	}
	else
		baseColor.a = 1.0;
	baseColor.rgb *= colorMod.rgb * u_material.material.color.rgb;
	return baseColor;
}

vec4 get_emission_color(vec4 color, vec4 baseColor, vec2 texCoords)
{
	vec4 result = color;
	if(use_glow_map()) {
		vec4 emissiveColor = texture(u_glowMap, texCoords);
		emissiveColor.rgb *= u_material.material.emissionFactor.rgb;
		emissiveColor.rgb *= emissiveColor.a * 15;
		result = apply_emission_color(u_material.material.flags, result, texCoords, emissiveColor, baseColor);
	}
	return result;
}

#endif
