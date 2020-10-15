// original: http://glslsandbox.com/e#61055.0

float gTime : TIME;
float pi = 3.14159;

// dtc values
float speed = 5.0;
float rate = 20.0;
float intensity = 0.0;
float4 color = float4(1.0,1.0,1.0,1.0);

float2x2 rotate(float a) {
	return float2x2(cos(a), sin(a), -sin(a), cos(a));
}
float2 fract(float2 v) {
  return float2(v.x-floor(v.x),v.y-floor(v.y));
}

float4 pixelShader(float2 pos : TEXCOORD0) : COLOR0 {
  pos = 2*pos-1;
  float s = rate/30+.1;
  for (int i = 0; i < 4; i++) {
    pos = abs(pos) / dot(pos, pos) - s;
    pos = mul(pos,rotate(gTime*speed/10));
    s *= .888;
  }
  pos = fract(pos + .5) - .5;
  float c = smoothstep(.04, .01, min(abs(pos.x), abs(pos.y)));
  c+=c*intensity;
  float alpha = distance((c+abs(c))/2,0);
  return float4(color.r*c,color.g*c,color.b*c,alpha*color.a);
}
 
technique dtc {
  pass Pass0 {
    PixelShader = compile ps_2_0 pixelShader();
  }
}