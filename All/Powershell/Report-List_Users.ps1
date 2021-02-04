# Powershell

#  Report-List_Users.ps1
#
#
#  Created by Stephen Warneford-Bygrave on 23/06/2015.
#

# Create variable for dynamic list name

$groupname = read-host -Prompt "Dynamic Group e-mail address"

# Output to CSV file

Get-DistributionGroupMember -Identity $groupname | export-csv Desktop\Dynamic_List_Membership.csv

# 23/06/2015	v1.0.1  Stephen Bygrave		Initial release