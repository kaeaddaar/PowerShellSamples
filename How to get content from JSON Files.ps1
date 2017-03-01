
get-command *json*
Get-Command *content*

Get-AzureRmAutomationVariable -Name ""PWD"" -ResourceGroupName ""DevAPITest6"" -AutomationAccountName ""DevAPIAutomation""


$X = (Get-Content -Path .\LiveInstance.json) -join "`n" | ConvertFrom-Json

$X.parameters