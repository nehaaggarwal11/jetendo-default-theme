<cfcomponent extends="jetendo-themes.jetendo-default-theme.base.pages.index-theme">
<cfoutput>
<cffunction name="index" localmode="modern" access="remote">
	<cfargument name="query" type="query" required="yes">
	<cfscript>
	homePage = application.zcore.siteOptionCom.getOptionGroupSetById( [ 'Home Page' ], arguments.query.site_x_option_group_set_id );

	super.init(homePage); // required if you use index-theme functions

	// if splash page is enabled, it will display and 
	splashEnabled=displaySplashPage(homePage);
	if(splashEnabled){
		return;
	}
	seconds=4;
	</cfscript>
	#displaySlideshow(homePage, seconds)#

	#displayCallsToAction(homePage)#

	<cfif request.themeConfig['Home Layout'] EQ 'full'>
		#displayStartFullBodySection(homePage)#

			#displayMainContent(homePage)#

			#displayBlogSection(homePage)#

			#displaySidebarEstimateForm(homePage)#

			#displaySidebarCompanyInfo(homePage)#

			#displaySidebarMap(homePage)#

			#displaySidebarEvents(homePage)#
			
		#displayEndFullBodySection(homePage)#
	<cfelse>
		#displayStartLeftColumnBodySection(homePage)#

			#displayMainContent(homePage)#

			#displayBlogSection(homePage)#

		#displayStartRightColumnBodySection(homePage)#

			#displaySidebarEstimateForm(homePage)#

			#displaySidebarCompanyInfo(homePage)#

			#displaySidebarMap(homePage)#

			#displaySidebarEvents(homePage)#

		#displayEndRightColumnBodySection(homePage)#

	</cfif>
	<cfscript>
	// needed if estimate form is output, because it overrides the meta title
	application.zcore.template.setTag( 'title', arguments.query.site_x_option_group_set_metatitle );
	</cfscript>
</cffunction>

<!--- You can override some parts of the theme by overriding the functions like the example below --->
<!--- 
<cffunction name="displayCallsToAction" localmode="modern" access="public">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage;
	</cfscript>
</cffunction>

 --->
</cfoutput>
</cfcomponent>
