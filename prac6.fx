// original: http://glslsandbox.com/e#66260.0

float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float gTime : TIME;
float pi = 3.14159;

// dtc values
float speed = 3.0;
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

float ffract(float v) {
  return v-floor(v);
}
float3 f3fract(float3 v) {
  return float3(v.x-floor(v.x),v.y-floor(v.y),v.z-floor(v.z));
} 
float rand(float2 uv) {
  return ffract(sin(dot(uv, float2(12.9898, 78.233))) * 48751.5453);
}
float2 uv2tri(float2 uv) {
  float sx = uv.x - uv.y / 2.0;
  float offs = step(ffract(1.0 - uv.y), ffract(sx));
  return float2(floor(sx) * 2.0 + offs, floor(uv.y));
}

float2 iResolution = float2(1,1);

float4 pixelShader(ps input) : COLOR0 {
  float2 uv = input.TexCoord * rate / 2.0;

  float3 p = float3(dot(uv, float2(1.0, 0.5)), dot(uv, float2(-1.0, 0.5)), uv.y);
  float3 p1 = f3fract(+p);
  float3 p2 = f3fract(-p);

  float d1 = min(min(p1.x, p1.y), p1.z);
  float d2 = min(min(p2.x, p2.y), p2.z);
  float d = min(d1, d2);

  float2 tri = uv2tri(uv);
  float r = rand(tri) * 2.0 + tri.x / 16.0 + gTime * speed;

  float c = smoothstep(-0.02,0.0,d-0.2*(1.0+sin(r)));
  c+=c*intensity;
  float alpha = distance((c+abs(c))/2,0);
  return float4(color.r*c,color.g*c,color.b*c,alpha*color.a);
}
 
technique tec {
  pass Pass0 {
    VertexShader = compile vs_3_0 vs();
    PixelShader = compile ps_3_0 pixelShader();
  }
}