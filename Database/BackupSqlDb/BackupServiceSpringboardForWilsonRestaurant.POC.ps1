# Backup ETL Database for Wilson Restaurant Supply Inc.
if ($login -eq $null) { login-azurermAccount; $login = $true }

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

    # get the server instance
    $s = New-PSSession -ComputerName $ComputerName -Credential "WindwardAdmin"

    Invoke-Command -Session $s -ScriptBlock {Import-Module Sqlps}
    Invoke-Command -Session $s -ScriptBlock {Import-Module azurerm}
    Invoke-Command -Session $s -ScriptBlock {set-location ("SQLSERVER:\SQL\" + $Using:ComputerName + "\" )}
    #$InstanceList = Invoke-Command -Session $s -ScriptBlock  {get-childitem | Select-Object -ExpandProperty InstanceName}
    $InstanceList = Invoke-Command -Session $s -ScriptBlock  {get-childitem | Select-Object -ExpandProperty "Servers"}

if ($False)
{
    $InstanceList = Invoke-Command -ComputerName $ComputerName -ScriptBlock { (get-itemproperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances }
}

# build instance name string
$InstanceName = "SSAPP" + $Info["CustomerUnique"]
if ($InstanceList.Contains($InstanceName) -ne $true)
{ 
    Write-Host ("Instance `"" + $InstanceName + "`' does not exist, breaking.")
    $InstanceList
    break
}

# overwrite existing default backup
$BackupName = read-host "Enter name for backup, leave black for overwriting the default. (overwrites existing file of same name)"
if ($BackupName.Length -le 0)
{ 
    [string]$ServerInstance = ("" + $ComputerName.ToUpper() + "\" + $InstanceName)
    $ServerInstance = "SSAPPCUSTVM1\SSAPP55029"
    Invoke-Command -Session $s -ScriptBlock { Backup-SqlDatabase -ServerInstance "SSAPPCUSTVM1\SSAPP55029" -Database SSTrainingDB }
    if ($false)
    {
        # This one doesn't work, and has something to do with using a variable vs the literal string.
        Invoke-Command -Session $s -ScriptBlock { Backup-SqlDatabase -ServerInstance ($Using:ServerInstance) -Database SSTrainingDB } 
    }
    Invoke-Command -Session $s -ScriptBlock { Set-Location ("SQLSERVER:\SQL\" + $Using:Computername + "\" + $Using:InstanceName) } -ArgumentList 
    Invoke-Command -Session $s -ScriptBlock { Backup-SqlDatabase -Database SSTrainingDB } 
} 
else
{ 
    if ($false)
    {
        Invoke-Command -Session $s -ScriptBlock { Backup-SqlDatabase -ServerInstance ("SSAPPCUSTVM1\SSAPP55029") -Database SSTrainingDB -BackupFile "test3" } 
    }
    Invoke-Command -Session $s -ScriptBlock { Set-Location ("SQLSERVER:\SQL\" + $Using:Computername + "\" + $Using:InstanceName) }
    Invoke-Command -Session $s -ScriptBlock { Backup-SqlDatabase -Database SSTrainingDB } 
}

if ($false)
{
    # Check instanceNames on remote server
    Invoke-Command -Session $s -ScriptBlock {Get-ChildItem SQLSERVER: | Select-Object -Property "InstanceName"}
}
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
$DbList = Invoke-Command -session $s -scriptblock { Get-ChildItem -Path ("SQLSERVER:\SQL\localhost\" + $Using:InstanceName + "\Databases\") | Select-Object -Property "Name" }

Test-ListContains $DbList, "SSTrainingDB"


