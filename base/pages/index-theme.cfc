<cfcomponent>
<cfoutput>
<cffunction name="init" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	request.customPage=true;
	application.zcore.skin.includeJS( '/z/javascript/jquery/jquery-content-slider/jquery.content-slider.js' );
	application.zcore.skin.includeCSS( '/z/javascript/jquery/jquery-content-slider/jquery.content-slider.css' );
	application.zcore.skin.includeCSS( '/zthemes/jetendo-default-theme/base/stylesheets/home-theme.css' );
	</cfscript> 
</cffunction>

<cffunction name="index" localmode="modern" access="public">
	<cfargument name="query" type="query" required="yes">
	<cfscript>
	throw("You must implement an index() function in index.cfc.");
	</cfscript>
</cffunction>

<cffunction name="displaySplashPage" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage;  
	splashPage = application.zcore.siteOptionCom.optionGroupStruct( 'Splash Page', 0, request.zos.globals.id, homePage );
	</cfscript>
	<cfif arrayLen( splashPage ) GT 0>
		<cfscript>splashPage = splashPage[ 1 ];</cfscript>
		<cfif splashPage['Enabled'] EQ 'Yes'>
			<cfscript>
			application.zcore.template.setTemplate( 'root.templates.empty', true, true );

			if(request.themeConfig["Home Slideshow Wide"] EQ "Wide"){
				currentImage=splashPage["Wide Image"];
			}else{
				currentImage=splashPage["Image"];
			}
			</cfscript>
			<style type="text/css">
				html, body { margin: 0; padding: 0; }
				img { vertical-align: bottom; }
			</style>
			<cfif splashPage['Background Color'] NEQ ''>
				<style type="text/css">
					html, body {
						background-color: ###splashPage['Background Color']#;
					}
				</style>
			</cfif>

			<cfif splashPage['Mobile Image'] NEQ ''>
				<!--- Desktop: 1920x1080 --->
				<div class="z-float z-text-center z-hide-at-992">
					<cfif splashPage['URL'] NEQ ''>
						<a href="#splashPage['URL']#"><img src="#currentImage#" class="z-fluid"></a>
					<cfelse>
						<img src="#currentImage#" class="z-fluid">
					</cfif>
				</div>
				<!--- Mobile: 992x1080 --->
				<div class="z-float z-text-center z-show-at-992">
					<cfif splashPage['URL'] NEQ ''>
						<a href="#splashPage['URL']#"><img src="#splashPage['Mobile Image']#" class="z-fluid"></a>
					<cfelse>
						<img src="#splashPage['Mobile Image']#" class="z-fluid">
					</cfif>
				</div>
			<cfelse>
				<!--- Desktop: 1920x1080 --->
				<cfif splashPage['URL'] NEQ ''>
					<a href="#splashPage['URL']#"><img src="#currentImage#" class="z-fluid"></a>
				<cfelse>
					<img src="#currentImage#" class="z-fluid">
				</cfif>
			</cfif>
			<cfreturn true>
		</cfif>
	</cfif>
	<cfscript>
	return false;
	</cfscript>
</cffunction>


<cffunction name="displaySlideshowSlide" localmode="modern" access="private">
	<cfargument name="homeSlide" type="struct" required="yes">
	<cfargument name="index" type="numeric" required="yes">
	<cfscript>
	homeSlide=arguments.homeSlide; 
	i1=arguments.index;
	echo('<div id="jdt-homeSlide#i1#" data-slideid="#i1#" style="width:100% !important; float:left; ">');
		if(structKeyExists( homeSlide, 'Mobile Image' ) AND homeSlide['Mobile Image'] NEQ ''){
			if(structKeyExists( homeSlide, 'URL' ) AND homeSlide['URL'] NEQ ''){
				echo('<div class="z-hide-at-992">
					<a href="#homeSlide['URL']#"><img src="#homeSlide['Image']#"  style="width:100%;max-width:100%; float:left;"></a>
				</div>
				<div class="z-show-at-992">
					<a href="#homeSlide['URL']#"><img src="#homeSlide['Mobile Image']#"  style="width:100%;max-width:100%; float:left;"></a>
				</div>');
			}else{
				echo('<div class="z-hide-at-992">
					<img src="#homeSlide['Image']#"  style="width:100%;max-width:100%; float:left;">
				</div>
				<div class="z-show-at-992">
					<img src="#homeSlide['Mobile Image']#"  style="width:100%;max-width:100%; float:left;">
				</div>');
			}
		}else{
			if(structKeyExists( homeSlide, 'URL' ) AND homeSlide['URL'] NEQ ''){
				echo('<a href="#homeSlide['URL']#"><img src="#homeSlide["Image"]#"  style="width:100%;max-width:100%; float:left;"></a>');
			}else{
				echo('<img src="#homeSlide['Image']#"  style="width:100%;max-width:100%; float:left;">');
			}
		}
	echo('</div>');
	</cfscript>
</cffunction>

<cffunction name="displaySlideshow" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfargument name="seconds" type="numeric" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	if(request.themeConfig['Home Slideshow']){
		homeSlides = application.zcore.siteOptionCom.optionGroupStruct( 'Slide', 0, request.zos.globals.id, homePage );
		if(arrayLen( homeSlides ) GT 0){
			echo('
			<div class="jdt-homepage-slideshow jdt-pager-left-inset">
				');
			if ( request.themeConfig['Home Slideshow Wide'] EQ "No" ) {
				echo('<div class="z-container">');
			}
			echo('<div class="z-float z-mb-20 jdt-homepage-slideshow-container">
				<div class="jdt-homepage-slider-container">
					<div class="jdt-homepage-slider" id="jdt-slideshowHomeDiv1" data-cycle-progressive="##homePhotoSlides1" style="width:100% !important; float:left;" data-cycle-swipe="true" data-cycle-swipe-fx="scrollHorz" data-cycle-log="false" data-cycle-slides=">div"> ');
			arr1=application.zcore.siteOptionCom.optionGroupStruct("Slide");
			for(i1=1;i1<=min(1, arrayLen(homeSlides));i1++){
				homeSlide=homeSlides[i1];
				displaySlideshowSlide(homeSlide, i1);
			}
			echo('			</div>
						</div>
					</div>');
			if ( request.themeConfig['Home Slideshow Wide'] EQ "No" ) {
				echo('<div class="z-container">');
			}
			echo('</div>');
		}
		savecontent variable="out"{
			echo('<script id="jdt-homePhotoSlides1" type="text/cycle" data-cycle-split="-~-">');
			for(i1=2;i1<=arrayLen(homeSlides);i1++){
				homeSlide=homeSlides[i1];
				if(i1 NEQ 2){
					echo('-~-');
				}
				displaySlideshowSlide(homeSlide, i1);
			}
			echo('</script>
			<script type="text/javascript">
			// put this at bottom of default.cfc
			zArrDeferredFunctions.push(function(){
			   $("##jdt-slideshowHomeDiv1").cycle({timeout:#arguments.seconds*1000#});
			});
			</script>');
		}
		application.zcore.skin.includeJS("/z/javascript/jquery/jquery.cycle2.js");
		application.zcore.skin.includeJS("/z/javascript/jquery/jquery.cycle2.swipe.min.js", '', 2);
		application.zcore.template.appendTag("scripts", out);
	}
	</cfscript>  
</cffunction>

<cffunction name="displayCallsToAction" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>
	<cfif request.themeConfig['Home Call To Actions']>
		<cfscript>
			callToActions = application.zcore.siteOptionCom.optionGroupStruct( 'Call to Action', 0, request.zos.globals.id, homePage );
		</cfscript>
		<cfif arrayLen( callToActions ) GT 0>
			<section class="jdt-homepage-cta-container">
				<div class="z-container">
					<div class="z-float jdt-homepage-cta-content ">

						<cfloop from="1" to="#arrayLen( callToActions )#" index="callToActionIndex">
							<cfscript>callToAction = callToActions[ callToActionIndex ];</cfscript>
							<div class="z-text-center jdt-homepage-cta">
								<a href="#callToAction['URL']#"><img src="#callToAction['Image']#" alt="" style="width:100% !important; float:left;"></a>
							</div>
						</cfloop>

					</div>
				</div>
			</section>
		</cfif>
	</cfif>
</cffunction>


<cffunction name="displayStartFullBodySection" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>
	<section class="jdt-homepage-main-container jdt-full">
		<div class="z-container">
			<div class="jdt-homepage-main jdt-full">
				<div class="z-column z-fluid-at-992 jdt-homepage-content jdt-full">
</cffunction>


<cffunction name="displayMainSection" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>
	
	<cfif homepage['Heading Small'] NEQ ''>
		<h1 class="jdt-heading jdt-accent">#homepage['Heading Small']#</h1>
	</cfif>
	<cfif homepage['Heading Large'] NEQ ''>
		<h1 class="jdt-heading">#homepage["Heading Large"]#</h1>
	</cfif>

	<div class="z-float">#homepage["Body Text"]#</div>

 
</cffunction>

<cffunction name="displayEndFullBodySection" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>
				</div>
			</div>
		</div>
	</section>
</cffunction>

<cffunction name="displayStartLeftColumnBodySection" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>
	<section class="jdt-homepage-main-container">
		<div class="z-container">
			<div class="jdt-homepage-main">
				<div class="z-fluid-at-992 jdt-homepage-content">
</cffunction>

<cffunction name="displayStartRightColumnBodySection" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>
				</div> 
				<div class="z-fluid-at-992 jdt-homepage-sidebar">
</cffunction>
<cffunction name="displayEndRightColumnBodySection" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>
				</div>
			</div>
		</div>
	</section>
</cffunction>

<cffunction name="displayMainContent" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>
	<div class="z-float z-mb-10">
		<cfif homepage['Heading Small'] NEQ ''>
			<h1 class="jdt-heading jdt-accent" style="padding-bottom:0px;">#homepage['Heading Small']#</h1>
		</cfif>
		<cfif homepage['Heading Large'] NEQ ''>
			<h1 class="jdt-heading jdt-heading-large" style="padding-bottom:0px;">#homepage["Heading Large"]#</h1>
		</cfif>
	</div>

	<div class="z-float">#homepage["Body Text"]#</div>
</cffunction>

<cffunction name="displayBlogSection" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript> 
	<!--- BEGIN HOMEPAGE BLOG --->

	<cfif request.themeConfig['Home Blog']>
		<cfif application.zcore.app.siteHasApp( 'blog' )>
			<cfscript>
			blogArticles={
				imageSize:'362x276',
				crop:1
			};
			request.zos.tempObj.blogInstance.configCom.articleIncludeTemplate( blogArticles, 3 );
			</cfscript>
			<cfif structKeyExists( blogArticles, 'arrBlog' ) AND arrayLen( blogArticles.arrBlog ) GT 0>
				<div class="z-float jdt-homepage-blog">
					<h2 class="jdt-heading jdt-homepage-blog-heading">What's New at #request.themeConfig['Full Name']#</h2>

					<cfloop from="1" to="#arrayLen( blogArticles.arrBlog )#" index="blogArticleIndex">
						<cfscript>blogArticle = blogArticles.arrBlog[ blogArticleIndex ];</cfscript>
						<div class="z-float jdt-blog-thumbnail-container">
							<cfif blogArticle.image NEQ ''>
								<div class="jdt-blog-thumbnail-image">
									<a href="#blogArticle.link#"><img src="#blogArticle.image#" alt="#htmlEditFormat( blogArticle.title )#" class="z-fluid" /></a>
								</div>
							<cfelse>
								<div class="jdt-blog-thumbnail-image"></div>
							</cfif>
							<div class="jdt-blog-thumbnail-text">
								<h3 class="jdt-heading jdt-blog-heading"><a href="#blogArticle.link#">#blogArticle.title#</a></h3>
								<div class="jdt-blog-summary">#blogArticle.summary# <a href="#blogArticle.link#" class="jdt-blog-read-more">Read More</a></div>
							</div>
						</div>
					</cfloop>

					<div>
						<a href="/Blog-3-3.html" class="z-button jdt-blog-more-news">More News</a>
					</div>
				</div>
			</cfif>
		</cfif>
	</cfif>
</cffunction>


<cffunction name="displaySidebarEstimateForm" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>
	<cfif request.themeConfig['Home Lead Form']>
		<div class="jdt-homepage-sidebar-box jdt-lead-form jdt-accent-bg">
			<h2 class="z-text-center jdt-heading">Free Estimate</h2>
			<cfscript>
			form.site_option_group_id = application.zcore.functions.zGetSiteOptionGroupIDWithNameArray( [ 'Lead Form' ] );
			displayGroupCom = createobject( 'component', 'zcorerootmapping.mvc.z.misc.controller.display-site-option-group' );
			displayGroupCom.add();
			</cfscript>
			<script type="text/javascript">
			zArrDeferredFunctions.push( function() {
				$( '.jdt-lead-form button[type=submit]' ).html( 'Submit' );
			} );
			</script>
		</div>
	</cfif>
</cffunction>


<cffunction name="displaySidebarCompanyInfo" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>
	<cfif request.themeConfig['Home Company Info']>
		<div class="jdt-homepage-sidebar-box jdt-company-info">
			<h3 class="jdt-heading">#request.themeConfig['Full Name']#</h3>
			<div class="jdt-company-info-address z-float">
				<i class="fa fa-map-marker jdt-accent"></i>
				<div>#request.themeConfig['Street Address']#<br />
				#request.themeConfig['City']#, #request.themeConfig['State']# #request.themeConfig['Zip Code']#</div>
			</div>
			<div class="jdt-company-info-phone z-float">
				<i class="fa fa-phone jdt-accent"></i>
				<div>#request.themeConfig['Phone Number']#</div>
			</div>
		</div>
	</cfif>
</cffunction>


<cffunction name="displaySidebarMap" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>

	<cfif request.themeConfig['Home Google Map']>

		<div class="jdt-homepage-sidebar-map" style="height: 480px; background-color: ##E6E3DF;">
			<cfscript>
			mapLocation = {
				'Street Address': request.themeConfig['Street Address'],
				'City': request.themeConfig['City'],
				'State': request.themeConfig['State'],
				'Zip Code': request.themeConfig['Zip Code'],
				'Map Location': request.themeConfig['Map Location']
			};

			map = request.themeHelperCom.mapLocation( mapLocation, '480px' );
			</cfscript>

			#map.scriptOutput#
			#map.mapHTML#
		</div>

	</cfif>
</cffunction>


<cffunction name="displaySidebarEvents" localmode="modern" access="private">
	<cfargument name="homePage" type="struct" required="yes">
	<cfscript>
	homePage=arguments.homePage; 
	</cfscript>

	<cfif request.themeConfig['Home Events']>
		<cfif application.zcore.app.siteHasApp( 'event' )>
			<div class="jdt-homepage-sidebar-box jdt-events">
				<h3 class="jdt-heading">Upcoming Events</h3>
				<cfscript>
					eventsStruct = {
						searchStruct: {
							calendarids: '1',
							offset: 0,
							perpage: 3
						},
						renderCFC: this,
						renderMethod: 'renderEvent'
					};

					application.zcore.app.getAppCFC( 'event' ).displayUpcomingEvents( eventsStruct );
				</cfscript>

				<div>
					<a href="/events/index" class="z-button jdt-more-events">More Events</a>
				</div>
			</div>
		</cfif>
	</cfif> 
</cffunction>

<cffunction name="renderEvent" localmode="modern" access="private">
	<cfargument name="event" type="struct" required="yes">
	<cfscript>
		event = arguments.event;
		eventCom = application.zcore.app.getAppCFC( 'event' );

		eventStartDate = event.event_start_datetime;

		eventDayOfWeek = dateFormat( eventStartDate, 'dddd' );
		eventMonth     = dateFormat( eventStartDate, 'mmmm' );
		eventDay       = dateFormat( eventStartDate, 'd' );
		eventYear      = dateFormat( eventStartDate, 'yyyy' );
		eventStartTime = timeFormat( eventStartDate, 'short' );
	</cfscript>
	<div class="z-float z-mb-20 jdt-event">
		<div class="z-float z-bold jdt-event-link"><a href="#event.__url#">#event.event_name#</a></div>
		<div class="z-float jdt-event-date">#eventDayOfWeek#, #eventMonth# #eventDay#, #eventYear# - #eventStartTime#</div>
	</div>
</cffunction>
</cfoutput>
</cfcomponent>