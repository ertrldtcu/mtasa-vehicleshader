// original: https://www.shadertoy.com/view/Wd3SDX

float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float gTime : TIME;
float pi = 3.14159;

// dtc values
float speed = 5.0;
float rate = 20.0;
float intensity = 0.0;
float opacity = 1.0;
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

float2 f2fract(float2 v) {
  return float2(v.x-floor(v.x),v.y-floor(v.y));
}
float2 rand(float2 p){
    float n = sin(dot(p, float2(1, 113)));
    return f2fract(float2(262144, 32768)*n);     
}
float sdRoundBox(float2 p, float2 b, float r){
  float2 q = abs(p) - b;
  return length(max(q,.0)) + min(max(q.x,q.y),.0) - r;
}

float4 pixelShader(ps input) : COLOR0 {
  float2 pos = input.TexCoord;
  float g = smoothstep(.0, .25, pos.y+.15)+.25;
  pos *= rate*1.5;
  float2 fl = floor(pos);
  float2 fr = (f2fract(pos)-.5)*2.;
  float a = sdRoundBox(fr, float2(.7, .7), .1);
  float s = smoothstep(0.1, 0.01, a);
  float2 ran = rand(fl)*1.5;
  float t = pow(abs(sin(ran.x*6.2831 + gTime*(.25 + ran.y)*speed/2.)), 8.);
  float c = ran.x * ran.y*g*s*t;
  c+=c*intensity;
  float alpha = distance(c,0);
  return float4(color.r*c,color.g*c,color.b*c,alpha*color.a);
}
 
technique dtc {
  pass Pass0 {
    VertexShader = compile vs_3_0 vs();
    PixelShader = compile ps_3_0 pixelShader();
  }
}