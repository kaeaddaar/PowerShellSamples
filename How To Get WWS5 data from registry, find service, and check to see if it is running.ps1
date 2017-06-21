Get-Service | Where-Object {$_.Name -like "SystemFiveZ*ETLService*"} | Select-Object -Property "Name"

$Temp = Get-ChildItem -path 'Registry::HKEY_CURRENT_USER\SOFTWARE\Windward\System Five\'

[Int32]$i = 0

$DataSets = $Temp | Select-Object -Property "PSChildName","Name" 
foreach ($D in $DataSets)
{
    " " + $i + " " + $D.PSChildName + " === `"" + $Temp[$i].SubKeyCount + "`""
    $i = $i + 1
}

$Choice = Read-Host "Enter a choice"
$Temp[$Choice]
$DeptDemo = $Temp[$Choice]
$X = get-itemproperty -Path ("Registry::" + $DeptDemo.Name)
$X.'(default)'