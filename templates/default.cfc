<cfcomponent implements="zcorerootmapping.interface.view">
<cfoutput>
<cffunction name="init" access="public" returntype="string" localmode="modern">
	<cfscript>
	application.zcore.functions.zIncludeZOSFORMS();
	application.zcore.skin.includeCSS("/zthemes/jetendo-default-theme/stylesheets/style.css");
	request.disablesharethis=true; 
	</cfscript>
</cffunction>

<cffunction name="render" access="public" returntype="string" localmode="modern">
	<cfargument name="tagStruct" type="struct" required="yes">
	<cfscript>
	var tagStruct=arguments.tagStruct;
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
	<!--[if lt IE 7]>	  <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
	<!--[if IE 7]>		 <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
	<!--[if IE 8]>		 <html class="no-js lt-ie9"> <![endif]-->
	<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
	<head>
		<meta charset="utf-8" />
	<title>#tagStruct.title ?: ""#</title>
	#tagStruct.stylesheets ?: ""#
	#tagStruct.meta ?: ""#
</head>

<body>
<div class="wrapper">
	<div class="cont_area">
	<div class="titlediv">#request.zos.globals.sitename#
		<div class="searchdiv">

			<input type="text" name="searchtext" value="Type Keyword Here" onclick="if(this.value == 'Type Keyword Here'){this.value='';}" onblur="if(this.value==''){this.value='Type Keyword Here';}" size="15" />
			<input type="submit" name="searchsubmit" value="Search" />
		</div>
	</div>
	<div class="menudiv">
		<a href="##" class="mobileMenuButton">Menu</a>
		<div class="mobileMenuDiv">
			<cfscript>
			ts=structnew();
			ts.menu_name="Main Menu";
			rs=request.zos.functions.zMenuInclude(ts);
			writeoutput(rs.output);
			</cfscript>
		</div>
	</div>
	<div class="center_block">
		<div class="cont_block"> 
			<a id="contenttop"></a>
			#tagStruct.topcontent ?: ""#
			<cfif request.zos.template.getTagContent('pagenav') NEQ ''>
				<p>#tagStruct.pagenav ?: ""#</p>
			</cfif>
			<cfif request.zos.template.getTagContent('pagetitle') NEQ ''>
				<h1>#tagStruct.pagetitle ?: ""#</h1>
			</cfif>
			#tagStruct.content ?: ""#
			<cfif structkeyexists(request.zos, 'listingCom')>
				<hr />
				#request.zos.listingCom.getDisclaimerText()#
			</cfif>
		</div>
		<div class="left_block">
			<cfif isdefined('request.zos.tempObj.rentalInstance') EQ false or request.zos.tempObj.rentalInstance.configCom.isRentalPage() EQ false>
				<div class="sidebartext">
					<cfif structkeyexists(request.zos,'listingCom')>
						<h2>LISTING SEARCH</h2>
						<cfscript>
						ts=structnew();
						ts.output=true;
						ts.searchFormLabelOnInput=true;
						ts.searchFormEnabledDropDownMenus=true;
						ts.searchFormHideCriteria=structnew();
						ts.searchFormHideCriteria["more_options"]=true;
						request.zos.listingCom.includeSearchForm(ts);
						</cfscript>
					</cfif>
				</div>
			</cfif>
			<div class="sidebartext"> 
				Sidebar
			</div> 
		</div>
	</div>
	<div class="crights">
		&copy;#year(now())#
		<cfif form[request.zos.urlRoutingParameter] NEQ "/">
		<a href="/">
		</cfif>
#request.zos.globals.shortdomain#
		<cfif form[request.zos.urlRoutingParameter] NEQ "/">
		</a>
		</cfif>
		- all rights reserved.
		| <a href="/z/misc/site-map/index">Site Map</a> | 
		<a href="/z/user/terms-of-use/index">Terms Of Use</a> | 
		<a href="/z/user/privacy/index">Privacy Policy</a></div>
	</div>
</div>
<script type="text/javascript">
zArrDeferredFunctions.push(function() { 
	$(".mobileMenuButton").bind("click", function(){
		$(".mobileMenuDiv").slideToggle("fast");
		return false;
	});
	 
});
</script>
#tagStruct.scripts ?: ""#
#request.zos.functions.zvarso('Visitor Tracking Code')#
</body>
</html>
	</cfsavecontent>
	<cfreturn output>
</cffunction>
</cfoutput>
</cfcomponent>