# Create an info hash table to store the data I gather
$Info = @{}

# save the service info
#Get-Service | Where-Object {$_.Name -like "SystemFive*ETLService*"} | Select-Object -Property "Name"
$Info["Service"] = Get-Service | Where-Object {$_.Name -like "*SystemFive*ETLService*"}
#$Info = @{}

$Temp = Get-ChildItem -path 'Registry::HKEY_CURRENT_USER\SOFTWARE\Windward\System Five\'

[Int32]$i = 0

$obj = [psobject]@()


$DataSets = $Temp | Select-Object -Property "PSChildName","Name" 
foreach ($D in $DataSets)
{
    #" " + $i + " " + $D.PSChildName + " contains `"" + $Temp[$i].ValueCount + "`" values"
    $X = (get-itemproperty -Path ("Registry::" + $Temp[$i].Name)).'(default)'

    #" " + $i + " " + $D.PSChildName + " === `"" + $X + "`", last used " + (get-itemproperty -Path ("Registry::" + $Temp[$i].Name)).'LastUsed'

    $Tp = New-Object psobject
    Add-Member -InputObject $Tp -MemberType NoteProperty -Name "PSChildName" -Value $Temp[$i].PSChildName
    Add-Member -InputObject $Tp -MemberType NoteProperty -Name "Name" -Value $Temp[$i].Name
    Add-Member -InputObject $Tp -MemberType NoteProperty -Name "FriendlyName" -Value $X
    Add-Member -InputObject $Tp -MemberType NoteProperty -Name "LastUsed" -Value (get-itemproperty -Path ("Registry::" + $Temp[$i].Name)).'LastUsed'
    $obj += $Tp
    $i = $i + 1
}

$i = 0
$obj = ($obj | Sort-Object -Property "FriendlyName")
foreach ($o in $obj)
{
    " " + $i + " " + $o.'FriendlyName' + " === `"" + $o.'PSChildName' + "`", last used " + $o.'LastUsed'
    $i++
}
$Choice = Read-Host "Enter a choice"

#$Obj[$Choice]
#$s5CompanyRegistry = $Obj[$Choice]
#$X = get-itemproperty -Path ("Registry::" + $s5CompanyRegistry.Name)
#"-----"
#$X.'(default)'
#"-----"

$Info["CompanyName"] = $s5CompanyRegistry.FriendlyName

# get the version number of SYstem Five. You will have to enter the system Five path (get it from the shortcut)
$S5Path = (Read-Host -Prompt "Enter path to SystemFive executable including the file name and extension. (Get this from the shortcut to System Five")
$s5Ver = (Get-Item $S5Path).VersionInfo
$info["S5Path"] = $S5Path
$info["S5Ver"] = $s5Ver

# see if the file version is valid for System Five
if ($s5Ver.FileVersion -like "6.2.2.%") { Write-Host ("The version number " + $s5Ver.FileVersion + " does not match the pattern 6.2.2.%") }
else { Write-Host ("The version number " + $s5Ver.FileVersion + " is good") }

# does the DSN exist?
# Can I get a list of DSN's 
#Get-OdbcDsn | Select-Object -Property "Name" | Sort-Object -Property "Name"
# get list of pervasive 32-bit DSNs by looking at port number 1583
#$DSN = Get-OdbcDsn | Where-Object {$_.Attribute.TCPPort -eq "1583" -and $_.Platform -eq "32-bit"}
$DSN = Get-OdbcDsn | Where-Object {$_.DriverName -eq "Pervasive ODBC Engine Interface" -and $_.Platform -eq "32-bit"}

$DSN | Select-Object -Property "Name"

# enumerate the $DSN and select one

# To open odbc
#ODBCAD32

# Enable cloud integration flag (is it checked?), can I auto set it up?

# Get the number of delta records before

$Info["MD5Key"] = Read-Host -Prompt "Enter the MD5Key from setup wizard > Cloud Integration Settings > password key"

# Create a user record in System Five with the appropriate settings called webuser
# Create a user record in System Five with the appropriate settings called " wws5AppServer"

<<<<<<< HEAD
=======
# Idea: Take a recordcount of delta > monitor the change > if it stops before getting to 0 send an alert. Check messaging for which scenario it is
>>>>>>> origin/master

