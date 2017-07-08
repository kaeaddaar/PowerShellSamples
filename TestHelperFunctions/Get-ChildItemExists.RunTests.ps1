function Get-ChildItemExists([string]$Path)
{
    # Arrange
    [string]$SourceFolder = $Path
    [bool]$Exception = $false
    $Folder

    # Act
    try
    {
        $Folder = Get-ChildItem -Path $SourceFolder -ErrorAction Stop
    }
    catch [System.Management.Automation.ItemNotFoundException]
    {
        # Folder was not found
        # Assert
        $Exception = $True
        if ($Error[$Error.Count - 1].exception.GetType().fullname -ne "System.Management.Automation.ItemNotFoundException")
        {
            Write-Error $Error[$Error.Count - 1].exception.GetType().fullname
        }
    }

    finally
    {
        $Folder = $null
    }

    # Assert
    return (-not $Exception)

}

[string]$str270 = "A" * 270
$FileAndFolderSampleData = 'C:\_ProjectFolder - Shortcut.lnk', "$*^%!@%^", "C:\", "C:\DoesNotExist", "C:\insn't/well::structured", "\\localhost", "C:\" + $str270
foreach ($item in $FileAndFolderSampleData)
{
    Write-Output "----- (start) -----"
    Write-output ("" + $item)
    Write-output ("" + (Get-ChildItemExists $item))
    Write-Output "----- (end) -----"
}

$cmExceptions = [appdomain]::CurrentDomain.GetAssemblies() | ForEach {
    Try {
        $_.GetExportedTypes() | Where {
            $_.Fullname -match 'Exception'
        }
    } Catch {}
} | Select FullName




#$Arr = @()
#foreach ($item in $cmExceptions) {$Arr += $item.FullName}
#$Arr.GetType()
#$Arr | Where-Object { $_.StartsWith("System.Management.Automation.") }
$cmExceptions | Where-Object { $_.FullName.StartsWith("System.Management.Automation.") } | Select-Object -ExpandProperty "FullName"

