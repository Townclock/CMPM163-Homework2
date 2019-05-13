Shader "Custom/Bloom" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_PullBrightnessDistance ("PullBrightnessDistance", Int) = 1
		_Distance ("Jump", Int) = 1
		_RedThreshold ("RedThreshold", Range(0, 0.5)) = 0
		_BlueThreshold ("BlueThreshold", Range(0, 0.5)) = 0
		_GreenThreshold ("GreenThreshold", Range(0, 0.5)) = 0
	}

	SubShader {
	Pass {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma vertex vert
		#pragma fragment frag
		

		sampler2D _MainTex;
		fixed4 _Color;
    uniform float _PullBrightnessDistance;
    uniform float4 _MainTex_TexelSize;
    uniform int _Distance;
    uniform float _RedThreshold;
    uniform float _GreenThreshold;
    uniform float _BlueThreshold;


		   struct appdata {
		   float2 uv : TEXCOORD0;
		      float4 vertex : POSITION;
		   };
		 
		 struct vertex_to_fragment {	 
		   float2 uv : TEXCOORD0;
		   float4 vertex: SV_POSITION;
		   float3 vertex_in_world_coordinates : TEXCOORD1;
		 };
		 
		 vertex_to_fragment vert (appdata v){
		   vertex_to_fragment o;
		   
		   o.vertex_in_world_coordinates = mul(unity_ObjectToWorld, v.vertex);

		   o.vertex = UnityObjectToClipPos(v.vertex);
		   
		   
       o.uv = v.uv;
		   return o;
		 }
		 
		 fixed4 frag (vertex_to_fragment i) : SV_TARGET
		 {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, i.uv) * _Color;
			
			  float2 texel = float2(
            _MainTex_TexelSize.x * _Distance, 
            _MainTex_TexelSize.y * _Distance
        );
			
			fixed4 threshold = c;
			for (int k = -_PullBrightnessDistance; k < _PullBrightnessDistance ; k++)
			    for (int j = -_PullBrightnessDistance; j < _PullBrightnessDistance ; j++)
			    {
			            threshold.r = max(tex2D( _MainTex, i.uv + texel * float2( k, j )), threshold.r) ;
			            threshold.g = max(tex2D( _MainTex, i.uv + texel * float2( k, j )), threshold.g) ;
			            threshold.b = max(tex2D( _MainTex, i.uv + texel * float2( k, j )), threshold.b) ;
			    }
			if (c.r + _RedThreshold < threshold.r)
			    c.r = threshold.r;
			if (c.g + _GreenThreshold < threshold.g)
			    c.g = threshold.g;
			if (c.b + _BlueThreshold < threshold.b)
			    c.b = threshold.b;

     return c;
		 
		 }

		ENDCG
	}
	}
	//FallBack "Diffuse"
}
