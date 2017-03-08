
$srcUri = "https://cmsvcstorageacct.blob.core.windows.net/vhds/cmSvcOsDisk1.vhd"
$storageAccount = "cmsvcstorageacct"
$storageKey = "VPoGg7pIpIKYnMqZOa2vSxyKWwlACBmJqHNPYsvzCrAqQ1GLTKjmiUBzSJiCiE4DlgrUwqD6/kkrycG9zS7tMA=="

$destContext = New-AzureStorageContext -StorageAccountName $storageAccount -StorageAccountKey $storageKey

$containerName = "syspreppedvhds"

New-AzureStorageContainer -Name $containerName -Context $destContext

$blob1 = Start-AzureStorageBlobCopy -srcUri $srcUri -DestContainer $containerName -DestBlob "cmSvcOsDisk_SysPrepped.vhd" -DestContext $destContext
