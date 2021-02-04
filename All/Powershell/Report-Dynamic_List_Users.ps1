#requires -version 2

#  Report-Dynamic_List_Users.ps1
#  Created by Stephen Warneford-Bygrave on 2016-03-03

# Create variable for dynamic list name
$groupname = read-host -Prompt "Dynamic Group e-mail address"

# Get members of dynamic list
$members = Get-DynamicDistributionGroup -Identity $groupname

# Output to CSV file
Get-Recipient -RecipientPreviewFilter $members.RecipientFilter >  dynamic.csv