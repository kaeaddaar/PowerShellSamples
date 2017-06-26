# Use TDD to build a PSScript that adds a record to the time tracking database

# does is succeed
function test-does_it_succeed()
{
    # Arrange
    [bool]$succeed = $false

    # Act
    $succeed = Add-AzureSqlRecord

    # Assert
    $succeed -eq $true

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