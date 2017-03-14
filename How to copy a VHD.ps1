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

Backup-VHD -storageAccount_Name "serviceappstorageacct" -srcUri "https://serviceappstorageacct.blob.core.windows.net/vhds/ServiceAppOsDisk1.vhd" `
    -storageKey "rtG5Wd8B+iV1yL8jXI4Y+0rwpGc8myedgIYG7DD4/LjpVjOQR3BlpK/K3k51EKS/kQ0l5lZ++q3OWQPIg9iGAA==" -BkupContainer_Name "bkupvhds"

Backup-VHD -storageAccount_Name "serviceappstorageacct" -srcUri "https://serviceappstorageacct.blob.core.windows.net/vhds/ServiceAppDataDisk1.vhd" `
    -storageKey "rtG5Wd8B+iV1yL8jXI4Y+0rwpGc8myedgIYG7DD4/LjpVjOQR3BlpK/K3k51EKS/kQ0l5lZ++q3OWQPIg9iGAA==" -BkupContainer_Name "bkupvhds"

# The next thing I would like to do to this script is take the VM down, backup the images, then start up the VM
# I could also save this in the appropriate structure, loading the details from a settings file etc. 
