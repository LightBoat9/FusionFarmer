shader_type canvas_item;


uniform bool outlineVisible;
uniform vec4 outlineColor : source_color;


void fragment() {
	vec4 texColor = texture(TEXTURE, UV);
	
	if (outlineVisible && texColor.a == 0.0) {
		for (float y = -1.0; y <= 1.0; y++) {
			for (float x = -1.0; x <= 1.0; x++) {
				if (x == 0.0 && y == 0.0 || abs(x) == abs(y)) {
					continue;
				}
				
				if (texture(TEXTURE, UV + vec2(x, y) * TEXTURE_PIXEL_SIZE).a != 0.0) {
					texColor = outlineColor;
				}
			}
		}
	}
	
	COLOR = texColor;
}
