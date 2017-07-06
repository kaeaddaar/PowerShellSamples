."C:\Users\playi\Documents\GitHub\PowerShellSamples\TimeTracking.functions.ps1"
#Included functions:
#function ExecuteSqlQuery ($Server, $Database, $SQLQuery) {
#function Set-Task ([string]$Task50,[switch]$Start) # start or end a task
#function get-ProjectList($Server, $Database, $credSql)


function Test-Connection-Exists()
{
    #Arrange
    $Connection = New-Object System.Data.DataTable

    #Act
    [bool]$Assertion = ($Connection -is "System.Data.DataTable")
    
    #Assert
    return $Assertion
}

function Test-DataTable-Exists()
{
    #Arrange
    $Connection = New-Object System.Data.DataTable

    #Act
    [bool]$Assertion = ($Connection -is "System.Data.DataTable")
    
    #Assert
    return $Assertion
}



