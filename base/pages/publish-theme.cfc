<cfcomponent>
<cfoutput>
<cffunction name="index" localmode="modern" access="remote" roles="serveradministrator">
	<cfscript> 
	// TODO: consider using the spritemap compiler stuff, so that it rewrites relative paths automatically.
	arrCSS=request.themeHelperCom.getThemeAbsolutePathStylesheets();
	arrOut=[];
	for(css in arrCSS){
		if(not fileexists(css)){
			throw("Invalid path: #css#");
		}else{
			arrayAppend(arrOut, application.zcore.functions.zReadFile(css)&chr(10));
		}
	}
	arrayAppend(arrOut, request.themeHelperCom.getConfigCSS());
	application.zcore.functions.zWriteFile(request.zos.globals.privateHomeDir&"/zcache/theme-published.css", arrayToList(arrOut, chr(10)));
	echo('Theme Published.');
	abort;
	</cfscript>
</cffunction>
<cffunction name="debug" localmode="modern" access="remote">
	<cfscript>
	content type="text/css";
	echo(request.themeHelperCom.getConfigCSS());
	abort;
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>