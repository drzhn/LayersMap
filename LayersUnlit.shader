Shader "Unlit/LayersUnlit"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color1("Color1", Color) = (0,0,0,0)
		_Color2("Color2", Color) = (0,0,0,0)
		_HeightRange("MaxHeight", Float) = 1
		_TexMultiplier("Tex Mul", Float) = 1

	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100

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
					float3 worldPos : TEXCOORD1;
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _Color1;
				float4 _Color2;
				float _HeightRange;
				float _TexMultiplier;

				v2f vert(appdata v)
				{
					v2f o;
					o.worldPos = mul(unity_ObjectToWorld, v.vertex);
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					float t = clamp(i.worldPos.y / _HeightRange, 0,1);
					float h = tex2D(_MainTex,float2(i.worldPos.x/_TexMultiplier + _Time.y/8, i.worldPos.z/_TexMultiplier)).r;
					clip(t > h ? -1 : 1);
					fixed4 col = lerp(_Color1, _Color2, t);
					return col;
				}
			ENDCG
		}
		}
}
