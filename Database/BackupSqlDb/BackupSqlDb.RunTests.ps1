
$Settings = @{}

# Read settings
$Settings = Get-Content -Path C:\Temp\settings.txt | ConvertFrom-Json

$MemberList = Get-Member -InputObject $Settings

$Results = New-Object PSCustomObject

$Results["Test-SubScriptionId-MethodExists"] = (Test-SubScriptionId-MethodExists -MemberList $MemberList)
$Results["Test-StorageAccount-MethodExists"] = (Test-StorageAccount-MethodExists -MemberList $MemberList)
$Results["Test-ShareName-MethodExists"] = (Test-ShareName-MethodExists -MemberList $MemberList)
$Results["Test-StorageAccountKey-MethodExists"] = (Test-StorageAccountKey-MethodExists -MemberList $MemberList)
$Results["Test-RgBkup-MethodExists"] = (Test-RgBkup-MethodExists -MemberList $MemberList)
$Results["Test-VmRg-MethodExists"] = (Test-VmRg-MethodExists -MemberList $MemberList)

#Checking the format of the guid that is the subscriptionId
$Results["Test-SubscriptionId-Len36"] = (Test-SubscriptionId-Len36 -StrGuid $Settings.SubscriptionId )
$Results["Test-StorageAccount-3To63"] = (Test-StorageAccount-3To63 -StorageAccount $Settings.StorageAccount)
$Results["Test-ShareName-3To63"] = (Test-ShareName-3To63 -ShareName $Settings.ShareName)

$Results

