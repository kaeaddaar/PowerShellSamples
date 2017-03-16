Import-Module .\deploy_VNet.psm1
#Remove-Module .\deploy_VNet.psm1
cd C:\Users\cmackay\Documents\GitHub\PowerShellSamples\AutomationScript\SimpleVNet

$ResourceGroup_Name = "cmTemplate7"
$ResourceGroup_Location = "westus2"
$SubscriptionName = "VSE MPN"
# sign in
if ((Read-Host "Enter Y to Login") -eq "Y") { Login-AzureRmAccount; }

# Create VNet
Add-Deployment_VNet -subscriptionName $SubscriptionName -resourceGroupName $ResourceGroup_Name -resourceGroupLocation $ResourceGroup_Location `
    -deploymentName "DeployTest1" -templateFilePath .\01-VNet_template.json `
    -parametersFilePath .\01-VNet_parameters.json -Verbose

# Create PublicIp
Add-Deployment_VNet -subscriptionName $SubscriptionName -resourceGroupName $ResourceGroup_Name -resourceGroupLocation $ResourceGroup_Location `
    -deploymentName "DeployTest2" -templateFilePath .\02-PublicIp_Template.json `
    -parametersFilePath .\02-PublicIp_Parameters.json -Verbose

# Create Nic
Add-Deployment_VNet -subscriptionName $SubscriptionName -resourceGroupName $ResourceGroup_Name -resourceGroupLocation $ResourceGroup_Location `
    -deploymentName "DeployTest3" -templateFilePath .\03-Nic_template.json `
    -parametersFilePath .\03-Nic_parameters.json -Verbose

# I am getting an error record with the code "DnsRecordInUse" regularly. Checking for DNS records when appropriate would be great. 
# 02-PublicIp_Template.json contains a reference to a DNS

