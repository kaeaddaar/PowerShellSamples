$Path = 'C:\myPath'
$DDFPath = 'C:\myPath'
$dBName = 'myDb'
$Flags = 0
$TaskUser = 'playi'
$TaskPass = 'pwd'

$mdtoSession = New-Object -ComObject DTO.DtoSession
$connected = $mdtoSession.connect('localhost', $TaskUser, $TaskPass)

if ($mdtoSession.connected)
    {
    echo 'connected'
    $mdtoDatabase = New-Object -ComObject DTO.DtoDatabase
    $mdtoDatabase.DataPath = $Path
    $mdtoDatabase.DdfPath = $DDFPath
    $mdtoDatabase.Name = $dBName
    $mdtoDatabase.Flags = $Flags
    $mdtoSession.Databases.Add($mdtoDatabase)
    }
    else
    {
    echo 'no go'
    }