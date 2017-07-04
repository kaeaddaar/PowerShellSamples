class cmLogin
{
    [securestring]$UserName
    [securestring]$Password
    SetUsername($UName)
    {
        $this.UserName = ConvertTo-SecureString -String $UName -AsPlainText -Force
    }

    SetPassword($Pwd)
    {
        $this.Password = ConvertTo-SecureString -String $Pwd -AsPlainText -Force
    }

    Login()
    {
        Login-AzureRmAccount
    }

    SelectSubscription()
    {
        
    }
}

[console]::beep(800,900)
