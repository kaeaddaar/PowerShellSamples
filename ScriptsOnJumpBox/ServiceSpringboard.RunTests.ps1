# Tests for Service Springboard
if ($login -eq $null) { login-azurermAccount; $login = $true; Select-AzureRmSubscription -SubscriptionId "b6204063-8515-424a-915d-558f27eef1ed" }


$Tests = @{}

$Tests["Test-Computer_PowerState_Correct"] = Test-Computer_PowerState_Correct

$Tests["Test-ETL_Running"] = Test-ETL_Running

$Tests
