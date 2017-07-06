# Purpose: POC to Backup ETL Database for Wilson Restaurant Supply Inc.

if ($login -eq $null) { login-azurermAccount; $login = $true }
Select-AzureRmSubscription -SubscriptionId "b6204063-8515-424a-915d-558f27eef1ed"

# produces list of Computers in $computer, and gets user selection to $SsVmChoice
# Functions for BackupServiceSpringboard
# ----- Pick your computer (start) -----
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
# ----- Pick your computer (end) -----
C:\Users\WindwardAdmin\Documents\WindowsPowerShell\Scripts\BackupServiceSpringboard\BackupServiceSpringboard.Functions.ps1

$Info = @{}
$Info["CustomerUnique"] = 55029
$DbName = "SSTrainingDB"

$ComputerName = $Computer[$SsVmChoice].Name
$ComputerName
Read-Host -Prompt "Review the computer name chosen above, and press enter to continue"

# Set up PowerShell Session for remoting. (use get-PSSession, and remove-PSSession if you need to perform other operations on sessions)
Read-Host -Prompt "We will now create a session to $ComputerName, please enter a valid user name and password to connect to the VM."
$s = New-PSSession -ComputerName $ComputerName -Credential "WindwardAdmin"

# ----- get the server instance (start) -----
# Might not need to do these imports
Write-Output "Import Modules Sqlps, and azurerm (may not need to perform, test removing them)"
Invoke-Command -Session $s -ScriptBlock {Import-Module Sqlps}
Invoke-Command -Session $s -ScriptBlock {Import-Module azurerm}
    
# Using: will allow the script to pull from the local machine instead of pulling from a variable with the same name on the server
# set-location allows us to browse to the SQLSERVER:\SQL\<ComputerName> directory which contains the instances
Write-Output "Getting list of instances on this PC"
Invoke-Command -Session $s -ScriptBlock {set-location ("SQLSERVER:\SQL\" + $Using:ComputerName + "\" )}
    
$InstanceList = Invoke-Command -Session $s -ScriptBlock  { get-childitem }

$InstanceName = "SSAPP" + $Info["CustomerUnique"]

Write-Output "----- Instance List -----"
$InstanceList
Read-Host "Review the instance list above, and press enter to continue. We will be loading the $InstanceName instance"

# Make sure instance name exists
if ($InstanceList.Contains($InstanceName) -ne $true)
{ 
    Write-Host ("Instance `"" + $InstanceName + "`' does not exist, breaking.")
    $InstanceList
    break
}

Read-Host -Prompt "Check to see if the database exists before trying to back it up"
#does the database exist
$DbList = Invoke-Command -session $s -scriptblock { Get-ChildItem -Path ("SQLSERVER:\SQL\localhost\" + $Using:InstanceName + "\Databases\") | Select-Object -Property "Name" }
$DBExists = Test-ListContains $DbList, $DbName
if ($DBExists)
{
    Read-Host -Prompt "$DbName exists, hit enter key to continue"
}
else
{
    $DbList
    Write-Host "$DbName doesn't exist in the list of databases above"
    break
}

Read-Host -Prompt "Starting the backup, hit enter key to continue"

# Get the name of the backup, leave blank to overwrite the default.
$BackupName = read-host "Enter name for backup, leave black for overwriting the default. (overwrites existing file of same name)"
if ($BackupName.Length -le 0)
{ 
    [string]$ServerInstance = ("" + $ComputerName.ToUpper() + "\" + $InstanceName)
    $ServerInstance = "$ComputerName\$InstanceName"
    Invoke-Command -Session $s -ScriptBlock { Backup-SqlDatabase -ServerInstance $Using:ServerInstance -Database $DbName }
    Invoke-Command -Session $s -ScriptBlock { Set-Location ("SQLSERVER:\SQL\" + $Using:Computername + "\" + $Using:InstanceName) } 
    Invoke-Command -Session $s -ScriptBlock { Backup-SqlDatabase -Database $DbName } 
} 
else
{ 
    Invoke-Command -Session $s -ScriptBlock { Set-Location ("SQLSERVER:\SQL\" + $Using:Computername + "\" + $Using:InstanceName) }
    Invoke-Command -Session $s -ScriptBlock { Backup-SqlDatabase -Database $DbName } 
}

