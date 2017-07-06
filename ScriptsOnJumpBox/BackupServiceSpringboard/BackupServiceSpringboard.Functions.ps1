# Functions for BackupServiceSpringboard
function Test-ListContains($List, $Item) 
{ 
    [int]$i = 0; 
    for ($i = 0; $i -lt $List.Length; $i++) 
    { 
        if ($List[$i] -eq $Item) 
        { 
            return $true 
        }
    }
    return $false
}

