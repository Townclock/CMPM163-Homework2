Shader "Custom/OutlineGlow"
{
//https://gamedevhappens.wordpress.com/2014/03/23/unity-3d-wireframe-odyssey-1-shader-method/


    Properties
    {
	_Color ("Body Color", Color) = (1,1,1,1)
	_BodyColor ("Body Color", Color) = (0,0,0,0)
	//_Chunkieness = ("Chunkieness", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Fade" }
        LOD 100

        Pass
        {
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			uniform float4 _Color;
			uniform float4 _BodyColor;
			uniform float _Chunkieness;
			
            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
            };



            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

				
				//https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				//https://docs.unity3d.com/Manual//SL-UnityShaderVariables.html
				float3 cameraAngle = normalize( i.vertex.xyz - _WorldSpaceCameraPos);
                float edgieness = dot(cameraAngle, i.normal);
			   
                
				
				float4 col = float4(0,0,0,1);
				col.xyz = 1 - edgieness;
                return col;
            }
            ENDCG
        }
    }
}
