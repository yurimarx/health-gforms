Class User.SaveFileBusinessOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method SaveForm(pRequest As User.GFormMessage, Output pResponse As Ens.Response) As %Status
{
  $$$TRACE("write to file ")
  Set tSC=..Adapter.PutString("test.txt", pRequest.Content)
  Quit tSC
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="User.GFormMessage">
    <Method>SaveForm</Method>
  </MapItem>
</MapItems>
}

}
