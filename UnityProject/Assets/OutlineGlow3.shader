

Shader "Custom/OutlineGlow3"
{
//https://www.youtube.com/watch?v=SlTkBe4YNbo

    Properties
    {
	_MainTex ("Texture", 2D) = "white" {}
	_Color ("OulineColor", Color) = (1,1,1,1)
	_BodyColor ("BodyColor", Color) = (1,1,1,1)
	_Chunkieness ("Chunkieness", Range(0, 2)) = 0
	_CameraPull ("CameraPull", Range(-0.1, 0.1)) = 0
	
	_XRayColor ("XRayColor", Color) = (1,1,1,1)
    }
	

				
            CGINCLUDE	
            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
            };

            struct v2f
            {
				float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
                    float3 vertexInWorldCoords : TEXCOORD1;
            };
		
			uniform float4 _Color;
			uniform float _Chunkieness;
			uniform float4 _BodyColor;
			uniform float _CameraPull;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform	float4 _XRayColor;

            #include "UnityCG.cginc"


            v2f vert (appdata v)
            {
				
				v.vertex.xyz *= _Chunkieness;
			
                v2f o;
				
				
				
                o.vertex = UnityObjectToClipPos(v.vertex);
				float3 cameraVector = o.vertex.xyz-_WorldSpaceCameraPos;
				o.vertex.xyz += cameraVector * _CameraPull;
                return o;
            }

            ENDCG

		    SubShader
		{
		Tags { "RenderType"="Opaque"}
		Pass {// Outline
			Tags {"Queue"="Transparent"}
			
			Blend SrcAlpha OneMinusSrcAlpha
			//ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			
            half4 frag (v2f i) : COLOR
            {
				return _Color;
            }
            ENDCG
        }
		Pass {// Object
		
			Tags { "Queue"="Opaque"}
        	Stencil {
				Ref 4
				Comp Always
				Pass Replace
				ZFail keep 
			}
            CGPROGRAM
            #pragma vertex vert2
            #pragma fragment frag
			
				//Cull Front
			v2f vert2 (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
               
				
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
            half4 frag (v2f i) : COLOR
            {
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
				//return _BodyColor;
            }
			
            ENDCG
        }
		Pass {  //XRAY
  
    Stencil {
      Ref 3
      Comp Greater
      Fail Keep
      Pass Replace
    }
  
    ZWrite Off
    ZTest Always
    Blend SrcAlpha OneMinusSrcAlpha
    
		CGPROGRAM
		#pragma vertex vert3
		#pragma fragment frag

           v2f vert3(appdata v)
           { 
                v2f o;
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
                o.vertex = UnityObjectToClipPos(v.vertex); 
               
                return o;
           }

           fixed4 frag(v2f i) : SV_Target
           {
                return _XRayColor;

            }
		ENDCG
	  }
    }
}
