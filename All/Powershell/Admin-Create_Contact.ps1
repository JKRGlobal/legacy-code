#requires -version 2

#  Admin-New_User.ps1
#  Created by Stephen Warneford-Bygrave on 2016-05-18

# Create "Sleep" function
function New-Sleep	{
    [cmdletbinding()]
        param(
            [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Mandatory=$true, HelpMessage="No time specified")]
        [int]$s
    )
    for ($i=1; $i -lt $s; $i++) {
        [int]$TimeLeft=$s-$i
            Write-Progress -Activity "Configuring Contact..." -PercentComplete (100/$s*$i) -CurrentOperation "$TimeLeft seconds left ($i elapsed)" -Status "Please wait"
        Start-Sleep -s 1
    }
    Write-Progress -Completed $true -Status "Please wait"
} # end function New-Sleep

# Set variables for user association
$fn = read-host -Prompt "First Name"
$sn = read-host -Prompt "Surname"
$userpn = read-host -Prompt "User e-mail address"
$title = read-host -Prompt "Job Title"
$comp = read-host -Prompt "Company"

# Create contact
New-MailContact -Name "$fn $sn" -ExternalEmailAddress $userpn

# Call Sleep function
New-Sleep -s 10

# Set contact details
Set-Contact -identity $userpn -Title $title -Company $comp
