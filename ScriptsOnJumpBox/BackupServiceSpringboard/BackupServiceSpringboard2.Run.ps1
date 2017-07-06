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

Invoke-Command -Session $s -ScriptBlock {
    # Functions for BackupServiceSpringboard
    function Test-ListContains([string[]]$List, [string]$Item) 
    { 
        if ($List.ToUpper() -eq $Item.ToUpper())
        {
                return $true
        }
        else
        {
            [int]$i = 0; 
            for ($i = 0; $i -lt $List.Count; $i++) 
            { 
                if ($List[$i].Name -eq $Item) 
                { 
                    return $true 
                }
            }
            return $false
        }
    }


    $Info = @{}
    $Info["CustomerUnique"] = 55029
    $DbName = "SSTrainingDB"

    $ComputerName = "SSAppCustVm1"

    Import-Module Sqlps
    set-location ("SQLSERVER:\SQL\" + $ComputerName + "\")

    $InstanceList = get-childitem

    $InstanceName = "SSAPP" + $Info["CustomerUnique"]

    [string[]]$List = Get-ChildItem -Path ("SQLSERVER:\SQL\localhost\" + $InstanceName + "\Databases\") | Select-Object -ExpandProperty "Name" 

    $DBExists = Test-ListContains -List $List -Item $DbName

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

    # Get the name of the backup, leave blank to overwrite the default.
    $BackupName = read-host "Enter name for backup, leave black for overwriting the default. (overwrites existing file of same name)"
    if ($BackupName.Length -le 0)
    { 
        [string]$ServerInstance = ("" + $ComputerName.ToUpper() + "\" + $InstanceName)
        $ServerInstance = "$ComputerName\$InstanceName"
        Backup-SqlDatabase -ServerInstance $ServerInstance -Database $DbName
        Set-Location ("SQLSERVER:\SQL\" + $Computername + "\" + $InstanceName)
        Backup-SqlDatabase -Database $DbName
    } 
    else
    { 
        if ($BackupName.EndsWith(".bak") -ne $true)
        {
            $BackupName = $BackupName + ".bak"
        }
        Set-Location ("SQLSERVER:\SQL\" + $Computername + "\" + $InstanceName)
        Backup-SqlDatabase -Database $DbName -BackupFile $BackupName
    }

}