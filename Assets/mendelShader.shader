Shader "Hidden/mendelShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Area ("Area", vector) = (0,0,4,4)
        _Angle("Angle", range(-3.1415,3.1415)) = 0
        _MaxIterations("Iterations max", int) = 100
        _InColor ("InColor", color) = (1,1,1)
        _Color ("Color", float) = 0
        _Zmax ("Zmax", float) = 2
        _Repeat ("Repeat", float) = 10
        _Speed ("Speed", float) = 0.1
        
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 _Area;
            float4 _InColor;
            float _Color;
            float _Zmax;
            float _Angle;
            float _Repeat;
            float _MaxIterations;
            float _Speed;
            sampler2D _MainTex;

            float2 rotate(float2 p, float2 pivot, float angle){
                p -= pivot;
                p = float2(p.x * cos(angle) - p.y * sin(angle), p.y * cos(angle) + p.x * sin(angle));
                return p + pivot;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 c = _Area.xy + (i.uv-.5) * _Area.zw;
                c = rotate(c, _Area.xy, _Angle);
                float2 z = c;
                
                float iter;
                for(iter = 0; iter < _MaxIterations; iter++){
                    z = float2(z.x * z.x - z.y * z.y, 2 * z.x * z.y) + c;

                    if(dot(z, z) > _Zmax * _Zmax) break;
                }
                if(iter > _MaxIterations) return _InColor;
                
                float dist = length(z) ;
                float fracIter = log2( log(dist) / log(_Zmax));
                iter -= fracIter;

                float m = sqrt(iter / _MaxIterations);
                return tex2D(_MainTex, float2(m * _Repeat * _Time.y * _Speed, _Color));

            }
            ENDCG
        }
    }
}
