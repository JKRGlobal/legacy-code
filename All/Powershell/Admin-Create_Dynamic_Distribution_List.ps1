#requires -version 2

#  Admin-Create_Dynamic_Distribution_List.ps1
#  Created by Stephen Warneford-Bygrave on 2016-05-18

# Create variables for script
$dn = read-host -Prompt "Dynamic List Name"
$office = read-host -Prompt "Office Location"
$dnns = $dn -replace " ",""
$email = $dnns + "@jkrglobal.com"

# Create group
New-DynamicDistributionGroup $dn -RecipientFilter "RecipientType -eq 'UserMailbox' -and Company -eq 'Jones Knowles Ritchie' -and Office -eq '$office'"
