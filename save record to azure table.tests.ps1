# Use TDD to build a PSScript that adds a record to the time tracking database

# does it return a Data Table

# does is succeed
function test-does_Add-SqlRecord_Return_DataTable()
{
    # Arrange
    [string]$TypeOf = ""
    [System.Data.DataTable]$DataTable = New-Object System.Data.DataTable
    [bool]$IsNull = $false

    # Act
    $DataTable = New-Object System.Data.DataTable
    $DataTable = Add-AzureSqlRecord
    #$TypeOf = $DataTable.GetType()
    
    # Assert
    $DataTable -ne $null
    #$TypeOf -eq "System.Data.DataTable"

}


# does it exist
function test-does_it_exist()
{
    # Arrange
    [bool]$exists = $false

    # Act
    $exists = Test-CommandExists "Add-AzureSqlRecord"
    
    # Assert
    $exists -eq $true
    
}

Function Test-CommandExists

{

 Param ($command)

 $oldPreference = $ErrorActionPreference

 $ErrorActionPreference = ‘stop’

 try {if(Get-Command $command){$true}}

 Catch {$false}

 Finally {$ErrorActionPreference=$oldPreference}

} #end function test-CommandExists