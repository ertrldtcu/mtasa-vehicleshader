// original: http://glslsandbox.com/e#61805.2

float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float gTime : TIME;
float pi = 3.14159;

// dtc values
float speed = 2.0;
float rate = 25.0;
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

float fract(float v) {
  return v-floor(v);
}

float4 pixelShader(ps input) : COLOR0 {
  float2 pos = input.TexCoord;
  float c = 0.0;
  for(float i = 0.0; i < rate/2.0; i++){
    float s = sin(gTime * speed / 10.+ i * 0.314) * 0.5;
    float k = cos(gTime * speed / 10.+ i * 0.314) * 0.5;
    c += 0.0015 / abs(fract(pos.x - pos.y - k) - 2.0*abs(sin(0.5)));
    c += 0.0015 / abs(fract(pos.y + pos.x + s) - 1.5*abs(sin(0.4)));  
  }
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