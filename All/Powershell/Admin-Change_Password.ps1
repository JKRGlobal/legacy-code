#requires -version 2

#  Admin-Change_Password.ps1
#  Created by Stephen Warneford-Bygrave on 2014-11-25

# Create variables
$userpn = read-host -Prompt "User e-mail address"
$pass = read-host -Prompt "User password"

# Set password to enable weak passwords
Set-MsolUser -userPrincipalName $userpn -StrongPasswordRequired $false

# Change password
Set-MsolUserPassword -userPrincipalName $userpn -NewPassword $pass -ForceChangePassword $false
