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


#validate we got data
Write-Host ("The table contains: " + $resultsDataTable.Rows.Count + " rows")

function Task ([switch]$Start, [string]$Task50)
{
    if ($Start) { $TrueOrFalse = 1 } Else {$TrueOrFalse = 0}
    $sql = ("INSERT INTO [dbo].[TimeTracking_simple] (Task, bStarting) VALUES ('" + $Task50 + "', " + $TrueOrFalse + " );")
    ExecuteSqlQuery $Server $Database $sql
}

Task "TDD" -Start
if ($false)
{
    # Stops Task
    Task "TDD"
}
