Import-Module WebAdministration

Get-ChildItem IIS:\Sites
Get-ChildItem IIS:\AppPools

Stop-WebAppPool -Name "Internal" -Verbose

#identify existing Applications (Physical Path) on our app pool
$Application = Get-WebApplication | Where-Object {$_.ApplicationPool -eq "Internal"}

# Function to add a 0 based ObjId to each object in an array
function Add-ObjID($obj) { $i = 0; for ($i = 0 ; $i -lt $obj.Count; $i++) { Add-Member -InputObject $obj[$i] -MemberType NoteProperty -Name ObjId -Value $i } }

# add an objID so we can see the index easily
Add-ObjID -obj $Application

#show the applications
$Application | Select-Object -Property "objId", "Path", "ApplicationPool", "PhysicalPath" 


$Choice = Read-Host -Prompt "Enter the number of the app you want to update to a new application version. (WARNING: updating all applications with a matchin Physicl Path)"
if ("N" -eq (Read-Host -Prompt ("Did you mean to pick `"" + $Application[$Choice].PhysicalPath + "`"? (type N to cancel or hit enter to continue)")))
{
    Write-Output "Breaking"
    break
}

$NewAppPath_Web = "F:\iisSites\ServiceSpringboard.Web.Ver20170627"
$NewAppPath_Web_Api = "F:\iisSites\ServiceSpringboard.WebApi.Ver20170627"
if ("Y" -eq (Read-Host -Prompt "Press Y if you chose the WebApi, otherwize assuming you are updating the ServiceSpringboard.Web"))
{
    # updating .WebApi
    $NewAppPath = $NewAppPath_Web_Api
}
else
{
    # updating .Web
    $NewAppPath = $NewAppPath_Web
}

# ----- move all applications from the current version, to the updated fersion
$AppsByPath = Get-WebApplication | Where-Object {$_.PhysicalPath -eq $Application[$Choice].PhysicalPath}

Write-Output ('----- contents of $AppsByPath -----')
$AppsByPath
Read-Host -Prompt "The Apps above will be updated when you click enter"

# POC for set-ItemProperty on application
#Set-ItemProperty -Path "IIS:\Sites\Default Web Site\DevOpsCliffM.Training.Manager" -Name "physicalPath" -Value "F:\iisSites\ServiceSpringboard.Web.Ver20170627"

foreach($Item in $AppsByPath)
{
    Set-ItemProperty -Path ("IIS:\Sites\Default Web Site\" + $Item.path.Substring(1)) -Name "physicalPath" -Value $NewAppPath 
    Write-Output ("Updated `"IIS:\Sites\Default Web Site\" + $Item.path.SUbstring(1) + "`" to `"" + $NewAppPath + "`"" )
}

#show the applications
$Application | Select-Object -Property "objId", "Path", "ApplicationPool", "PhysicalPath" 
