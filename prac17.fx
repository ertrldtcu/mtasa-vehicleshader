// original: https://www.shadertoy.com/view/MtcBRn

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
#define round(x) (floor((x) + 0.5))

float4 pixelShader(ps input) : COLOR0 {
  float2 iResolution = float2(rate*10,rate*10);
  float2 pos = input.TexCoord * iResolution - iResolution.xy / 2.0;
  float2 offset = float2(-0.5,-0.5);
  float c = 0.0;
  float t = gTime * speed / 5.;
  float scale = pow(3.0, fmod(t, 2.0) + 1.0);
  float size = iResolution.y * scale;
  float rot = t / 2.0;
  pos = mul(pos,float2x2(cos(-rot), sin(-rot), -sin(-rot), cos(-rot)));
  pos += offset * iResolution.y * (scale * 0.5 - 0.5);
  for (int i=0; i<9;++i) {
    if (size <= 1.0) break;
    size /= 3.0;
    float2 ip = float2(round(pos / size));
    if(ip.x == 0 && ip.y == 0) {
      c = min(size*size, 1.0);
      break;
    }
	else {
      pos -= float2(ip) * size;
    }
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