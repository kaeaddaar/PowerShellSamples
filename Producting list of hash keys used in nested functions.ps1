$Arr = New-Object System.Collections.ArrayList

function AA 
{
    $X = foreach ($item in @("One", "Two", "Three")) {$Arr.add($item)}
    function BB
    {
        @("Subnet.Name", "Subnet", "Subnet.AddressPrefix")
    }
    $X = foreach ($item in BB) {$Arr.Add($item)}
}    
AA

