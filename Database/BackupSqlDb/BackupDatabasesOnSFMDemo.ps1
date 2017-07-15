# Purpose: POC to Backup ETL Database for Wilson Restaurant Supply Inc.

# ----- App Functions -----
function Get-AppFunctions-SqlBkup()
{
    $List = @()
    $List += "function App-SqlBkup-Login()"
    $List += "function App-SqlBkup-01-Import-Modules()"
    $List += "function App-SqlBkup-02GetInfo()"
    $List += "function App-SqlBkup-03Prep()"
    $List += ""
}

function App-SqlBkup-Login()
{
    if ($Global:login -ne $true) { login-azurermAccount; $Global:login = $true }
    Select-AzureRmSubscription -SubscriptionId "b6204063-8515-424a-915d-558f27eef1ed" #DevOps - Service Springboard
    # Map the drive to the backup drive to make sure we are connected to it
    net use B: /delete
    net use B: \\sssqldbcustbackupsauto.file.core.windows.net\customerbackups /u:AZURE\sssqldbcustbackupsauto z/hpT61XDLFEJ0DenyJfrIrAZsvcaBMRuz9sGYpo+yzGIEKa281cfUytEPoKjHjGkzSSZ9A0IdmyCaAX63fIHw==
}

function App-SqlBkup-01-Import-Modules()
{
    $Global:S = New-PSSession
    Invoke-Command -ScriptBlock {Import-Module Sqlps} -Session $S
    Invoke-Command -ScriptBlock {Import-Module azurerm} -Session $S
}

function App-SqlBkup-02GetInfo()
{
    $Global:ComputerName = "SFMDemo"
#    $InstanceList = Invoke-Command -ScriptBlock  {get-childitem | Select-Object -ExpandProperty "InstanceName"}
    $Global:InstanceList = (get-itemproperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances
}

function App-SqlBkup-03Prep()
{
    # Using: will allow the script to pull from the local machine instead of pulling from a variable with the same name on the server
    Invoke-Command -ScriptBlock {set-location ("SQLSERVER:\SQL\" + $args[0] + "\" )} -Session $S -ArgumentList $Global:ComputerName
    $Global:InstanceName = $Global:InstanceList[0]
    
    invoke-command -scriptblock { set-location ("SQLSERVER:\SQL\" + $args[0] + "\" + $args[1] + "\Databases") } -Session $Global:S -ArgumentList ($Global:ComputerName, $Global:InstanceName)
    $Global:DbList = Invoke-Command -scriptblock { get-childitem | Select-Object -ExpandProperty "Name" } -Session $Global:S
    
    $Global:BackupName = ""
    [string]$Global:ServerInstance = ("" + $Global:ComputerName.ToUpper() + "\" + $Global:InstanceName)

    $Global:cred = Get-Credential -UserName "Windward" -Message "Enter login info for SQL Server (Windward Account)"
}

# ----- Start App-SqlBkup -----
App-SqlBkup-Login
App-SqlBkup-01-Import-Modules
App-SqlBkup-02GetInfo
App-SqlBkup-03Prep
    
    Write-Output " ----- Starting backup of databases -----"
    foreach($Item in $DbList)
    {
        Invoke-command -scriptblock `
        { 
            Backup-SqlDatabase -ServerInstance $args[0] -Database $args[1] -BackupFile ("C:\Scripts\" + $args[1] + ".bak") -Credential $args[2] 
        } -Session $S -ArgumentList ($Global:ServerInstance, $Item, $cred)
    }

    $FilesToCopy = invoke-command -scriptblock { Get-ChildItem -Path C:\Scripts\ | Where-Object { $_.Extension -eq ".bak" } } -Session $S
   
    Write-Output " ----- Starting copy of databases -----"
    foreach ($item in $FilesToCopy)
    {
        Copy-Item -Path $item.PsPath -Destination ("B:\" + $ComputerName + "\" + $Item.Name)
    }


   Write-Output " ----- DONE ----- "

