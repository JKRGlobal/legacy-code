# Powershell

#  Admin-Create_User.ps1
#
#
#  Created by Stephen Warneford-Bygrave on 25/11/2014.
#

# Create "Sleep" function

function New-Sleep	{
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
} # end function New-Sleep

# Set variables for user association

$fn = read-host -Prompt "First Name"
$sn = read-host -Prompt "Surname"
$userpn = read-host -Prompt "User e-mail address"
$pass = read-host -Prompt "User password"
$dep = read-host -Prompt "Department"
$title = read-host -Prompt "Job Title"

# Determine user location

[int]$uls = 0
while ( $uls -lt 1 -or $uls -gt 4 ){
	Write-host "1. London"
	Write-host "2. New York"
	Write-host "3. Singapore"
    Write-host "4. Shanghai"
	[int]$uls = read-host "License Territory (Default is London)"}
Switch( $uls ){
	1{$ul = "GB"; $off = "London"}
	2{$ul = "US"; $off = "New York"}
	3{$ul = "SG"; $off = "Singapore"}
    4{$ul = "CN"; $off = "Shanghai"}
	default{$ul = "GB"; $off = "London"}
}

# Determine user license

[int]$lics =0
while ( $lics -lt 1 -or $lcs -gt 4 ){
	Write-host "1. Exchange Online (P1)"
	Write-host "2. Exchange Online (P2)"
	Write-host "3. Office 365 Enterprise (E3)"
	Write-host "4. Office 365 Enterprise (E4)" 
	[int]$lics = read-host "Exchange license (Default is P1)"}
Switch( $lics ){
	1{$lic = "EXCHANGESTANDARD"}
	2{$lic = "EXCHANGEENTERPRISE"}
	3{$lic = "ENTERPRISEPACK"}
	4{$lic = "ENTERPRISEWITHSCAL"}
	default{$lic = "EXCHANGESTANDARD"}
}

# Configure new user

New-MSOLUser -DisplayName "$fn $sn" -FirstName $fn -LastName $sn -UserPrincipalName $userpn -Department $dep -Office $off -Title $title -UsageLocation $ul -LicenseAssignment jkrglobal:$lic
Set-MsolUser –userPrincipalName $userpn -StrongPasswordRequired $false

# Set user password

Set-MsolUserPassword –userPrincipalName $userpn -NewPassword $pass -ForceChangePassword $false

# Call Sleep function 

New-Sleep -s 150

# Set company organisation

Set-User $userpn -Company "Jones Knowles Ritchie"

# 25/11/14  v1.0.1    Stephen Bygrave		Initial release