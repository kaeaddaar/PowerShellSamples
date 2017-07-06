# ----- This include file (dot sourced file) contains the time tracking programs function library -----
."C:\Users\playi\Documents\GitHub\PowerShellSamples\TimeTracking.functions.ps1"
#Included functions:
#function ExecuteSqlQuery ($Server, $Database, $SQLQuery) {
#function Set-Task ([string]$Task50,[switch]$Start) # start or end a task
#function get-ProjectList($Server, $Database, $credSql)

# ----- This include file (dot sourced file) contains helper functions for testing -----
."C:\Users\playi\Documents\GitHub\PowerShellSamples\TestHelperFunctions\Test.HelperFunctions.ps1"
#function Add-Test ([ref]$ArrTestResults, [string]$Name, [bool]$TestResult, [string]$Description)

# ----- This include file (dot sourced file) contains all of the test functions -----
."C:\Users\playi\Documents\GitHub\PowerShellSamples\Database\DbAccess.Tests.ps1"

if ($ArrResults -eq $null)
{
    $ArrResults = @()
}

Add-Test -ArrTestResults ([ref]$ArrResults) -Name "Test-ConnectionExists" -TestResult (Test-Connection-Exists) -Description "Simple test to see that we can create a System.Data.DataTable object"



$ArrResults

function remove-TestResults() #clears the test results
{
    Set-Variable -Name "ArrResults" -Value @() -Scope Global
}
