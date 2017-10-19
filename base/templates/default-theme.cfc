<cfcomponent>
<cfoutput>
<cffunction name="init" localmode="modern" access="private">
	<cfscript>
	if(request.themeConfig["Header Layout"] EQ "defaultHeader"){
		request.mobileHeaderCom=application.zcore.functions.zcreateobject("component", "zcorerootmapping.com.display.mobileHeader");
		request.mobileHeaderCom.init(); // call this in template init function before including other stylesheets
	}
	if(request.zos.originalURL EQ "/"){
		if(request.themeConfig["Home Google Map"]){
			application.zcore.functions.zRequireGoogleMaps();
		}
	}else{
		if(request.themeConfig['Subpage Google Map']){
			application.zcore.functions.zRequireGoogleMaps();
		}
		request.defaultSubpageCom=createobject("component", "zcorerootmapping.com.display.defaultSubpage");
		request.defaultSubpageCom.init(); // call this in template init function before including other stylesheets 
	}
	tempPath=request.zos.globals.privateHomeDir&"zcache/theme-published.css";
	application.zcore.skin.includeCSS("/z/font-awesome/css/font-awesome.min.css");
	if(structkeyexists(application.sitestruct[request.zos.globals.id].fileExistsCache, tempPath)){
		exists=application.sitestruct[request.zos.globals.id].fileExistsCache[tempPath];
	}else{
		exists=fileexists(tempPath);
		application.sitestruct[request.zos.globals.id].fileExistsCache[tempPath]=exists;
	}
	if(not request.zos.isTestServer and exists){
		application.zcore.skin.includeCSS("/zcache/theme-published.css");
	}else{
		arrCSS=request.themeHelperCom.getThemeStylesheets();
		for(css in arrCSS){
			application.zcore.skin.includeCSS(css);
		}
		application.zcore.skin.includeCSS("/jetendo-themes/jetendo-default-theme/base/pages/publish-theme.cfc?method=debug");
	}

	application.zcore.skin.addDeferredScript("
		$( '.mobileMenuButton' ).bind( 'click', function() {
			$( '.mobileMenuDiv' ).slideToggle( 'fast' );
			return false;
		} );
	");  
	</cfscript>
</cffunction>

<cffunction name="bodyClass" localmode="modern" access="private">
	<cfscript>
	var bodyClass = '';

	if ( request.zos.originalURL EQ '/' ) {
		bodyClass &= ' jdt-home';
	} else {
		bodyClass &= ' jdt-default';
	}

	if ( request.themeConfig['Layout Width'] EQ 'Narrow' ) {
		bodyClass &= ' jdt-fixed';
	} else {
		// Only premium can have a fluid layout width.
		bodyClass &= ' jdt-fluid';
	}

	return bodyClass;
	</cfscript>
</cffunction>

<cffunction name="displayHeader" localmode="modern" access="private">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfargument name="config" type="struct" required="yes">
	<cfscript>
	if(not structkeyexists(variables, request.themeConfig['Header Layout'])){
		throw( 'Invalid header layout: #request.themeConfig['Header Layout']#.' );
	}else{
		variables[request.themeConfig['Header Layout']](arguments.tagStruct, arguments.config);
	}
	</cfscript>
</cffunction>

<cffunction name="displaySubpageContent" localmode="modern" access="private">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfscript>
	tagStruct=arguments.tagStruct;
	</cfscript>
	<div class="z-float jdt-subpage-content">
		<cfif request.zos.template.getTagContent('pagetitle') NEQ ''>
			<h1>#tagStruct.pagetitle ?: ''#</h1>
		</cfif>

		#tagStruct.content ?: ''#
	</div>
</cffunction>

<cffunction name="displaySubpage" localmode="modern" access="private">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfargument name="config" type="struct" required="yes">
	<cfscript>
	tagStruct = arguments.tagStruct;
	config=arguments.config;
 
	/*
	The site option group structure must be exactly this to use this code:
		Section
			Name // text field, required
			URL // url field
			Application // select, optional - Give it list labels/values of Blog|Event|Job including only what the site needs
			Section Heading // text field, required
			Image (3840x800 for 4k or 1920x400 for 1080p) // image, optional
			Mobile Image (960 x 400) // image, optional
			Sub-group: Link
				Link Text // text field, required
				URL // url field, required
	*/
	 
	// need a get current section function that returns the current section.
	 
	request.defaultSubpageCom.displaySubpage(config.defaultSubpage); // run where you want it to output
	</cfscript> 



<!--- 
jake's sidebar code:

	<section class="jdt-subpage-main-container">
		<div class="z-container">
			<div class="jdt-subpage-main">
				<div class="z-3of4 z-p-0 z-fluid-at-992 jdt-subpage-content jdt-subpage-content-sidebar">
					<div class="z-float">
						<cfif request.zos.template.getTagContent('pagetitle') NEQ ''>
							<h1 class="z-h-32 jdt-heading">#tagStruct.pagetitle ?: ''#</h1>
						</cfif>

						<div>#tagStruct.content ?: ''#</div>
					</div>
				</div>
				<div class="z-1of4 z-p-0 z-fluid-at-992 jdt-subpage-sidebar">
					<div class="z-float z-pv-40 z-ph-20">


						<cfif request.zos.tempObj.contentInstance.configCom.searchCurrentParentLinks( request.zos.originalURL )>
							<ul class="jdt-sidebar-navigation">
								<cfscript>
									sidebar = structNew();

									sidebar.sortAlpha               = true;
									sidebar.showHidden              = true;
									sidebar.delimiter               = '';
									sidebar.returnData              = true;
									sidebar.linkTextLength          = 50;
									sidebar.limit                   = 100;
									sidebar.forceLinkForCurrentPage = true;
									sidebar.content_unique_name     = '/about/index';

									sidebarLinks = application.zcore.app.getAppCFC( 'content' ).getSidebar( sidebar );
								</cfscript>
								<cfloop from="1" to="#arrayLen( sidebarLinks.arrLink )#" index="sidebarLinkIndex">
									<cfif sidebarLinks.arrLink[ sidebarLinkIndex ] EQ request.zos.originalURL>
										<li class="jdt-active"><a href="#sidebarLinks.arrLink[ sidebarLinkIndex ]#">#sidebarLinks.arrText[ sidebarLinkIndex ]#</a></li>
									<cfelse>
										<li><a href="#sidebarLinks.arrLink[ sidebarLinkIndex ]#">#sidebarLinks.arrText[ sidebarLinkIndex ]#</a></li>
									</cfif>
								</cfloop>
							</ul>
						</cfif>




					</div>
				</div>
			</div>
		</div>
	</section>

		  --->
</cffunction>

<cffunction name="displayNewsletterSignupFormFooterSection" localmode="modern" access="private">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfscript>
	tagStruct = arguments.tagStruct;
	</cfscript>
	<cfif request.themeConfig['Enable Newsletter Signup']>
		<cfif request.zos.originalURL NEQ '/z/misc/inquiry/index'>
			<section class="jdt-newsletter-container <cfif request.themeConfig["Layout Width"] EQ "Wide"> jdt-accent-bg</cfif>">
				<div class="z-container">
					<div class="z-float jdt-newsletter jdt-accent-bg">
						<h2 class="jdt-heading">Join Our Mailing List</h2>
						<div>
							<a href="##" onclick="zShowModalStandard('/z/misc/mailing-list/index?modalpopforced=1', 540, 630);return false;" rel="nofollow" class="z-button jdt-large jdt-sign-up">Sign Up</a>
						</div>
					</div>
				</div>
			</section>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="displayCompanyContactFooterSection" localmode="modern" access="private">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfscript>
	tagStruct = arguments.tagStruct;
	</cfscript>
	<cfif request.themeConfig['Subpage Company Info']>
		<section class="jdt-subpage-company-info-container">
			<div class="z-container">
				<div class="z-float jdt-subpage-company-info">
					<div class="z-1of3 z-text-center jdt-company-info-name">
						<div>#request.themeConfig['Full Name']#</div>
					</div>
					<div class="z-1of3 jdt-company-info-address">
						<i class="fa fa-map-marker fa-2x jdt-accent"></i>
						<div>#request.themeConfig['Street Address']#<br />
						#request.themeConfig['City']#, #request.themeConfig['State']# #request.themeConfig['Zip Code']#</div>
					</div>
					<div class="z-1of3 jdt-company-info-phone">
						<i class="fa fa-phone fa-2x jdt-accent"></i>
						<div>#request.themeConfig['Phone Number']#</div>
					</div>
				</div>
			</div>
		</section>
	</cfif>
</cffunction>

<cffunction name="displayMapFooterSection" localmode="modern" access="private">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfscript>
	tagStruct = arguments.tagStruct;
	</cfscript>

	<cfif request.themeConfig['Subpage Google Map']>
		<cfscript> 
		mapLocation = {
			'Street Address': request.themeConfig['Street Address'],
			'City': request.themeConfig['City'],
			'State': request.themeConfig['State'],
			'Zip Code': request.themeConfig['Zip Code'],
			'Map Location': request.themeConfig['Map Location']
		};

		map = request.themeHelperCom.mapLocation( mapLocation, '320px' );
		</cfscript>
		<section class="jdt-subpage-map-location-container">
			<div class="z-container">
				<div class="z-float" style="height: 320px; background-color: ##CCC;">
					#map.scriptOutput#
					#map.mapHTML#
				</div>
			</div>
		</section>
	</cfif>
</cffunction>

<cffunction name="displayFooterMenu" localmode="modern" access="private">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfscript>
	tagStruct = arguments.tagStruct;
	</cfscript>
	<cfif request.themeConfig['Footer Menu']>
		<cfscript>
		menuStruct = structNew();
		menuStruct.menu_name = 'Footer Menu';
		footerMenu = request.zos.functions.zMenuInclude( menuStruct );
		</cfscript>
		<cfif structKeyExists( footerMenu, 'output' ) AND NOT empty( footerMenu.output )>
			<div class="jdt-footer-menu-container">
				<div class="z-container">
					<div class="z-float jdt-footer-menu">
						<cfscript>
							writeOutput( footerMenu.output );
						</cfscript>
					</div>
				</div>
			</div>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="displayFooterCopyright" localmode="modern" access="private">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfargument name="config" type="struct" required="yes">
	<cfscript>
	tagStruct = arguments.tagStruct;
	config=arguments.config;
	</cfscript>
	<div class="jdt-footer-copyright-container">
		<div class="z-container">
			<div class="z-float z-fluid-at-992 jdt-footer-copyright">
				<div>Copyright &copy; #year( now() )# <a href="/">#request.themeConfig['Full Name']#</a> &middot; All Rights Reserved.</div>
				<div>
					<cfif request.themeConfig['Show Terms of Use Link']>
						<a href="/z/user/terms-of-use/index">Terms of Use</a> &middot;
					</cfif>
					<cfif request.themeConfig['Show Privacy Policy Link']>
						<a href="/z/user/privacy/index">Privacy Policy</a> &middot;
					</cfif>
					<a href="/z/misc/site-map/index">Site Map</a> 
					#application.zcore.functions.zso(config, 'additionalHTML')#
				</div>
			</div>
		</div> 
	</div>
</cffunction>


<cffunction name="customHeader" localmode="modern" access="private">
	<cfscript>
	throw("You must add a customHeader function to templates/default.cfc");
	</cfscript>
</cffunction>

<cffunction name="simpleLogoPhoneMenuHeader" localmode="modern" access="private">

	<div class="jdt-simple-header">
		<div class="z-container">
			<div class="jdt-header-left z-fluid-at-767 jdt-logo">
				<a href="/"><img src="#request.themeConfig['Logo']#" alt="#htmlEditFormat( request.themeConfig['Full Name'] )#" class="z-fluid" /></a>
			</div>
			<div class="z-fluid-at-767 jdt-header-right">
				<a href="tel:#reReplace( request.themeConfig['Phone Number'], '[^0-9]', '', 'ALL' )#" class="jdt-call-phone">
					<div class="jdt-call-phone-heading">#request.themeConfig['Header Call Now Text']#</div>
					<div class="jdt-call-phone-phone-number">#application.zcore.functions.zFormatPhoneNumber( request.themeConfig['Phone Number'] )#</div>
				</a>
			</div>
		</div>
		<cfif request.themeConfig['Main Menu']>
			<cfscript>
			menuStruct={menu_name:'Main Menu'};
			mainMenu = request.zos.functions.zMenuInclude( menuStruct );
			</cfscript>
			<cfif structKeyExists( mainMenu, 'output' ) AND NOT empty( mainMenu.output )>
				<div class="z-container">
					<div class="z-float jdt-main-menu">
						<a href="##" class="jdt-mobileMenuButton">&##9776; Menu</a>
						<div class="jdt-mobileMenuDiv">
							<cfscript>
								writeOutput( mainMenu.output );
							</cfscript>
						</div>
					</div>
				</div>
			</cfif>
		</cfif> 
	</div>
</cffunction>

<cffunction name="defaultHeader" localmode="modern" access="private">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfargument name="config" type="struct" required="yes">
	<cfscript>
	config=arguments.config;
	ts={
		topText:"",
		enableTopSection:true,
		enableLogoSection:true,
		enableMenuSection:true
	}
	structappend(config, ts, false);
	menuStruct={ menu_name: 'Main Menu' };
	mainMenu = request.zos.functions.zMenuInclude( menuStruct );
	ts=config.mobileHeader;
	for(link in mainMenu.arrLink){
		t2={
			label: link.text,
			link: link.url,
			arrLink:[],
			target: link.target
		};
		for(childLink in link.arrChildren){
			arrayAppend(t2.arrLink, {
				label: childLink.url,
				link: childLink.link,
				target: childLink.target
			});
		}
		arrayAppend(ts.arrLink, t2);
	}
	request.mobileHeaderCom.displayMobileMenu(ts); 
	socialIcons = application.zcore.siteOptionCom.optionGroupStruct( 'Social Icon', 0, request.zos.globals.id, request.themeConfig );
	</cfscript>
	<div class="jdt-default-header z-hide-at-992">
		<cfif config.enableTopSection>
			<div class="jdt-top-bar-container">
				<div class="z-container">
					<div class="jdt-top-bar">
						<!--- 
						<cfif request.themeConfig['Street Address'] NEQ ''>
							<div class="jdt-address">#request.themeConfig['Street Address']#</div>
							<div class="jdt-city-state">#request.themeConfig['City']#, #request.themeConfig['State']#</div>
						</cfif> --->

						<cfif arrayLen( socialIcons ) GT 0>
							<div class="jdt-social-icons">
								<cfloop from="1" to="#arrayLen( socialIcons )#" index="socialIconIndex">
									<cfscript>socialIcon = socialIcons[ socialIconIndex ];</cfscript>
									<a href="#socialIcon['URL']#" target="_blank"><img src="#socialIcon['Image']#" alt="#htmlEditFormat( socialIcon['Label'] )#" class="z-fluid" /></a>
								</cfloop>
							</div>
						</cfif>
						<cfif config.topText NEQ "">
							<div class="jdt-top-text">
								#config.topText#
							</div>
						</cfif>
					</div>
				</div>
			</div>
		</cfif>
		<cfif config.enableLogoSection>
			<div class="jdt-header-logo-container">
				<div class="z-container">
					<div class="jdt-header-left z-fluid-at-767 jdt-logo">
						<a href="/"><img src="#request.themeConfig['Logo']#" alt="#htmlEditFormat( request.themeConfig['Full Name'] )#" class="z-fluid" /></a>
					</div>
					<div class="z-fluid-at-767 jdt-header-right">
						<a href="tel:#reReplace( request.themeConfig['Phone Number'], '[^0-9]', '', 'ALL' )#" class="jdt-call-phone">
							<div class="jdt-call-phone-heading">#request.themeConfig['Header Call Now Text']#</div>
							<div class="jdt-call-phone-phone-number">#application.zcore.functions.zFormatPhoneNumber( request.themeConfig['Phone Number'] )#</div>
						</a>
					</div>
				</div>
			</div>
		</cfif>
		<cfif request.themeConfig['Main Menu']>
			<cfscript>
			menuStruct={menu_name:'Main Menu'};
			mainMenu = request.zos.functions.zMenuInclude( menuStruct );
			</cfscript>
			<cfif structKeyExists( mainMenu, 'output' ) AND NOT empty( mainMenu.output )>
				<div class="jdt-header-main-menu-container">
					<div class="z-container">
						<div class="z-float jdt-main-menu">
							<a href="##" class="jdt-mobileMenuButton">&##9776; Menu</a>
							<div class="jdt-mobileMenuDiv">
								<cfscript>
									writeOutput( mainMenu.output );
								</cfscript>
							</div>
						</div>
					</div>
				</div>
			</cfif>
		</cfif> 
	</div>

</cffunction>

<!--- 2 - Logo Vertically Centered on Main Navigation + Top Bar Address/Social --->
<cffunction name="logoVerticalCenterTopBarAddressSocialHeader" localmode="modern" access="private">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfargument name="config" type="struct" required="yes">
	<div class="jdt-header-v2">
		<div class="z-container jdt-top-bar-container">
			<div class="jdt-top-bar">
				<cfif request.themeConfig['Street Address'] NEQ ''>
					<div class="address">#request.themeConfig['Street Address']#</div>
					<div class="city-state">#request.themeConfig['City']#, #request.themeConfig['State']#</div>
				</cfif>

				<cfscript>
				socialIcons = application.zcore.siteOptionCom.optionGroupStruct( 'Social Icon', 0, request.zos.globals.id, request.themeConfig );
				</cfscript>
				<cfif arrayLen( socialIcons ) GT 0>
					<div class="jdt-social-icons">
						<cfloop from="1" to="#arrayLen( socialIcons )#" index="socialIconIndex">
							<cfscript>socialIcon = socialIcons[ socialIconIndex ];</cfscript>
							<a href="#socialIcon['URL']#" target="_blank"><img src="#socialIcon['Image']#" alt="#htmlEditFormat( socialIcon['Label'] )#" /></a>
						</cfloop>
					</div>
				</cfif>
			</div>
		</div>

		<!--- START MAIN MENU --->

		<cfif request.themeConfig['Main Menu']>
			<cfscript>
			menuStruct={menu_name:'Main Menu'};
			mainMenu = request.zos.functions.zMenuInclude( menuStruct );
			</cfscript>
			<cfif structKeyExists( mainMenu, 'output' ) AND NOT empty( mainMenu.output )>
				<div class="z-container jdt-main-menu-container">
					<div class="jdt-logo">
						<a href="/"><img src="#request.themeConfig['Logo']#" alt="#htmlEditFormat( request.themeConfig['Full Name'] )#" class="z-fluid" /></a>
					</div>
					<div class="z-float jdt-main-menu jdt-accent-bg">
						<a href="##" class="jdt-mobileMenuButton">&##9776; Menu</a>
						<div class="jdt-mobileMenuDiv">
							<cfscript>
							echo( mainMenu.output );
							</cfscript>
						</div>
					</div>
				</div>
			</cfif>
		</cfif>
	</div>
</cffunction>

<cffunction name="customHeader" localmode="modern" access="private">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfargument name="config" type="struct" required="yes">
	<div class="custom">
		<div class="z-container">
			<div class="z-1of2 z-p-0 z-fluid-at-767 jdt-logo">
				<a href="/"><img src="#request.themeConfig['Logo']#" alt="#htmlEditFormat( request.themeConfig['Full Name'] )#" class="z-fluid" /></a>
			</div>
			<div class="z-1of2 z-p-0 z-fluid-at-767 jdt-header-right">
				<a href="tel:#reReplace( request.themeConfig['Phone Number'], '[^0-9]', '', 'ALL' )#" class="jdt-call-phone z-ph-20 z-pv-10">
					<div class="jdt-call-phone-heading">#request.themeConfig['Header Call Now Text']#</div>
					<div class="jdt-call-phone-phone-number">#application.zcore.functions.zFormatPhoneNumber( request.themeConfig['Phone Number'] )#</div>
				</a>
			</div>
		</div>

		<cfif request.themeConfig['Main Menu']>
			<cfscript>
			menuStruct={menu_name:'Main Menu'}
			mainMenu = request.zos.functions.zMenuInclude( menuStruct );
			</cfscript>
			<cfif structKeyExists( mainMenu, 'output' ) AND NOT empty( mainMenu.output )>
				<div class="z-container">
					<div class="z-column z-p-0 z-fluid-at-992 jdt-main-menu jdt-accent-bg">
						<a href="##" class="jdt-mobileMenuButton">&##9776; Menu</a>
						<div class="jdt-mobileMenuDiv">
							<cfscript>
							writeOutput( mainMenu.output );
							</cfscript>
						</div>
					</div>
				</div>
			</cfif>
		</cfif>
	</div>
</cffunction>
</cfoutput>
</cfcomponent>
