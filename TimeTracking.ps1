."C:\Users\playi\Documents\GitHub\PowerShellSamples\TimeTracking.functions.ps1"
#Included functions:
#function ExecuteSqlQuery ($Server, $Database, $SQLQuery) {
#function Set-Task ([string]$Task50,[switch]$Start) # start or end a task
#function get-ProjectList($Server, $Database, $credSql)

[string] $Server= "cmwws5sql.database.windows.net"
[string] $Database = "InternalTools"
[string] $UserSqlQuery= $("SELECT * FROM [dbo].[TimeTracking_simple]")

if ($HaveCred -ne $true) 
{ 
    $cred = Get-Credential
    $Password = $cred.Password
    $Password.MakeReadOnly()
    $credSql = New-Object System.Data.SqlClient.SqlCredential($cred.UserName, $Password)
    $HaveCred = $true 
}


# declaration not necessary, but good practice
$resultsDataTable = New-Object System.Data.DataTable
$resultsDataTable = ExecuteSqlNonQuery $Server $Database $UserSqlQuery $credSql

if ($started -ne $true)
{
    $msg = Read-Host -Prompt "Enter a description for your task up to 50 characters."
    # trim to 50
    if ($msg.Length -gt 50) { Write-Output ("" + $msg.Length + " records is too long truncated to 50 characters: "); $msg = $msg.trimstart(50); Write-Output ("`'" + $msg + "`"") }
    # when blank set default
    if ($msg.Length -eq 0) { Write-Output ("nothing entered, using `"(default)`""); $msg = "(default)" }
}

if ($started = $true) # end task
{ Set-Task -Task50 $msg; $started = $false }
else                  # start0 Task
{ Set-Task -Task50 $msg -Start; $started = $true }

# how long has it been since task started/ended?
