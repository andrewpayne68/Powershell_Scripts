[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Installs the Network Policy Server ( Radius Server )
Install-WindowsFeature NPAS -IncludeManagementTools


mkdir c:\tempdir

# Downloads the Radius configuration file from Github
$Script = Invoke-WebRequest https://raw.githubusercontent.com/Twikki/Powershell_Scripts/master/Cisco_Radius_Export.xml


# Creates the file
Set-Content -Path 'C:\tempdir\Cisco_Radius_Export.xml' -Value $script


# Imports the configuration
Import-NpsConfiguration -Path "C:\Cisco_Radius_Export.xml"

Remove-Item c:\Tempdir -Force -Recurse