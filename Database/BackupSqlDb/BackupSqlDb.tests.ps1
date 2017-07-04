function Test-ListContains($List, $Item) 
{ 
    [int]$i = 0; 
    for ($i = 0; $i -lt $List.Length; $i++) 
    { 
        if ($List[$i].Name -eq $Item) 
        { 
            return $true 
        }
    }
    return $false
}

function Test-MethodExists($MethodName, $MemberList)
{
    Return Test-ListContains -List $MemberList -Item $MethodName
}

Function Test-SubScriptionId-MethodExists($MemberList) { return Test-MethodExists -MethodName "SubscriptionId" -MemberList $MemberList }
Function Test-StorageAccount-MethodExists($MemberList) { Test-MethodExists -MethodName "StorageAccount" -MemberList $MemberList }
Function Test-ShareName-MethodExists($MemberList) { Test-MethodExists -MethodName "ShareName" -MemberList $MemberList }
Function Test-StorageAccountKey-MethodExists($MemberList) { Test-MethodExists -MethodName "StorageAccountKey" -MemberList $MemberList }
Function Test-RgBkup-MethodExists($MemberList) { Test-MethodExists -MethodName "RgBkup" -MemberList $MemberList }
Function Test-VmRg-MethodExists($MemberList) { Test-MethodExists -MethodName "VmRg" -MemberList $MemberList }

Function Test-SubscriptionId-Len36([string]$StrGuid) { return ($StrGuid.Length -eq 36) } # Length of guid with dashes 
Function Test-StorageAccount-3To63([string]$StorageAccount) { return ($StorageAccount.Length -ge 3) -and ($StorageAccount.Length -le 63) } # https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions
Function Test-ShareName-3To63([string]$ShareName) { return ($ShareName.Length -ge 3) -and ($ShareName.Length -le 63) } # https://docs.microsoft.com/en-us/rest/api/storageservices/naming-and-referencing-shares--directories--files--and-metadata

