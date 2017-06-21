if ($LoggedIn -ne "y")
{
    Login-AzureRmAccount
    Select-AzureRmSubscription -SubscriptionId "b6204063-8515-424a-915d-558f27eef1ed" #DevOps - Service Springboard
    $LoggedIn = "y"
}

# Resource Group: DevOps - Service Springboard
# Application gateway: ServiceAppAg
# Rule (Path-based): PathBasedRule
# Get-AzureRmApplicationGatewayUrlPathMapConfig
# Get-AzureRmApplicationGateway

$Gateway = Get-AzureRmApplicationGateway -Name "ServiceAppAg" -ResourceGroupName "ServiceSpringboard"
$Rule = Get-AzureRmApplicationGatewayUrlPathMapConfig -Name "PathBasedRule" -ApplicationGateway $Gateway

$i = 0
#$rule.PathRules | Select-Object -Property "name", "Paths", "ID"

$str = [string]$rule.PathRules[0].Id
$str.Substring(1 + $str.LastIndexOf("/", $str.Length))

$RuleID = @()
for ($i = 0; $i -lt $str.Length; $i++)
{
    $str = [string]$rule.pathrules[$i].BackendAddressPool.Id
    $RuleID += $str.Substring(1 + $str.LastIndexOf("/", $str.Length))
    $rule.PathRules[$i].id = $RuleID[$i]
}

$rule.PathRules | Select-Object -Property "name", "Paths", "id"

($rule.PathRules[$i].backendaddresspool.Id)

# -----
# Get list of IIS applications/alias' on a server

#should probably start by how to remote into server, and check if IIS Administration cmdlets are installed. If not, install them

Invoke-Command  -ComputerName $serverName { Import-Module WebAdministration; Get-ChildItem -path IIS:\Sites | Format-Table} | Out-File -append $WebreportPath







