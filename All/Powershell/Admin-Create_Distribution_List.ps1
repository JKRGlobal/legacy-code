#requires -version 2

#  Admin-Create_Distribution_List.ps1
#  Created by Stephen Warneford-Bygrave on 2015-04-02

# Set variables
$dn = read-host -Prompt "Distribution Group Name"
$alias = $dn -replace " ",""
$aliaslower = $alias.tolower()
$email = $aliaslower + "@jkrglobal.com"

# Run DL creation command
New-DistributionGroup -DisplayName $dn -Name $alias -Alias $alias -PrimarySMTPAddress $email
