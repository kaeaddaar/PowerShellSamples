# Backup ETL Database for Wilson Restaurant Supply Inc.

Select-AzureRmSubscription -SubscriptionId "b6204063-8515-424a-915d-558f27eef1ed"

$Computer = get-azurermvm -ResourceGroupName ServiceSpringboard -Status | Select-Object -Property "Name","PowerState"

# add a 0 based ObjId to each object in an array
function Add-ObjID($obj) { $i = 0; for ($i = 0 ; $i -lt $obj.Count; $i++) { Add-Member -InputObject $obj[$i] -MemberType NoteProperty -Name ObjId -Value $i } }

# display the list of computers
Add-ObjID $Computer
$Computer | Format-Table -AutoSize -Property "ObjId", "Name", "PowerState"

# select a computer
$SsVmChoice = Read-Host -Prompt "Enter ObjId of computer"
# if not in range, break
if (($SsVmChoice -lt 0) -or ($SsVmChoice -ge $Computer.Length) ) { Write-Output ("`"" + $SsVmChoice + "`" is invalid, breaking"); break }

# Need from Windward Software live System Five the customer unique ID: 55029
$Info = @{}
$Info["CustomerUnique"] = 55029

if ($false)
{ 
    Enter-PSSession -ComputerName $Computer[$SsVmChoice].Name 
}
$ComputerName = $Computer[$SsVmChoice].Name

if ($false) # worked previously, but not sure why not now?
{
    # get the server instance
    Invoke-Command -ComputerName $ComputerName -ScriptBlock {set-location "SQLSERVER:\SQL\localhost"}
    $InstanceList = Invoke-Command -ComputerName $ComputerName -ScriptBlock  {get-childitem | Select-Object -ExpandProperty InstanceName}
}

if ($True)
{
    $InstanceList = Invoke-Command -ComputerName $ComputerName -ScriptBlock { (get-itemproperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances }
}

# build instance name string
$InstanceName = "SSAPP" + $Info["CustomerUnique"]
if (($InstanceList.Contains($InstanceName) -ne $true)) { Write-Host ("Instance `"" + $InstanceName + "`' does not exist, breaking."); $InstanceList; break }

# overwrite existing default backup
$BackupName = read-host "Enter name for backup, leave black for overwriting the default. (overwrites existing file of same name)"
if ($BackupName.Length -le 0)
{ Backup-SqlDatabase -ServerInstance ("localhost\" + $InstanceName) -Database SSTrainingDB }
else
{ Backup-SqlDatabase -ServerInstance ("localhost\" + $InstanceName) -Database SSTrainingDB -BackupFile $BackupName }

function Test-ListContains($List, $Item) 
{ 
    [int]$i = 0; 
    for ($i = 0; $i -lt $List.Length; $i++) 
    { 
        if ($List[$i] -eq $Item) 
        { 
            return $true 
        }
    }
    return $false
}

#does the database exist
$DbList = Get-ChildItem -Path ("SQLSERVER:\SQL\localhost\" + $InstanceName + "\Databases\") | Select-Object -Property "Name"

Test-ListContains $DbList, "SSTrainingDB"



Exit-PSSession
