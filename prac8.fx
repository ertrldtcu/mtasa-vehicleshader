// original: https://www.shadertoy.com/view/3lBcRz

float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float gTime : TIME;
float pi = 3.14159;

// dtc values
float speed = 2.5;
float rate = 10.0;
float intensity = 0.0;
float4 color = float4(1.0,1.0,1.0,1.0);

struct ps {
  float4 Position : POSITION;
  float2 TexCoord : TEXCOORD0;
};
  
ps vs(ps input) {
  ps output;
  output.Position = mul(input.Position,gWorldViewProjection);
  output.TexCoord = input.TexCoord;
  return output;
}

float circle(float2 uv, float2 center, float radius) {
  float dist = length(uv - center);
  return smoothstep(radius - 0.01, radius, dist);
}

float circunference(float2 uv, float2 center, float radious, float thickness) {
  float dist = length(uv - center);
  return smoothstep(.0f, thickness, abs(dist - radious));
}

float2 fract(float2 v) {
  return float2(v.x-floor(v.x),v.y-floor(v.y));
}
float2 iResolution = float2(1.,1.);

float4 pixelShader(ps input) : COLOR0 {
  float2 uv = (2.0f * input.TexCoord - iResolution.xy);

  float2 max_uv = iResolution.xy;
  float2 min_uv = -max_uv;

  float2 size = max_uv - min_uv;

  float radius = size.x / rate * 2.5;
  float dist_between_circles = radius + (radius / 10);

  float c = float(1.0f);

  float2 ij = (uv - min_uv) / dist_between_circles;
  ij -= fract(ij);

  for (int ii = -1; ii <= 1; ii++) {
    for (int jj = -1; jj <= 1; jj++) {
      float2 iijj = ij + float2(float(ii), float(jj));
      float2 center = min_uv + iijj * dist_between_circles;
      c *= circunference(uv, center, radius, 0.01);
 
      float offset = iijj.x * 0.5f - iijj.y * 0.5f;  
      float a = speed * - gTime - offset;
      center += radius * float2(cos(a), sin(a));
      c *= circle(uv, center, 0.03);
    }
  }
  c = 1-c;
  c+=c*intensity;
  float alpha = distance((c+abs(c))/2,0);
  return float4(color.r*c,color.g*c,color.b*c,alpha*color.a);
}
 
technique dtc {
  pass Pass0 {
    VertexShader = compile vs_3_0 vs();
    PixelShader = compile ps_3_0 pixelShader();
  }
}