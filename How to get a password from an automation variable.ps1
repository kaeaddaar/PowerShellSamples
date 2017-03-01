Login-AzureRmAccount -SubscriptionName "VSE MPN"

get-command *variable*
Get-AzureRmResourceGroup | Select-Object -Property ResourceGroupName
Get-AzureRmAutomationVariable -ResourceGroupName "DevAPITest6" -AutomationAccountName "DevAPIAutomation"

$PWD = Get-AzureRmAutomationVariable -Name "PWD" -ResourceGroupName "DevAPITest6" -AutomationAccountName "DevAPIAutomation"

get-command *secret*

# how to get from a secret in a key vault
$PWD = Get-AzureKeyVaultSecret -VaultName "DevAPI6KeyVault" -Name "WWS5PWD"
$PWD.SecretValueText #Clear Test PWD

get-command *Secure*

$PWD

