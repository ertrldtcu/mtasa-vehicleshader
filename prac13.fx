// original: http://glslsandbox.com/e#65518.0

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

float fract(float v) {
  return v-floor(v);
}

const float K2 = 0.9330127;
const float K1 = 0.8660254;

float4 pixelShader(ps input) : COLOR0 {
  float2 pos = input.TexCoord;
  pos*=rate/4;
  pos.x=pos.x*K2-pos.y/4.0;
  pos.y=floor(pos.y)*K2+pos.x/4.0+fract(pos.y);
  float2 fracts = float2(fract(pos.x), fract(pos.y));
  float2 floors = float2(floor(pos.x),floor(pos.y));
  if(fract(pos.x)>0.5){
    fracts.y += (0.5-fracts.x)*.5;
    fracts.x += (fracts.x-.5)*K1+0.5;
  }
  float2 positionp = floors+fracts+gTime*speed/6.0;
  float c = 0.0;
  c += (fract(positionp.x)>.95||fract(positionp.x)<.05)?0.5:0.0;
  c += (fract(positionp.y)>.95||fract(positionp.y)<.05)?0.5:0.0;
  c += (fract(positionp.x)>.49&&fract(positionp.x)<.51)?0.5:0.0;
  c += (fract(positionp.y)>.49&&fract(positionp.y)<.51)?0.5:0.0;
  c += (abs((0.5-fract(positionp.y))-(fract(positionp.x)-1.0))<.01)?0.5:0.0;
  c += (abs((0.5-fract(positionp.y))-(fract(positionp.x)-0.0))<.01)?0.5:0.0;
  c += (abs((0.5-fract(positionp.y))-(fract(positionp.x)-0.5))<.01)?0.5:0.0;
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