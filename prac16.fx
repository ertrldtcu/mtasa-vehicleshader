// original: https://www.shadertoy.com/view/tlf3Df

float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float gTime : TIME;
float pi = 3.14159;

// dtc values
float speed = 5.0;
float rate = 20.0;
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
float2 f2fract(float2 v) {
  return float2(v.x-floor(v.x),v.y-floor(v.y));
}
float rand(float2 co){
    return ffract(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
}

float4 pixelShader(ps input) : COLOR0 {
  float2 pos = input.TexCoord;
  float2 uv = input.TexCoord;
  float2 u = f2fract(uv*rate);
  float c = step(u.x,0.5);
  float r = rand(floor(uv*rate)); 
  float t = sin(gTime*r*speed/2.0)+1.0;
  float f = (sin(t*r*10.)+1.)*.25;
  float w = r > .5 ? u.y : u.x;
  c = step(f,w) - step(f+.25,w-.25);
  float2 d = f2fract(u);
  c+= (step(d.x,.005) + step(d.y,.005))*.3;
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