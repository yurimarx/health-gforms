Class User.GFormMessage Extends (%Persistent, Ens.Util.RequestBodyMethods)
{

Property Content As %String(MAXLEN = "");

Storage Default
{
<Data name="GFormMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Content</Value>
</Value>
</Data>
<DataLocation>^User.GFormMessageD</DataLocation>
<DefaultData>GFormMessageDefaultData</DefaultData>
<IdLocation>^User.GFormMessageD</IdLocation>
<IndexLocation>^User.GFormMessageI</IndexLocation>
<StreamLocation>^User.GFormMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
