Class User.GFormsInboundAdapter Extends Ens.InboundAdapter
{

Property FormId As %String(MAXLEN = 1000);

Property TemplatePath As %String(MAXLEN = "");

Parameter SETTINGS = "FormId:GForms,TemplatePath:GForms:fileSelector";

Method OnTask() As %Status
{
    Set formData = ##class(User.GFormMessage).%New()
    Set formData.Content = ##class(GFormsService).GetContentFromTemplateAndResponses(..FormId, ..TemplatePath)
    
    If ($IsObject(formData)) {
        Set tSC=..BusinessHost.ProcessInput(formData)
	    Set ..BusinessHost.%WaitForNextCallInterval=1 
    }
    Quit tSC
}

}
