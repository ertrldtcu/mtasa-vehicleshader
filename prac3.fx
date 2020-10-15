// made by ertrldtcu

float gTime : TIME;
float pi = 3.14159;

// dtc values
float speed = 5.0;
float rate = 20.0;
float intensity = 0.5;
float4 color = float4(1.0,1.0,1.0,1.0);
 
float4 pixelShader(float2 pos : TEXCOORD) : COLOR0 {
  float c = sin(sin(gTime * speed / 2.0 + sin(pos.x * rate/2. * pi - gTime * speed) + sin(pos.y * rate/2. * pi + gTime * speed * 2))*10);
  c+=c*intensity;
  float alpha = distance((c+abs(c))/2,0);
  return float4(color.r*c,color.g*c,color.b*c,alpha*color.a);
}
 
technique dtc {
  pass Pass0 {
    PixelShader = compile ps_2_0 pixelShader();
  }
}