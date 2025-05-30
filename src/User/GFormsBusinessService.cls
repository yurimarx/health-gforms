Class User.GFormsBusinessService Extends Ens.BusinessService
{

Parameter ADAPTER = "User.GFormsInboundAdapter";

Property Target As %String(MAXLEN = "");

Parameter SETTINGS = "Target:GForms:selector?context={Ens.ContextSearch/ProductionItems}";

Method OnProcessInput(pInput As User.GFormMessage, Output pOutput As %RegisteredObject) As %Status
{
  Set tSC = ..SendRequestSync(..Target, pInput, .pResponse)
  Set pOutput = pResponse
}

}
