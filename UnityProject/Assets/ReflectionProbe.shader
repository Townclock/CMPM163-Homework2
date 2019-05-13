Shader "Custom/ReflectionBuzz"
{
//https://gist.github.com/josephbk117/a43f5335cea9b3e12a44f196dc81f30f
	Properties
	{
		_MainTex ("Texture", 2D) = "" {}
		_Color ("Color", Color) = (0, 0, 0, 0)
		
		_Roughness("Roughness", Range(0.0, 10.0)) = 0.0
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
		    float3 normal : NORMAL;		
                float2 uv : TEXCOORD0;
		  };

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normalInWorldCoords : NORMAL;
				float3 vertexInWorldCoords : TEXCCORD1;
			};

			uniform samplerCUBE _Cube;
			uniform float4 _Color;
			uniform float _Roughness;
			uniform sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				
				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex);
				
				o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal);
				
				float4 transform = v.vertex;
				float2 uv = v.uv;
				uv.x += (_Time.y % 2);
				float4 tex = tex2Dlod (_MainTex, float4(uv,0,0));
				transform *= (1 + tex.y);
				o.vertex = UnityObjectToClipPos(transform);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
		    float3 position = i.vertexInWorldCoords.xyz;
		    float3 vIncident = normalize(position - _WorldSpaceCameraPos);
			
		    float3 vReflect = reflect(vIncident, i.normalInWorldCoords);
					/*If Roughness feature is not needed : UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, reflection) can be used instead.
					It chooses the correct LOD value based on camera distance*/
            half4 skyData = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, vReflect, _Roughness);
            half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR); // This is done becasue the cubemap is stored HDR
            return half4(skyColor, 1.0);
	
		  }
			ENDCG
		}
	}

    Fallback "Diffuse"
}
