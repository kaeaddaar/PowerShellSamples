Enter-PSSession dc
$cred = Get-Credential
New-ADUser -SamAccountName $cred.UserName -AccountPassword $cred.Password -CannotChangePassword $false -ChangePasswordAtLogon $false `
    -PasswordNeverExpires $true

#Exit-PSSession
`
