Class User.SaveFHIRBusinessOperation Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Method SaveResponsesOnFHIR(pRequest As User.GFormMessage, Output pResponse As Ens.StringResponse) As %Status
{
   
  
   
   try {
      
      Set tSC=..Adapter.Post(.tHttpResponse,,pRequest.Content)
      
      If $$$ISERR(tSC)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size {
         Set tSC=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
      }
      
      Quit:$$$ISERR(tSC)
      
      If $IsObject(tHttpResponse) {
         // Instantiate the response object
         set pResponse = ##class(Ens.Response).%New()
         set pResponse.StringValue = tHttpResponse.Data
       }
   }catch{
       Set tSC=$$$SystemError
   }
   Quit tSC
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="User.GFormMessage">
    <Method>SaveResponsesOnFHIR</Method>
  </MapItem>
</MapItems>
}

}
