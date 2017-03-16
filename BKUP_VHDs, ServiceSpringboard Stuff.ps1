# Sysprep located here: C:\Windows\System32\Sysprep
if ((Read-Host "Enter Y to login") -eq "Y") { Login-AzureRmAccount -SubscriptionName "Windward Software - Platform Credit" }

Function Backup-VHD ($storageAccount_Name, $srcUri, $storageKey, $BkupContainer_Name)
{

    $destContext = New-AzureStorageContext -StorageAccountName $storageAccount_Name -StorageAccountKey $storageKey

    $BkupContainer = Get-AzureStorageContainer -Name $BkupContainer_Name -Context $destContext
    if ($BkupContainer -eq $null) { New-AzureStorageContainer -Name $BkupContainer_Name -Context $destContext } #only needs to be ran the first time

    $Vhd_Name = $srcUri.Split("{/}")
    $Vhd_Name = $Vhd_Name[$Vhd_Name.Count - 1]
    $blob1 = Start-AzureStorageBlobCopy -srcUri $srcUri -DestContainer $BkupContainer_Name -DestBlob ((get-date -Format F) + ", " + $Vhd_Name) -DestContext $destContext
}

$StorageKey = "C+bql2ygMMeBU03zQHd4EolUi4rrQoNuFztVBxQTKvQO/vG9m4dTJEaOVgdymt7TFVa/G4LUsUFudE7x6WHHQA=="
#$StorageKey2 = $StorageKey
$StorageKey2 = "krs8eA2lVkEm6TP9Aua6JHJ5F8ceMMGObfb84Ko8YoiygqbSoOIqSKe/XiS8f8pw65Ql6PGiFWEmyvkuPK2g+Q=="

Backup-VHD -storageAccount_Name "serviceappstorageacct" -srcUri "https://sfmdemostorageacct.blob.core.windows.net/vhds/SFMdemoOsDisk1.vhd" `
    -storageKey $StorageKey -BkupContainer_Name "bkupvhds"

Backup-VHD -storageAccount_Name "serviceappstorageacct" -srcUri "https://sfmdemotestdatastorage.blob.core.windows.net/sfmdata/SFMdemodata.vhd" `
    -storageKey $StorageKey2 -BkupContainer_Name "bkupvhds"

# The next thing I would like to do to this script is take the VM down, backup the images, then start up the VM
# I could also save this in the appropriate structure, loading the details from a settings file etc. 
