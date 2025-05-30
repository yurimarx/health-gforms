Class User.GFormsInboundAdapter Extends Ens.InboundAdapter
{

Property FormId As %String(MAXLEN = 1000);

Property GFormsCredsFile As %String(MAXLEN = "");

Parameter SETTINGS = "GFormsCredsFile:GForms:fileSelector,FormId:GForms";

Method OnTask() As %Status
{
    Set formData = ##class(User.GFormMessage).%New()
    Set formData.Content = ##class(GFormsService).GetJSONResponsesFromFormId(..FormId, ..GFormsCredsFile)
    
    If ($IsObject(formData)) {
        Set tSC=..BusinessHost.ProcessInput(formData)
	    Set ..BusinessHost.%WaitForNextCallInterval=1 
    }
    Quit tSC
}

}
