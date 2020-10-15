// original: http://glslsandbox.com/e#66051.0

float gTime : TIME;
float pi = 3.14159;

// dtc values
float speed = 5.0;
float rate = 20.0;
float intensity = 0.0;
float4 color = float4(1.0,1.0,1.0,1.0);

float4 pixelShader(float2 pos : TEXCOORD0) : COLOR0 {
  pos*=rate*1.5;
  float c = floor(fmod(pos.x, 2.0)) * floor(fmod(pos.y, 2.0));
  c *= sin(gTime*speed/2 + floor(pos.x));
  c *= cos(gTime*speed/2 + floor(pos.y));
  c+=c*intensity;
  float alpha = distance((c+abs(c))/2,0);
  return float4(color.r*c,color.g*c,color.b*c,alpha*color.a);
}
 
technique dtc {
  pass Pass0 {
    PixelShader = compile ps_2_0 pixelShader();
  }
}