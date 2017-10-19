<cfcomponent implements="zcorerootmapping.interface.view" extends="jetendo-themes.jetendo-default-theme.base.templates.default-theme">
<cfoutput> 
<cffunction name="init" access="public" returntype="string" localmode="modern">
	<cfscript> 
	super.init();
 
	//application.zcore.skin.includeCSS( '/zthemes/jetendo-default-theme/base/stylesheets/dark-theme.css' );
	application.zcore.skin.includeCSS( '/stylesheets/style.css' );
	//application.zcore.skin.includeJS( '/javascript/custom.js' ); 
	</cfscript>
</cffunction>

<cffunction name="render" access="public" returntype="string" localmode="modern">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfscript>
		var tagStruct = arguments.tagStruct;
	</cfscript>
	<cfsavecontent variable="output">
		<cfscript>
			// use this code to generate the div and img element css code for all the theme images
			// local.output=request.zos.functions.zGetImageCSSCode("#request.zos.globals.homedir#images/shell/", "/images/shell/");
			// writeoutput('<textarea name="test" cols="100" rows="10">'&local.output&'</textarea>');
			// request.zos.functions.zabort();

			// regex to extract inline styles for external stylesheets
			// replace: .*?(class="(sh-[0-9]*)" style="([^"]*)")
			// with: .\2{\3}\n

			// remove other stuff between classes: ^[^\.\n][^\n]*$

			// then remove the style="" with this one:
			// (class="sh-[0-9]*") style="[^"]*"
			// \1
		</cfscript>
		<!DOCTYPE html>
		<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
		<!--[if IE 7]> <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
		<!--[if IE 8]> <html class="no-js lt-ie9"> <![endif]-->
		<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
		<head>
			<meta charset="utf-8" />
			<title>#tagStruct.title ?: ""#</title>
			#tagStruct.stylesheets ?: ""#
			#tagStruct.meta ?: ""#

		</head>
		<body class="#bodyClass()#">
			<!--- 
			TODO: implement theme as a group of functions in the base component, that can be overridden in this component, or not displayed at all.
			 --->
			<header>
				<cfscript>
				config={
					topText:"",
					mobileHeader:{
						fixedPosition:true, // true will keep header at top when scrolling down.
						alwaysShow:false, // true will enable 3 line menu button on desktop
						menuOnLeft:true, // true will put menu icon on left
						menuTopHTML:'',//<div class="z-float">Top stuff</div>', 
						menuBottomHTML:'',//<div class="z-float">Bottom stuff</div>', 
						logoHTML:'<div class="z-float"><a href="/"><img src="#request.themeConfig['Logo']#" alt="#htmleditformat(request.themeConfig['Full Name'])#" class="z-fluid"></a></div>',
						//logoHTML:'<div class="z-float"><a href="/"><img src="/images/logo.png" alt="#htmleditformat('')#" class="z-fluid"></a></div><a class="z-show-at-479 zPhoneLink z-mobile-header-mobile-phone-link">123-123-1234</a>',
						tabletSideHTML:'<div class="z-fluid-at-767 jdt-header-right">
							<a href="tel:#reReplace( request.themeConfig['Phone Number'], '[^0-9]', '', 'ALL' )#" class="jdt-call-phone">
								<div class="jdt-call-phone-heading">#request.themeConfig['Header Call Now Text']#</div>
								<div class="jdt-call-phone-phone-number">#application.zcore.functions.zFormatPhoneNumber( request.themeConfig['Phone Number'] )#</div>
							</a>
						</div>',
						//tabletSideHTML:'<div class="z-hide-at-479 z-float z-mt-10"><a class="zPhoneLink z-mobile-header-tablet-phone-link">123-123-1234</a></div>', // if not an empty string, the logo will be centered.
						arrLink:[]
					}
				}; 
				</cfscript>
				#displayHeader(tagStruct, config)#
			</header>

			<cfif structKeyExists( request, 'customPage' )>
				#tagStruct.content ?: ''#
			<cfelse>
				<cfsavecontent variable="bodyHTML">
					#displaySubpageContent(tagStruct)#
				</cfsavecontent>
				<cfscript>
				// pass one section to this function instead:
				currentSection=request.defaultSubpageCom.getCurrentSection(application.zcore.siteOptionCom.optionGroupStruct("Section"));
				config={
					defaultSubpage:{
						defaultSectionImage:"/images/cbg.jpg",
						defaultSectionMobileImage:"/images/cbgmobile.jpg",
						currentSection:currentSection, // required
						bodyHTML:bodyHTML, // optional, can be empty string
						sidebarTopHTML:"", // optional, can be empty string
						sidebarBottomHTML:"" // optional, can be empty string
					}
				} 
				if(currentSection.success){
					config.defaultSubpage.sectionHeading=currentSection.section["Section Heading"]; // optional, can be empty string
					config.defaultSubpage.sidebarHeading="";//currentSection.section["Name"]; // optional, can be empty string
				}
				</cfscript>
				#displaySubpage(tagStruct, config)#
			</cfif>
			#displayNewsletterSignupFormFooterSection(tagStruct)#

			<cfif request.zos.originalURL NEQ "/">
				#displayCompanyContactFooterSection(tagStruct)#

				#displayMapFooterSection(tagStruct)#
			</cfif>

			<footer>
				#displayFooterMenu(tagStruct)#

				<cfscript>
				config={
					additionalHTML:'&middot;
					Website by Zgraph - <a href="http://www.zgraph.com/" target="_blank" class="jdt-zgraph-link">Florida Web Design &amp; Marketing</a>'
				};
				</cfscript>
				#displayFooterCopyright(tagStruct, config)#
			</footer>

			#tagStruct.scripts ?: ''#
			#request.zos.functions.zvarso( 'Visitor Tracking Code' )#
		</body>
		</html>
	</cfsavecontent>
	<cfreturn output>
</cffunction>

<cffunction name="customHeader" localmode="modern" access="private">
	You must configure theme to have "Header" set to custom for this to execute.
	Refer to the theme's default-theme.cfc customHeader() function for an example.
</cffunction>

<!--- You can override some parts of the theme by overriding a function like the example below. --->
<!--- 
<cffunction name="displayHeader" localmode="modern" access="public">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfscript>
	tagStruct=arguments.tagStruct;
	</cfscript>
</cffunction>
 --->

</cfoutput>
</cfcomponent>
