Shader "Custom/ReflectionBuzz"
{
	Properties
	{
		_Cube ("Cube", Cube) = "" {}
		_Color ("Color", Color) = (0, 0, 0, 0)
		_MainTex ("Texture", 2D) = "white" {}
		[Toggle]_ReflectRefract ("Turn on Refracted Reflections", float) = 1
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
				float2 uv : TEXCOORD1;	
		  };

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normalInWorldCoords : NORMAL;
				float3 vertexInWorldCoords : TEXCOORD1;
				float2 uv : TEXCCORD0;
			};

			uniform samplerCUBE _Cube;
			uniform float4 _Color;
			uniform float2 _MainTex_TexelSize;
			uniform sampler2D _MainTex;
			uniform float4 	_MainTex_ST;
			uniform float _ReflectRefract;
			
			v2f vert (appdata v)
			{
				v2f o;
				
				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex);
				
				o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal);
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				 o.uv = TRANSFORM_TEX(v.uv, _MainTex) + _Time.y/20;
				 
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
		    float3 position = i.vertexInWorldCoords.xyz;
		    
			
			
		    //rays from cube to camera
		    float3 vIncident = normalize(position - _WorldSpaceCameraPos);
		    
		    //reflect across the normal to the opposite edge of the skybox
		    
			
			
			
			
			//normal fiddler
					    	 //taken from exaple code for edge 
		     float2 texel = float2(
				_MainTex_TexelSize.x * 1, 
				_MainTex_TexelSize.y * 1
           );
		    float tx1y0 = tex2D( _MainTex, i.uv + texel * float2( -1, 0 ) ).r ;;
		    float tx2y0 = tex2D( _MainTex, i.uv + texel * float2( 1, 0 ) ).r ;;
		    
		    //tx1y0 -= tex2D(_MainTex, i.uv).r;
		    
        float tx0y1 = tex2D( _MainTex, i.uv + texel * float2( 0,  1 ) ).r ;
        float tx0y2 = tex2D( _MainTex, i.uv + texel * float2( 0,  -1 ) ).r ;
		      
		    //tx0y1 = tx1y0 -= tex2D(_MainTex, i.uv).r;
		      
		      
		      
		   // float3 normal = cross(normalize(float3(-1, tx1y0, 0)), normalize(float3(0, tx0y1, 1)));
		  
		  float3 normal = float3(tx1y0 - tx2y0, 0.5, tx0y1 - tx0y2);
		  
		    normal = normalize(normal);
			
			
			
			
			
			
			
			
			
			
			float3 vReflect = reflect(vIncident, normal);//float3(0, 1, 0));
			
			//float3 vReflect = reflect(vIncident, i.normalInWorldCoords);
		    //vReflect.x *= abs(_SinTime.y);
			float4 reflectColor;
				//sample the skybox
				
				if ((i.uv.x % 0.2 < 0.1) && ! (i.uv.y % 0.2 < 0.1) || !(i.uv.x % 0.2 < 0.1) &&  (i.uv.y % 0.2 < 0.1) || ! _ReflectRefract)
					reflectColor = texCUBE(_Cube, vReflect);
				else
					reflectColor = texCUBE(_Cube, (vReflect+ normal/2)/1.5);
				
				float4 tex = tex2D(_MainTex, i.uv) ;
		
				
				return (  reflectColor );
		  }
			ENDCG
		}
	}

    Fallback "Diffuse"
}
