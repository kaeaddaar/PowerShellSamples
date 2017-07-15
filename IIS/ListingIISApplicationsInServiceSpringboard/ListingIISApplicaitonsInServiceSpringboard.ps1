# Can I get access to all web apps on my servers in service springboard
# Proof


function Get-AppFunc-SsWebApps()
{
    Write-Output ('App-Login()')   

}


function App-Login([switch] $verbose)
{
    if ($Global:Login -ne $true)
    {
        Login-AzureRmAccount
        $Global:Login = $true
        Select-AzureRmSubscription -SubscriptionId  "b6204063-8515-424a-915d-558f27eef1ed"    
    }
    else
    {
        if ($verbose)
        {
            Write-output "Already logged in, not attempting to log in again"
        }
    }
}


# get list of VM's
function Get-VMs()
{
    $Global:SsVMs = Get-AzureRmVM -ResourceGroupName "ServiceSpringboard"
}

# ----- The App -----
App-Login -verbose
Get-VMs
