<cfcomponent>
<cfoutput>
<cffunction name="index" access="remote" localmode="modern">
    <cfscript>
	var ts=structnew();
	ts.content_unique_name="/";
	application.zcore.app.getAppCFC("content").includePageContentByName(ts);
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>