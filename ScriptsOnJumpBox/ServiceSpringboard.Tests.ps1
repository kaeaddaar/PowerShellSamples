
function Test-ETL_Running()
{
    # Arrange
    [bool]$Running = $false

    # Act

    # Assert
    $Running
}

# Integrations test
function Test-Computer_PowerState_Correct()
{
    # Arrange
    [bool]$CorrectState = $false
#    [object[]]$DesiredState = @()
#
#    $obj = New-Object PSObject
#    Add-Member -InputObject $obj -Name "Name" -Value "ServiceAppVm1" -MemberType NoteProperty
#    Add-Member -InputObject $obj -Name "PowerState" -Value "VM running" -MemberType NoteProperty
#    $DesiredState += $obj
#
#    $obj = New-Object PSObject
#    Add-Member -InputObject $obj -Name "Name" -Value "SSAppCustVm1" -MemberType NoteProperty
#    Add-Member -InputObject $obj -Name "PowerState" -Value "VM running" -MemberType NoteProperty
#    $DesiredState += $obj
#
#    $obj = New-Object PSObject
#    Add-Member -InputObject $obj -Name "PowerState" -Value "VM deallocated" -MemberType NoteProperty
#    Add-Member -InputObject $obj -Name "Name" -Value "SSAppCustVm1" -MemberType NoteProperty
#    $DesiredState += $obj
#
#    $obj = New-Object PSObject
#    Add-Member -InputObject $obj -Name "PowerState" -Value "VM running" -MemberType NoteProperty
#    Add-Member -InputObject $obj -Name "Name" -Value "SSJumpBox" -MemberType NoteProperty
#    $DesiredState += $obj
    $DesiredState = Import-Csv -Path "C:\wws5\RunningComputers.csv"
    $Computer = get-azurermvm -ResourceGroupName ServiceSpringboard -Status | Select-Object -Property "Name","PowerState"
    
    # Act
    $CorrectState = (Compare-Object $DesiredState $Computer).length -eq 0

    # Assert
    $CorrectState
}