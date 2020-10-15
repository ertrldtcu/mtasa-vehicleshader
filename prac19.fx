// original: https://www.shadertoy.com/view/MdffDr

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
 
float easingSinInOut(float t){
   t = fmod(t,1.0);
   return 0.5*(1.0 - cos(3.14159 * t)); 
}
float triDist(float2 p){
  float f = smoothstep(0.0,0.01,p.x-p.y);
  f*=  smoothstep(0.0,0.01,-p.x-p.y);
  f*=  smoothstep(0.0,0.01,0.5+p.y);
  return f;
}

float4 pixelShader(ps input) : COLOR0 {
  float2 p = input.TexCoord;
  p+=.5;
  p*=rate/2+2;
  float t = fmod(gTime*speed/5,4.0);
  p.x+=6.0*easingSinInOut(t)*(1.0-step(1.0,t));
  p.x+=6.0*step(1.0,t)*(1.0-step(2.0,t));
  p.x+=(6.0-6.0*easingSinInOut(t))*step(2.0,t)*(1.0-step(3.0,t));
  p.x+=0.0*step(3.0,t)*(1.0-step(4.0,t));
  p.y+=0.0*(1.0-step(1.0,t));  
  p.y+=6.0*easingSinInOut(t)*step(1.0,t)*(1.0-step(2.0,t));
  p.y+=6.0*step(2.0,t)*(1.0-step(3.0,t));
  p.y+=(6.0-6.0*easingSinInOut(t))*step(3.0,t)*(1.0-step(4.0,t));
  float gridsize = 1.3;
  float2 pcenter = floor((p)/gridsize);
  float angle = 1.0+gTime+10.0*sin(1.0*pcenter.y+gTime*speed/10)*sin(1.0*pcenter.x+gTime*speed/10);
  angle = angle;
  float2 prot=fmod(p,gridsize)-gridsize/2.0;
  prot  = mul(prot,float2x2(
    cos(angle),
    sin(angle),
    -sin(angle),
    cos(angle)
  ));
  float2 ptrans = prot;
  float c = triDist(ptrans);
  ptrans = mul(prot,float2x2(
    cos(3.14159/1.0),
    sin(3.14159/1.0),
    -sin(3.14159/1.0),
    cos(3.14159/1.0)
  ));
  ptrans = ptrans;
  c = max(c,triDist(ptrans));
  c *= 0.5+0.5*sin(123.0*pcenter.x+5587.0*pcenter.y+3.0*gTime);
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