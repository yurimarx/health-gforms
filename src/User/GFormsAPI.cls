Class User.GFormsAPI Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter HandleCorsRequest = 1;

Parameter Version = "1.0.0";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>

<!-- Get form definition content from id -->
<Route Url="/form/create" Method="POST" Call="CreateFormFromFile" Cors="true"/>

<!-- Get form definition content from id -->
<Route Url="/form/id" Method="GET" Call="GetFormFromId" Cors="true"/>

<!-- Get form definition content from id -->
<Route Url="/form/template/content" Method="GET" Call="GetContentFromTemplateAndResponses" Cors="true"/>

<!-- Post Google forms credentials for Google Cloud service account -->
<Route Url="/credentials" Method="POST" Call="UploadCredentials"/>

<!-- Upload Google forms definition file -->
<Route Url="/form/definition" Method="POST" Call="UploadFormDefinition"/>


<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />


</Routes>
}

ClassMethod CreateFormFromFile() As %Status
{
  set formTitle = %request.Get("formTitle")
  set file = %request.Get("name")_".json"
  set response = {}
  set response.formId = ##class(GFormsService).CreateFormFromFile(formTitle, "/opt/irisapp/"_file)
  write response
  Return $$$OK
}

ClassMethod GetFormFromId() As %Status
{
  set formId = %request.Get("formId")
  set response = ##class(GFormsService).GetFormFromId(formId)
  write response
  return $$$OK
}

ClassMethod GetContentFromTemplateAndResponses() As %Status
{
  set formId = %request.Get("formId")
  set templatePath = %request.Get("templatePath")_".mako"
  set response = ##class(GFormsService).GetContentFromTemplateAndResponses(formId, "/opt/irisapp/"_templatePath)
  write response
  return $$$OK
}

ClassMethod UploadCredentials() As %Status
{
   
    try {
        Set info = {}
        Set source = %request.GetMimeData("file")
        Set destination=##class(%Stream.FileBinary).%New()
        Set destination.Filename="/tmp/credentials.json"
        //Set destination.Filename="/opt/irisapp/credentials.json"
        set tSC=destination.CopyFrom(source) //reader open the file
        set result=destination.%Save()
        set tSC = ##class(%File).CopyFile("/tmp/credentials.json", "/opt/irisapp/credentials.json", 1, .result)
        set info.return = result
        set info.message = "Credentials saved"
       
        Set %response.ContentType = ..#CONTENTTYPEJSON
        Set %response.Headers("Access-Control-Allow-Origin")="*"
 
        Write info.%ToJSON()
 
        Set tSC=$$$OK
   
    //returns error message to the user
    } catch e {
        Set tSC=e.AsStatus()
        Set pOutput = tSC
    }
 
    Quit tSC
}

ClassMethod UploadFormDefinition() As %Status
{
   
    try {
        Set info = {}
        Set source = %request.GetMimeData("file")
        Set filename = %request.Get("name")
        Set destination=##class(%Stream.FileBinary).%New()
        Set destination.Filename="/tmp/"_filename_".json"
        set tSC=destination.CopyFrom(source) //reader open the file
        set result=destination.%Save()
        set tSC = ##class(%File).CopyFile("/tmp/"_filename_".json", "/opt/irisapp/"_filename_".json", 1, .result)
        set info.return = result
        set info.message = "Form definition saved"
       
        Set %response.ContentType = ..#CONTENTTYPEJSON
        Set %response.Headers("Access-Control-Allow-Origin")="*"
 
        Write info.%ToJSON()
 
        Set tSC=$$$OK
   
    //returns error message to the user
    } catch e {
        Set tSC=e.AsStatus()
        Set pOutput = tSC
    }
 
    Quit tSC
}

ClassMethod GetInfo() As %Status
{
  Set version = ..#Version
  Set info = {
    "version": (version)
  }
  Return ..%ProcessResult($$$OK, info)
}

ClassMethod %ProcessResult(pStatus As %Status = {$$$OK}, pResult As %DynamicObject = "") As %Status [ Internal ]
{
  #dim %response As %CSP.Response
  Set tSC = $$$OK
  If $$$ISERR(pStatus) {
    Set %response.Status = 500
    Set tSC = ..StatusToJSON(pStatus, .tJSON)
    If $ISOBJECT(tJSON) {
      Set pResult = tJSON
    } Else {
      Set pResult = { "errors": [ { "error": "Unknown error parsing status code" } ] }
    }
  } 
  ElseIf pStatus=1 {
    If '$ISOBJECT(pResult){
      Set pResult = {
      }
    }
  }
  Else {
    Set %response.Status = pStatus
    Set error = $PIECE(pStatus, " ", 2, *)
    Set pResult = {
      "error": (error)
    }
  }
  
  If pResult.%Extends("%Library.DynamicAbstractObject") {
    Write pResult.%ToJSON()
  }
  ElseIf pResult.%Extends("%JSON.Adaptor") {
    Do pResult.%JSONExport()
  }
  ElseIf pResult.%Extends("%Stream.Object") {
    Do pResult.OutputToDevice()
  }
  
  Quit tSC
}

ClassMethod ReportHttpStatusCode(pHttpStatus, pSC As %Status = {$$$OK}) As %Status
{
  Set %response.Status=pHttpStatus
  
  If $$$ISERR(pSC) Do ..outputStatus(pSC)
      
  Return $$$OK
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/health-gforms"
  Set swagger.info.title = "API for health-gforms"
  Set swagger.info.version = "1.0.0"
  Set swagger.host = "localhost:32783"
  Return ..%ProcessResult($$$OK, swagger)
}

}
