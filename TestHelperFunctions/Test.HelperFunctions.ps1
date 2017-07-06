function Add-Test ([ref]$ArrTestResults, [string]$Name, [bool]$TestResult, [string]$Description)
{
    try
    {
        $obj = New-Object PSCustomObject
        Add-Member -InputObject $obj -MemberType NoteProperty -Name "Name" -Value $Name
        Add-Member -InputObject $obj -MemberType NoteProperty -Name "AssertionSuccess" -Value $TestResult
        Add-Member -InputObject $obj -MemberType NoteProperty -Name "Description" -value $Description
        $Arr = ($ArrTestResults)
        $Arr.Value += $obj
        Return 1 #success
    }
    catch
    {
        Return 0 #failure
    }
    finally
    {
        $obj = $null
    }

}

#POC for Add-Test
if ($false)
{
    $ArrResults = @()

    $obj = New-Object PSCustomObject
    Add-Member -InputObject $obj -MemberType NoteProperty -Name "Name" -Value "Test-ConnectionExists"
    Add-Member -InputObject $obj -MemberType NoteProperty -Name "Assertion" -Value (Test-ConnectionExists)
    Add-Member -InputObject $obj -MemberType NoteProperty -Name "Description" -value "Simple test to see that we can create a System.Data.DataTable object"

    $ArrResults += $obj
    $ArrResults += $obj
    $ArrResults += $obj
}