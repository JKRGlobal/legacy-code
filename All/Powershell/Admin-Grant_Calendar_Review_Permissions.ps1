#requires -version 2

#  Admin-Grant_Calendar_Review_Permissions.ps1
#  Created by Stephen Warneford-Bygrave on 2016-01-25

# Enter e-mail address of required security group
$SECGRP = Read-Host -prompt "Enter security group E-mail address:"

$MBX=Get-DistributionGroupMember $SECGRP | select identity
 
$MBXCal=$MBX | % {Get-Mailbox -Identity $_.Identity}
 
$MBXCal | % {Set-MailboxFolderPermission $_":\Calendar" -AccessRights AvailabilityOnly -User Default}
 
#  Change the permission to allow the security group to have Reviewer access rights on all the calendar folders of the members of the same security group:
 
$MBXCal | % {Add-MailboxFolderPermission $_":\Calendar" -AccessRights Reviewer -User $SECGRP}
 
#  to verify that the permissions have been set, you can run this command:
 
$MBXCal | % {Get-MailboxFolderPermission $_":\Calendar" -User $SECGRP} | select accessrights,identity