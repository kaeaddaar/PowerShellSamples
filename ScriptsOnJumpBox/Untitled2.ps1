include-Azurelogin

# Create a context for account and key
$FSContext = New-AzureStorageContext 

$storeAuto = Get-AzureRmStorageAccount -ResourceGroupName "SSBackups" -Name "sssqldbcustbackupsauto"

$SFContext = New-AzureStorageContext -StorageAccountName "sssqldbcustbackupsauto" -StorageAccountKey "z/hpT61XDLFEJ0DenyJfrIrAZsvcaBMRuz9sGYpo+yzGIEKa281cfUytEPoKjHjGkzSSZ9A0IdmyCaAX63fIHw=="

$FS = New-AzureStorageShare -Name "customerbackups" -Context $SFContext # Name must be all lower case
#Remove-AzureStorageShare -Name "sssqldbcustbackupsauto" -Context $SFContext

net use B: \\sssqldbcustbackupsauto.file.core.windows.net\customerbackups /u:AZURE\sssqldbcustbackupsauto z/hpT61XDLFEJ0DenyJfrIrAZsvcaBMRuz9sGYpo+yzGIEKa281cfUytEPoKjHjGkzSSZ9A0IdmyCaAX63fIHw==

$Computer
$i = 0
for ($i = 0; $i -lt $Computer.Count; $i++)
{
    Write-Output ("Net Use on " + $Computer[$i])
    Invoke-Command -ComputerName $Computer[$i].Name -ScriptBlock {net use}
}

$i = 0
for ($i = 0; $i -lt $Computer.Count; $i++)
{
    Invoke-Command -ComputerName $Computer[$i].Name -ScriptBlock {net use B: \\sssqldbcustbackupsauto.file.core.windows.net\customerbackups /u:AZURE\sssqldbcustbackupsauto z/hpT61XDLFEJ0DenyJfrIrAZsvcaBMRuz9sGYpo+yzGIEKa281cfUytEPoKjHjGkzSSZ9A0IdmyCaAX63fIHw==}
}

