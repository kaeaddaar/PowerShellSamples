# Functions for BackupServiceSpringboard
# ----- Pick your computer (start) -----
$Computer = get-azurermvm -ResourceGroupName ServiceSpringboard -Status | Select-Object -Property "Name","PowerState"

# add a 0 based ObjId to each object in an array
function Add-ObjID($obj) { $i = 0; for ($i = 0 ; $i -lt $obj.Count; $i++) { Add-Member -InputObject $obj[$i] -MemberType NoteProperty -Name ObjId -Value $i } }

# display the list of computers
Add-ObjID $Computer
$Computer | Format-Table -AutoSize -Property "ObjId", "Name", "PowerState"

# select a computer
$SsVmChoice = Read-Host -Prompt "Enter ObjId of computer"
# if not in range, break
if (($SsVmChoice -lt 0) -or ($SsVmChoice -ge $Computer.Length) ) { Write-Output ("`"" + $SsVmChoice + "`" is invalid, breaking"); break }
# ----- Pick your computer (end) -----
