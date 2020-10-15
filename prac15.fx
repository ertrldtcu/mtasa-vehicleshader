// original: http://glslsandbox.com/e#64917.0

float gTime : TIME;
float pi = 3.14159;

// dtc values
float speed = 5.0;
float rate = 20.0;
float intensity = 0.0;
float4 color = float4(1.0,1.0,1.0,1.0);

float4 pixelShader(float2 pos : TEXCOORD0) : COLOR0 {
  pos = abs(pos-0.5);
  float w = abs(sin(gTime/3)*5./rate);
  float2 q = float2(fmod(pos, w) - (w/2.0));
  float g = abs(cos(gTime * speed));
  float c = g / abs(q.x) * abs(q.y);
  c+=c*intensity;
  float alpha = distance((c+abs(c))/2,0);
  return float4(color.r*c,color.g*c,color.b*c,alpha*color.a);
}
 
technique dtc {
  pass Pass0 {
    PixelShader = compile ps_2_0 pixelShader();
  }
}