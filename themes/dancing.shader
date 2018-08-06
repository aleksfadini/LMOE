shader_type canvas_item;

uniform float time_factor = 3;
uniform vec2 amplitude = vec2(3, 3);

//void vertex() {
//	VERTEX.x += sin(TIME * time_factor) * amplitude.x;
//	VERTEX.y += cos(TIME * time_factor) * amplitude.y;
//}

void vertex() {
	VERTEX.x += sin((TIME * time_factor) + VERTEX.x+ VERTEX.x) * amplitude.x;
	VERTEX.y += cos((TIME * time_factor) + VERTEX.y+ VERTEX.y) * amplitude.y;
}