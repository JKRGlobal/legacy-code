# Powershell

#  Reset-User_Password.ps1
#
#
#  Created by Stephen Warneford-Bygrave on 25/11/2014.
#

# Set variables for user association

$userpn = read-host -Prompt "User e-mail address"
$pass = read-host -Prompt "User password"

# Set user password

Set-MsolUser -UserPrincipalName $userpn -StrongPasswordRequired $false
Set-MsolUserPassword -userPrincipalName $userpn -NewPassword $pass -ForceChangePassword $false

# 25/11/14  v1.0.1  Stephen Bygrave		Initial release