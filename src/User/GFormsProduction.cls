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
    <Setting Target="Host" Name="Target">SaveFile</Setting>
  </Item>
  <Item Name="SaveFile" Category="" ClassName="User.SaveFileBusinessOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/tmp/</Setting>
  </Item>
</Production>
}

}
