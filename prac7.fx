// original: http://glslsandbox.com/e#66538.1

float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float gTime : TIME;
float pi = 3.14159;

// dtc values
float speed = 8.0;
float rate = 15.0;
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
 
float4 pixelShader(ps input) : COLOR0 {
  float2 pos = .5-input.TexCoord;
  float r = length(pos) * rate / 10.;
  float a = atan2(pos.x,pos.y)*0.350225;
  
  float rn = r * pi * 10;
  float an = a * pi * 10;

  float c = sin(gTime * speed * 3.0 + rn + sin(gTime + an));
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