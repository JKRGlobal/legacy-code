# Powershell

#  Connect-Office_365.ps1
#
#
#  Created by Stephen Warneford-Bygrave on 13/02/2015.
#

# Set user name and passwords as variables

$LiveCred = Get-Credential -Credential "sysadmin@jkrglobal.com"

# Set PowerShell session as variable

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection

# Create new PowerShell session

Import-PSSession $Session 
Connect-MsolService -Credential $LiveCred

# 13/02/15  v1.0.1  Stephen Bygrave     Initial release