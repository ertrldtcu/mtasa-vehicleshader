// original: http://glslsandbox.com/e#61601.0

float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float gTime : TIME;
float PI = 3.14159;

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
float2 f2fract(float2 v) {
  return float2(v.x-floor(v.x),v.y-floor(v.y));
}
float random2d(float2 n) { 
    return fract(sin(dot(n, float2(129.9898, 4.1414))) * 2398.5453);
}
float2 getCellIJ(float2 uv, float gridDims) {
    return floor(uv * gridDims)/ gridDims;
}
float2 rotate2D(float2 pos, float a) {
    float2x2 m = float2x2( cos(a), -sin(a), sin(a), cos(a) );
    return mul(pos,m);
}
float letter(float2 coord, float size) {
    float2 gp = floor(coord / size * 7.);
    float2 rp = floor(f2fract(coord / size) * 7.);
    float2 odd = f2fract(rp * 0.5) * 2.;
    float rnd = random2d(gp);
    float c = max(odd.x, odd.y) * step(0.5, rnd);
    c += min(odd.x, odd.y);
    c *= rp.x * (6. - rp.x);
    c *= rp.y * (6. - rp.y);
    return clamp(c, 0., 1.);
}

float4 pixelShader(ps input) : COLOR0 {
  float2 uv = input.TexCoord;
  uv.y +=.5;
  float dims = 1+floor(rate / 10);  
  uv = rotate2D(uv,PI/12.0);
  uv.y -= gTime * speed / 10;
  float cellRand;
  float2 ij;
  for(int i = 0; i <= 3; i++) { 
    ij = getCellIJ(uv, dims);
    cellRand = random2d(ij);
    dims *= 2.0;
    float cellRand2 = random2d(ij + 454.4543);
    if (cellRand2 > 0.5){
      break; 
    }
  }
  float c = letter(uv, 1.0 / (dims));
  float scrollPos = gTime*speed/10 + 0.5;
  float showPos = -ij.y + cellRand;
  float fade = smoothstep(showPos ,showPos + 0.5, scrollPos );
  c *= fade;
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