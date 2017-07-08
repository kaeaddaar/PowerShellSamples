# This function was tricky because the -ErrorAction of get-childitem doesn't cause the catch to fire unless the -ErrorAction is Stop
function Test-SourceFolderExists()
{
    # Arrange
    [string]$SourceFolder = "X:\CS\Public\Springboard\6_2_2_14x"
    [bool]$Success = $false

    # Act
    try
    {
        $Folder = Get-ChildItem -Path $SourceFolder -ErrorAction Stop
    }
    catch 
    {
        # Folder was not found
        # Assert
        $Success = $false
    }
    finally
    {
        $Folder = $null
    }

    # Assert
    return $true
}

Test-SourceFolderExists