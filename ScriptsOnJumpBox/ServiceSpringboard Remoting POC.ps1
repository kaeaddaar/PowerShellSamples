# get a list of computers from service springboard in azure

if ($login -eq $null) { login-azurermAccount; $login = $true }

#Get-AzureRmSubscription
#Select-AzureRmSubscription -SubscriptionName "DevOps - Service Springboard"
Select-AzureRmSubscription -SubscriptionId "b6204063-8515-424a-915d-558f27eef1ed"

$Computer = get-azurermvm -ResourceGroupName ServiceSpringboard -Status | Select-Object -Property "Name","PowerState"

# ----- export running state (start) -----
$csvPath = "D:\RunningComputers.csv"
#$Computer | Export-Csv -Path ("D:\RunningComputers, " + (get-date -Format g).Replace("/", "_").Replace(":","_") + ".csv")
$Computer | Export-Csv -Path ($csvPath)

Write-Output ("`"" + $csvPath + "`" created with current running state of VMs")


function Export-SsVmRunningState
{
    $Computer | Export-Csv -Path "C:\wws5\RunningComputers.csv" #Don't change because ServiceSpringboard.Tests.ps1 uses this file location
}
# ----- export running state (end) -----


# add a 0 based ObjId to each object in an array
function Add-ObjID($obj) { $i = 0; for ($i = 0 ; $i -lt $obj.Count; $i++) { Add-Member -InputObject $obj[$i] -MemberType NoteProperty -Name ObjId -Value $i } }

Add-ObjID $Computer
$Computer | Format-Table -AutoSize -Property "ObjId", "Name", "PowerState"


