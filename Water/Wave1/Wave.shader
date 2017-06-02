Shader "My/Wave"
{
	Properties
	{
		_MainColor ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_MainTex ("Texture", 2D) = "white" {}
		_Crest ("（波峰）Crest", Range(0.1, 1.0)) = 0.1
		_Cycle ("（周期）Cycle", Range(1.0, 100.0)) = 1
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
            
            uniform float _Crest;
            uniform float _Cycle;
            uniform float4 _MainColor;
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

            float rand(float2 co)
            {
    			return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
			}

			float poltergeist(in float2 coordinate, in float seed)
			{
			    return frac(sin(dot(coordinate*seed, float2(12.9898, 78.233)))*43758.5453);
			}

			v2f vert (appdata v)
			{
				/*
				正弦型函数解析式：y=Asin(ωx+φ)+b
				各常数值对函数图像的影响：
				φ：决定波形与X轴位置关系或横向移动距离（左加右减）
				ω：决定周期（最小正周期T=2π/∣ω∣）
				A：决定峰值（即纵向拉伸压缩的倍数）
				b：表示波形在Y轴的位置关系或纵向移动距离（上加下减）
				*/

				float offset1 = _Crest * sin(_Time.y * _Cycle + v.vertex.x + v.vertex.z);
                /*
                float offset2 = _CosTime.w * poltergeist(v.uv, _Time.x)	;
                float offset3 = poltergeist(v.uv, frac(_Time.x));
                float offset4 = poltergeist(v.uv, _SinTime.x);
                float offset5 = sin(_Time.w * 10 + offset4);
                */
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex.y += offset1;
				o.vertex.y +=  _Crest * sin(length(v.vertex.xz)*10 + _Time.y * _Cycle);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				
				col *= _MainColor;
				return col;
			}
			ENDCG
		}
	}
}
