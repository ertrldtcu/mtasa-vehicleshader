// original: http://glslsandbox.com/e#66012.0

float gTime : TIME;
float pi = 3.14159;

// dtc values
float speed = 2.0;
float rate = 10.0;
float intensity = 0.0;
float4 color = float4(1.0,1.0,1.0,1.0);

float2 fract(float2 v) {
  return float2(v.x-floor(v.x),v.y-floor(v.y));
}
float cros(float2 uv, float r){
    float m = step(abs(uv.x),r);
    m += step(abs(uv.y),r);
    return m;
}

float4 pixelShader(float2 pos : TEXCOORD0) : COLOR0 {
  pos.y += cos(pos.y*3.+pos.x*4.+gTime*speed)*.05;
  float a = 3.142/5.;  
  pos = float2(cos(a)*pos.x-sin(a)*pos.y,sin(a)*pos.x+cos(a)*pos.y);
  pos = fract(pos * rate / 1.5)-0.5;
  float c = cros(pos,0.1);
  c+=c*intensity;
  float alpha = distance((c+abs(c))/2,0);
  return float4(color.r*c,color.g*c,color.b*c,alpha*color.a);
}
 
technique dtc {
  pass Pass0 {
    PixelShader = compile ps_2_0 pixelShader();
  }
}