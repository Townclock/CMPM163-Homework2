Shader "Custom/BloomCutter" {
//https://lindenreid.wordpress.com/2018/03/17/x-ray-shader-tutorial-in-unity/
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_XRayColor ("XRayColor", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

	}
	SubShader {
	
    Tags { "Queue"="Transparent"}
Pass {  // main body pass
 
    Tags { "Queue"="Opaque"}
		LOD 200
		
		Stencil {
			Ref 4
			Comp Always
			Pass Replace
			ZFail keep 
			}
    
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

      uniform float4 _Color;
      uniform float4 _XRayColor;
            struct appdata
            {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
            };

            struct v2f
            {
                    float4 vertex : SV_POSITION;
                    float3 normal : NORMAL;       
                    float3 vertexInWorldCoords : TEXCOORD1;
            };

 
           v2f vert(appdata v)
           { 
                v2f o;
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
                o.vertex = UnityObjectToClipPos(v.vertex); 
               
                return o;
           }

           fixed4 frag(v2f i) : SV_Target
           {
                return _Color;

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
		#pragma vertex vert
		#pragma fragment frag

      uniform float4 _Color;
      uniform float4 _XRayColor;
            struct appdata
            {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
            };

            struct v2f
            {
                    float4 vertex : SV_POSITION;
                    float3 normal : NORMAL;       
                    float3 vertexInWorldCoords : TEXCOORD1;
            };

 
           v2f vert(appdata v)
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
