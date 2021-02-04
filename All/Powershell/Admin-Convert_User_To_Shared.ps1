#requires -version 2

#  Admin-Convert_User_to_Shared.ps1
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
$dl= Get-DistributionGroup

# Set mailbox to Shared
Set-Mailbox $userpn -type shared

# Set password strength and remove Office, Department and Title fields
Set-MsolUser –userPrincipalName $userpn -StrongPasswordRequired $false -Office "" -Department "" -Title ""

# Remove Company field
Set-User $userpn -Company ""

# Use sleep function to allow previous tasks to complete
New-Sleep -s 30

# Verify mailbox has been converted to Shared
Get-Mailbox -Identity $userpn | Format-List RecipientTypeDetails

# Remove license
Set-MsolUserLicense -UserPrincipalName $userpn -RemoveLicenses $assignedlic