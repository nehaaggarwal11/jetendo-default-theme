<cfcomponent>
<cfoutput>
<cffunction name="init" localmode="modern" access="public">
	<cfscript>
	// TODO: consider automating the save of home page and fast track config to their default values so the site loads immediately on creation.
	arrHome = application.zcore.siteOptionCom.optionGroupStruct( 'Home Page' );
	arrConfig = application.zcore.siteOptionCom.optionGroupStruct( 'Theme Config' );
	if ( arrayLen( arrHome ) EQ 0 ) {
		echo( 'You must save "Home Page" in manager first.');
	}
	if ( arrayLen( arrConfig ) EQ 0 ) {
		echo( 'You must save "Theme Config" in manager first.');
	}else{
		request.themeConfig = arrConfig[ 1 ];
	}
	</cfscript>
</cffunction>

<cffunction name="getThemeStylesheets" localmode="modern" access="public">
	<cfscript>
	themePath="/zthemes/jetendo-default-theme/base/stylesheets/";
	//themePath="/stylesheets/theme/";
	arrCSS=[];
 
	arrayAppend(arrCSS,  '#themePath#theme.css' );

	if ( request.themeConfig['Header Layout'] EQ 'custom' ) {

	} else if ( request.themeConfig['Header Layout'] EQ 'default' ) {
	} else if ( request.themeConfig['Header Layout'] EQ 'simpleLogoPhoneMenuHeader' ) {
		
	} else if ( request.themeConfig['Header Layout'] EQ 'logo-vertical-center-top-bar-address-social' ) {
		arrayAppend(arrCSS,  '#themePath#header-logo-vertical-center-top-bar-address-social-theme.css' );
	}
 
	return arrCSS;
	</cfscript>
</cffunction> 

<cffunction name="getThemeAbsolutePathStylesheets" localmode="modern" access="public">
	<cfscript>
	// Font Awesome
	arrCSS=[];
	themePath=request.zos.installPath&"themes/base/jetendo-default-theme/stylesheets/";
	//themePath=request.zos.globals.homeDir&"stylesheets/theme/";
 
	arrayAppend(arrCSS,  '#themePath#theme.css' );

	if ( request.themeConfig['Header Layout'] EQ 'custom' ) {
	} else if ( request.themeConfig['Header Layout'] EQ 'default' ) {
	} else if ( request.themeConfig['Header Layout'] EQ 'simpleLogoPhoneMenuHeader' ) {

	} else if ( request.themeConfig['Header Layout'] EQ 'logo-vertical-center-top-bar-address-social' ) {
		// 2 - Logo Vertically Centered on Main Navigation + Top Bar Address/Social
		arrayAppend(arrCSS,  '#themePath#header-logo-vertical-center-top-bar-address-social-theme.css' );
	}
 
	return arrCSS;
	</cfscript>
</cffunction> 

<cffunction name="mapLocation" localmode="modern" access="public">
	<cfargument name="mapLocation" type="struct" required="yes">
	<cfargument name="mapHeight" type="string" required="no" default="420px">
	<cfscript>
	var mapLocation = arguments.mapLocation;
	var mapHeight   = arguments.mapHeight;
	arrLocation=[];
	ts={
		coordinates:mapLocation["Map Location"],
		info:"#mapLocation["Street Address"]#<br />#mapLocation["City"]#, #mapLocation["State"]# #mapLocation["Zip Code"]#"
	};
	arrayAppend(arrLocation, ts);
	</cfscript>

	<cfsavecontent variable="scriptOutput">
		<script type="text/javascript">
			/* <![CDATA[ */
			zArrMapFunctions.push(function(){
				var curMap=false;
				var arrAdditionalLocationLatLng=#serializeJson(arrLocation)#;
				var markerCompleteCount=0;
				var arrMarker=[];
				function markerCallback(markerObj, location){
					markerCompleteCount++;
					if(markerCompleteCount ==arrAdditionalLocationLatLng.length){
						zMapFitMarkers(curMap, arrMarker);
					}
				}
				if(arrAdditionalLocationLatLng.length){
					var optionsObj={
						zoom: 15,
						scrollwheel: false,
						mapTypeControl: false,
						navigationControl: false,
						streetViewControl: false
					};
					var mapOptions = {
						zoom: 8,
						mapTypeId: google.maps.MapTypeId.ROADMAP
					}
					for(var i in optionsObj){
						mapOptions[i]=optionsObj[i];
					}
					$("##mapContainerDiv").show();
					curMap=zCreateMap("mapDivId", mapOptions);
					for(var i=0;i<arrAdditionalLocationLatLng.length;i++){
						var c=arrAdditionalLocationLatLng[i];
						var markerObj={};
						markerObj.infoWindowHTML=c.info;
						var arrLatLng=arrAdditionalLocationLatLng[i].coordinates.split(",");
						var marker=zAddMapMarkerByLatLng(curMap, markerObj, arrLatLng[0], arrLatLng[1], markerCallback);
						arrMarker.push(marker);
					}
				}
			});
			/* ]]> */
		</script>
	</cfsavecontent>

	<cfsavecontent variable="mapHTML">
		<div id="mapContainerDiv" style="width: 100%; display: none; float: left;">
			<div style="width: 100%; float: left; height: #mapHeight#;" id="mapDivId"></div>
		</div>
	</cfsavecontent>

	<cfscript>
		return {
			scriptOutput: scriptOutput,
			mapHTML: mapHTML
		};
	</cfscript>
</cffunction>
 
<cffunction name="getConfigCSS" localmode="modern" access="public">
	<cfsavecontent variable="styleTagCode">
		/* Link colors */
		a { color: ###request.themeConfig["Link Color"]#; }
		a:hover { color: ###request.themeConfig["Link Hover Color"]#; }

		/* Heading colors */
		.jdt-heading { color: ###request.themeConfig["Heading Color"]# !important; }

		/* Heading on accent color background */
		.jdt-accent-bg .jdt-heading { color: ###request.themeConfig["Heading On Accent Color"]# !important; }

		/* Accent colors */
		.jdt-accent { color: ###request.themeConfig["Accent Color"]# !important; }
		.jdt-accent-bg { background-color: ###request.themeConfig["Accent Color"]# !important; }
		.jdt-call-phone .jdt-call-phone-phone-number { color: ###request.themeConfig["Accent Color"]# !important; }

		/* Text on accent color background */
		.jdt-accent-bg { color: ###request.themeConfig["Text On Accent Color"]# !important; }

		/* Link on accent color background */
		.jdt-accent-bg a { color: ###request.themeConfig["Link On Accent Color"]#; }
		.jdt-accent-bg a:hover { color: ###request.themeConfig["Link On Accent Hover Color"]#; }

		/* Button colors */
		.z-button {
			color: ###request.themeConfig["Button Text Color"]# !important;
			background-color: ###request.themeConfig["Button BG Color"]# !important;
		}
		.z-button:hover {
			color: ###request.themeConfig["Button Text Hover Color"]# !important;
			background-color: ###request.themeConfig["Button BG Hover Color"]# !important;
		}
		.z-button.jdt-transparent {
			color: ###request.themeConfig["Button BG Color"]# !important;
			background-color: transparent !important;
		}
		.z-button.jdt-transparent:hover {
			color: ###request.themeConfig["Button BG Hover Color"]# !important;
			background-color: transparent !important;
		}

		/* Button colors on accent color background */
		.jdt-accent-bg .z-button {
			color: ###request.themeConfig["Button On Accent Text Color"]# !important;
			background-color: ###request.themeConfig["Button On Accent BG Color"]# !important;
		}
		.jdt-accent-bg .z-button:hover {
			color: ###request.themeConfig["Button On Accent Text Hover Color"]# !important;
			background-color: ###request.themeConfig["Button On Accent BG Hover Color"]# !important;
		}
		.z-button.jdt-transparent {
			color: ###request.themeConfig["Button On Accent BG Color"]# !important;
			background-color: transparent !important;
		}
		.z-button.jdt-transparent:hover {
			color: ###request.themeConfig["Button On Accent BG Hover Color"]# !important;
			background-color: transparent !important;
		}

		/* Additional colors */
		.jdt-homepage-slider-container {
			border-bottom: 10px solid ###request.themeConfig["Accent Color"]#;
		}

		.zinquiry-form-table button[type="submit"],
		.jdt-lead-form .table-list button[type="submit"] {
			color: ###request.themeConfig["Button Text Color"]# !important;
			background-color: ###request.themeConfig["Button BG Color"]# !important;
		}
		.zinquiry-form-table button[type="submit"]:hover,
		.jdt-lead-form .table-list button[type="submit"]:hover {
			color: ###request.themeConfig["Button Text Hover Color"]# !important;
			background-color: ###request.themeConfig["Button BG Hover Color"]# !important;
		}

		.jdt-accent-bg .zinquiry-form-table button[type="submit"],
		.jdt-lead-form.jdt-accent-bg .table-list button[type="submit"] {
			color: ###request.themeConfig["Button On Accent Text Color"]# !important;
			background-color: ###request.themeConfig["Button On Accent BG Color"]# !important;
		}
		.jdt-accent-bg .zinquiry-form-table button[type="submit"]:hover,
		.jdt-lead-form.jdt-accent-bg .table-list button[type="submit"]:hover {
			color: ###request.themeConfig["Button On Accent Text Hover Color"]# !important;
			background-color: ###request.themeConfig["Button On Accent BG Hover Color"]# !important;
		}

		.jdt-lead-form.jdt-accent-bg th { color: ###request.themeConfig["Text On Accent Color"]# !important; }



		<cfif request.themeConfig['Contact Form Company']>
		<cfelse>
			##zInquiryFormTRCompany { display: none; }
		</cfif>

		<cfif request.themeConfig['Contact Form Address']>
		<cfelse>
			##zInquiryFormTRAddress { display: none; }
		</cfif>

		<cfif request.themeConfig['Contact Form City']>
		<cfelse>
			##zInquiryFormTRCity { display: none; }
		</cfif>

		<cfif request.themeConfig['Contact Form State']>
		<cfelse>
			##zInquiryFormTRState { display: none; }
		</cfif>

		<cfif request.themeConfig['Contact Form Country']>
		<cfelse>
			##zInquiryFormTRCountry { display: none; }
		</cfif>

		<cfif request.themeConfig['Contact Form Zip']>
		<cfelse>
			##zInquiryFormTRZip { display: none; }
		</cfif>

		<cfif request.themeConfig['Contact Form Privacy Policy']>
		<cfelse>
			.zPrivacyPolicyLink { display: none; }
		</cfif>


		<cfif request.themeConfig['Enable Newsletter Signup']>
		<cfelse>
			.znewslettercheckbox { display: none; }
		</cfif>
	</cfsavecontent>
	<cfreturn styleTagCode>
</cffunction>

</cfoutput>
</cfcomponent>
