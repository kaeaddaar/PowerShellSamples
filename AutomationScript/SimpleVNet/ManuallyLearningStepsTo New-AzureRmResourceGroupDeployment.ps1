Set-AuthenticodeSignature -Certificate @(Get-ChildItem Cert:\CurrentUser\my -CodeSigningCert)[0] -FilePath .\*.ps1

Login-AzureRmAccount

Set-AzureRmContext -SubscriptionName "VSE MPN"

Test-AzureRmResourceGroupDeployment -ResourceGroupName cmTemplate2 -TemplateParameterFile .\parameters.json -TemplateFile .\template.json

New-AzureRmResourceGroupDeployment -Name "TestDeployment" -ResourceGroupName cmTemplate2 -TemplateFile .\template.json -TemplateParameterFile .\parameters.json
