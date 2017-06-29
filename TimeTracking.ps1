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

# executes a query and populates the $datatable with the data
function ExecuteSqlQuery ($Server, $Database, $SQLQuery) {
    $Datatable = New-Object System.Data.DataTable
    
    $Connection = New-Object System.Data.SQLClient.SQLConnection
    #$Connection.ConnectionString = "server='$Server';database='$Database';trusted_connection=true;"
    $Connection.Credential = $credSql
    $Connection.ConnectionString = ("Server=tcp:" + $Server + ",1433;Database=" + $Database + ";Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;")
    #$Connection.ConnectionString = ("Server Name=myServerAddress;Database Name=myDataBase;User ID=myUsername;Password=myPassword;")
 
    $Connection.Open()
    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection
    $Command.CommandText = $SQLQuery
    $Command.ExecuteNonQuery()
    $Connection.Close()
    
    return $Datatable
}

# declaration not necessary, but good practice
$resultsDataTable = New-Object System.Data.DataTable
$resultsDataTable = ExecuteSqlQuery $Server $Database $UserSqlQuery $UserPSqlQuery

function Set-Task ([string]$Task50,[switch]$Start) # start or end a task
{
    [string]$StartEndDateTime = get-date -Format "yyyy-MM-dd HH:mm:ss"
    if ($Start) { $TrueOrFalse = 1 } Else {$TrueOrFalse = 0}
    $sql = ("INSERT INTO [dbo].[TimeTracking_simple] (Task, bStarting, StartEndDateTime) VALUES ('" + $Task50 + "', '" + $TrueOrFalse + "', '" + $StartEndDateTime + "' );")
    ExecuteSqlQuery $Server $Database $sql
}

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
