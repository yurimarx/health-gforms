Class User.GFormsProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="User.GFormsProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="GFormsBS" Category="" ClassName="User.GFormsBusinessService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FormId">1AJ5h2NnrWWYjXKF0-0iIy2Pb7sTKNmb11euzpy6WGL0</Setting>
    <Setting Target="Adapter" Name="GFormsCredsFile">/opt/irisapp/credentials.json</Setting>
    <Setting Target="Host" Name="Target">SaveFHIRBusinessOperation</Setting>
    <Setting Target="Adapter" Name="TemplatePath">/opt/irisapp/createpatient.mako</Setting>
  </Item>
  <Item Name="SaveFHIRBusinessOperation" Category="" ClassName="User.SaveFHIRBusinessOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">52773</Setting>
    <Setting Target="Adapter" Name="HTTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="URL">/fhir/r4/Patient</Setting>
    <Setting Target="Adapter" Name="Credentials">credfhir</Setting>
  </Item>
</Production>
}

}
