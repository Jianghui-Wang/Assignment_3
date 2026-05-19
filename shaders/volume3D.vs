#version 410 core

layout (location = 0) in vec3 vertexPos;
layout (location = 1) in vec3 vertexNorm;

out vec3 fragColor;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

uniform vec3  vertexColor;
uniform float useLighting;     // 1 = Gouraud shade, 0 = pass vertexColor through

const vec3 lightColor = vec3(1.0);
const vec3 lightPos   = vec3(1.0, 1.0, 1.0);   // world-space directional-ish light

void main() {
    vec4 worldPos4 = model * vec4(vertexPos, 1.0);
    gl_Position    = projection * view * worldPos4;

    if (useLighting > 0.5) {
        // Gouraud shading: compute Lambertian lighting per vertex; the
        // fragment shader just interpolates the result across the triangle.
        mat3 normalMat = transpose(inverse(mat3(model)));
        vec3 N         = normalize(normalMat * vertexNorm);
        vec3 L         = normalize(lightPos - worldPos4.xyz);

        float ambient  = 0.18;
        float diffuse  = max(dot(N, L), 0.0);
        fragColor = vertexColor * lightColor * (ambient + diffuse);
    } else {
        fragColor = vertexColor;
    }
}
