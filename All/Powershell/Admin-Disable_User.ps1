#requires -version 2

#  Admin-Disable_User.ps1
#  Created by Stephen Warneford-Bygrave on 2015-09-03

# Create "Sleep" function
function New-Sleep  {
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Mandatory=$true, HelpMessage="No time specified")] 
        [int]$s
        )
    for ($i=1; $i -lt $s; $i++) {
        [int]$TimeLeft=$s-$i
        Write-Progress -Activity "Configuring Mailbox..." -PercentComplete (100/$s*$i) -CurrentOperation "$TimeLeft seconds left ($i elapsed)" -Status "Please wait"
        Start-Sleep -s 1
       }
    Write-Progress -Completed $true -Status "Please wait"
}

# Set variables for user association
$userpn = read-host -Prompt "User e-mail address"
$pass = read-host -Prompt "New password"
$assignedlicraw = Get-MsolUser -UserPrincipalName $userpn | Ft Licenses -HideTableHeaders | out-string
$assignedlicwhitespace = $assignedlicraw.trim()
$assignedlic = $assignedlicwhitespace.trim("{","}")
$delegate = read-host "Delegate e-mail address"
$dl= Get-DistributionGroup

# Grant delegate permissions for access
Add-MailboxPermission $userpn -user $delegate -Accessright FullAccess

# Set mail forward to delegate
Set-Mailbox $userpn -ForwardingAddress $delegate

# Set password strength and remove Office, Department and Title fields
Set-MsolUser –userPrincipalName $userpn -StrongPasswordRequired $false -Office "" -Department "" -Title ""

# Change user password
Set-MsolUserPassword –userPrincipalName $userpn -NewPassword $pass -ForceChangePassword $false

# Remove Company field
Set-User $userpn -Company ""

# Set mailbox to Shared
Set-Mailbox $userpn -type shared

# Use sleep function to allow previous tasks to complete
New-Sleep -s 30

# Verify mailbox has been converted to Shared
Get-Mailbox -Identity $userpn | Format-List RecipientTypeDetails

# Remove license
Set-MsolUserLicense -UserPrincipalName $userpn -RemoveLicenses $assignedlic

# Hide from address book
Set-Mailbox -Identity $userpn -HiddenFromAddressListsEnabled $true

# Remove member DLs from user
foreach( $dg in $dl){
Remove-DistributionGroupMember $dg.name -Member $userpn -confirm:$false
}