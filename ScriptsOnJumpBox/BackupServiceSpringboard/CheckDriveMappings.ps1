$Settings = @{}

# If you need to save the setting object again
#ConvertTo-Json -InputObject $Settings | Out-File -FilePath C:\Temp\settings.txt 

# Read settings
$Settings = Get-Content -Path C:\wws5\settings.txt | ConvertFrom-Json

# login in necessary
if ($login -ne $true) { Login-AzureRmAccount; $login = $true }
Select-AzureRmSubscription -SubscriptionId $Settings.SubscriptionId

# get the list of computers in the ServiceSpringboard resource group
$Computer = get-azurermvm -ResourceGroupName $Settings.VmRg -Status | Select-Object -Property "Name","PowerState"
$ComputerOn = get-azurermvm -ResourceGroupName $Settings.VmRg -Status | Select-Object -Property "Name","PowerState" | Where-Object {$_.PowerState -eq "VM running"}
#Invoke-Command -ComputerName "SSAppCustVM1" -ScriptBlock {net use B:}

# Provide a list of VMs that are off
$ComputerOff = get-azurermvm -ResourceGroupName $Settings.VmRg -Status | Select-Object -Property "Name","PowerState" | Where-Object {$_.PowerState -eq "VM deallocated"}
Write-Output "These VMs are off"
$ComputerOff
# if user presses C then exit
if ("C" -eq (Read-Host "press any key to continue, or C to cancel")) { break }

# build remote name string so that we can compare the remote name on net use to what it should be based on the settings we pass in.
$RemoteName = "\\" + $Settings.StorageAccount + ".file.core.windows.net\" + $Settings.ShareName

$i = 0
for ($i = 0; $i -lt $ComputerOn.Count; $i++)
{
    Write-Output ("Net Use on " + $ComputerOn[$i])
    $B = Invoke-Command -ComputerName $ComputerOn[$i].Name -ScriptBlock {net use B:}
    if ($B[1] -ne ("Remote name       " + $RemoteName)) # if remote name isn't the azure storage file share on the storage account specified
    {
        # ask if you want it replaced with the correct one
        Write-Output ("" + $ComputerOn[$i].Name + " does not have the correct drive mapping: " + $B[1])
        $Choice = Read-Host -Prompt ("Press any key to ignore, or press R to remap to: " + $RemoteName)
        if ($Choice -eq "R") 
        { 
            Invoke-Command -ComputerName $ComputerOn[$i].Name -ScriptBlock {net use B: "" + $Using:RemoteName + " /u:AZURE\" + $Using:Settings.StorageAccount + " " + $Using:Settings.StorageAccount } 
        }
    }
}




