

Shader "Custom/OutlineGlow2"
{
//http://www.shaderslab.com/demo-19---outline-3d-model.html

    Properties
    {
	_Color ("OulineColor", Color) = (1,1,1,1)
	_BodyColor ("BodyColor", Color) = (1,1,1,1)
	_Chunkieness ("Chunkieness", Range(0, 0.1)) = 0
	_CameraPull ("CameraPull", Range(-1, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
		Cull Front

        Pass
        {
		//	Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			uniform float4 _Color;
			uniform float _Chunkieness;
			uniform float _CameraPull;
			
            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				float3 color : COLOR;
				float3 normal : NORMAL;
            };



            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				float3 normal = mul((float3x3) UNITY_MATRIX_MV, v.normal);
				normal.x *= UNITY_MATRIX_P[0][0];
				normal.y *= UNITY_MATRIX_P[1][1];
				o.vertex.xy += normal.xy * _Chunkieness;
			
			float3 cameraVector = o.vertex.xyz - _WorldSpaceCameraPos;
			o.vertex.xyz += cameraVector * _CameraPull;
				
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET
            {
				return _Color;
            }
            ENDCG
        }

		
		        Pass
        {
		//	Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			uniform float4 _Color;
			uniform float _Chunkieness;
			uniform float4 _BodyColor;
			
            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

				
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET
            {
				return _BodyColor;
            }
            ENDCG
        }
    }
}
