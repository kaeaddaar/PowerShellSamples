[string] $Server= ".\SQLEXPRESS2014"
[string] $Database = "DispatchApp"
[string] $UserSqlQuery= $("SELECT * FROM [dbo].[Table]")
[string] $UserPSqlQuery= "SELECT * FROM Billing"

if ($HaveCred -ne $true) 
{ 
    $cred = Get-Credential
    $Password = $cred.Password
    $Password.MakeReadOnly()
    $credSql = New-Object System.Data.SqlClient.SqlCredential($cred.UserName, $Password)
    $HaveCred = $true 
}

# executes a query and populates the $datatable with the data
function ExecuteSqlQuery ($Server, $Database, $SQLQuery, $PSQLQuery) {
    $Datatable = New-Object System.Data.DataTable
    
    $Connection = New-Object System.Data.SQLClient.SQLConnection
    #$Connection.ConnectionString = "server='$Server';database='$Database';trusted_connection=true;"
    $Connection.Credential = $credSql
    $Connection.ConnectionString = ("Server=tcp:cmartdispatchsqlserver.database.windows.net,1433;Database=DispatchApp;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;")
    #$Connection.ConnectionString = ("Server Name=myServerAddress;Database Name=myDataBase;User ID=myUsername;Password=myPassword;")
 
    $Connection.Open()
    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection
    $Command.CommandText = $SQLQuery
    $Reader = $Command.ExecuteReader()
    $Datatable.Load($Reader)
    $Connection.Close()
    
    #$OdbcConnection = New-Object System.Data.Odbc.OdbcConnection("Driver={ODBCCI64.DLL};Server=localhost;TrustedConnection=yes;Database=DemoData")
    $OdbcConnection = New-Object System.Data.Odbc.OdbcConnection("DSN=DemoData")
    $OdbcConnection.Open()

    $OdbcCommand = New-Object System.Data.Odbc.OdbcCommand
    $OdbcCommand.Connection = $OdbcConnection
    $OdbcCommand.CommandText = $PSQLQuery 
    $Reader = $OdbcCommand.ExecuteReader()
    $Datatable.Load($Reader)
    $OdbcConnection.close()
       
    return $Datatable
}

# declaration not necessary, but good practice
$resultsDataTable = New-Object System.Data.DataTable
$resultsDataTable = ExecuteSqlQuery $Server $Database $UserSqlQuery $UserPSqlQuery


#validate we got data
Write-Host ("The table contains: " + $resultsDataTable.Rows.Count + " rows")