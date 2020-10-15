// original: (type1.fx) https://community.multitheftauto.com/index.php?p=resources&s=details&id=16056

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

float4 pixelShader(ps input) : COLOR0 {
  float2 p = input.TexCoord + input.TexCoord*rate/2. - 19;
  float2 i = p;
  float c = 2.0;
  for (int n = 0; n < 11; n++) {
    float t = gTime * speed/2. * (1 - (3 / (n+1)));
    i = p + float2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
    c += 1.0/length(float2(p.x / (2.*sin(i.x+t)/0.05),p.y / (cos(i.y+t)/0.05)));
  }
  c /= 11;
  c = 1.5-sqrt(pow(abs(c),3.5));
  c = pow(c,4);
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