# This script is going to set up an AD server, with minimal effort as an administrator.
# The script will replicate itself from Github, and will continue after reboots. 
# It will clean up after itself when done installing.


# FUNCTIONS that is used throughout the script.

# Start by create a status file to keep track of progress.
$ChkFile = "C:\Progress.txt"
$FileExists = Test-Path $ChkFile
If ($FileExists -eq $True)
{
    # Do nothing
}
else
{
    $ProgressPath = "C:\Progress.txt"
    New-Item -ItemType "file" -Path $ProgressPath
    Set-Content $ProgressPath -Value 0
}

Function replicate
{
    # Downloads the Radius configuration file from Github
    $Replicate = Invoke-WebRequest https://raw.githubusercontent.com/Twikki/Powershell_Scripts/master/Cisco_Radius_Export.xml
}

# Step 1
function RenameServer 
{
    Write-Host 'Hey there, first we need to rename this server before installing Active Directory Services. :)' -ForegroundColor Green
    $ServerName = Read-Host 'Please enter a name for this machine'
    Set-Content $ProgressPath -Value 1
    Rename-Computer -NewName $ServerName -Restart
}


function InstallAD 
{

    
$ServerIP = Read-Host 'Please enter your servers static IP'
$ServerMask = Read-Host 'Please enter the network subnet mask in prefix. like 24 for /24'
$ServerGateway = Read-Host 'Please enter your servers default gateway'
$ServerPrimaryDNS = Read-Host 'Please enter your primary DNS'
$ServerSecondaryDNS = Read-Host 'Please enter your secondary DNS'


# Finds all the network interfaces on this machine
Get-NetAdapter -Name "*"

$Interfaceifindex = Read-Host 'Please enter the Network interface Ifindex number you wish to configure'
Set-NetIPAddress -InterfaceIndex $Interfaceifindex

# Sets the server's ip address, subnetmask and Gateway
New-NetIPAddress -InterfaceIndex $Interfaceifindex -IPAddress $ServerIP -PrefixLength $ServerMask -DefaultGateway $ServerGateway

# Sets the server's DNS 
Set-DnsClientServerAddress -InterfaceIndex $Interfaceifindex -ServerAddresses ($ServerPrimaryDNS,$ServerSecondaryDNS)

Write-Host 'Static ip and DNS has been set. Starting installation of AD' -ForegroundColor Green

# Installs the AD Domain services
Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools

# Imports the modules needed
Import-Module ADDSDeployment

Write-Host 'AD Modules has been installed and Imported. We need a few more details.' -ForegroundColor Green

# Values used for below installation
#$Domainandforestmode = Read-Host 'Please enter a Domain mode. Accepted values are: Win2008, Win2008R2, Win2012, Win2012R2, Win2016'
$Domainname = Read-Host 'Please enter a Domain name. Like mydomain.com'
$Domainnetbiosname = Read-Host 'Please enter a Net bios name'

# Installs the forest with parameters
Install-ADDSForest
 -CreateDnsDelegation:$false `
 -DatabasePath "C:\Windows\NTDS" `
 -DomainMode "WinTreshold" `
 -DomainName $DomainName `
 -DomainNetbiosName $DomainNetbiosName `
 -ForestMode "WinTreshold" `
 -InstallDns:$true `
 -LogPath "C:\Windows\NTDS" `
 -NoRebootOnCompletion:$false `
 -SysvolPath "C:\Windows\SYSVOL" `
 -Force:$true

}







# Reads the file for status
# This is the logic used to control the installation status of the server.
$Status = Get-Content C:\InstallationStatus.txt -First 1

If ($Status -eq 0) 
{
    # Renames the server
    RenameServer
}
elseif ($Status -eq 1)
{
    # Begins to install Active Directory Services
    InstallAD
}
elseif ($Status -eq 2)
{

}