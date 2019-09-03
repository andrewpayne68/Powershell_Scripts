# Enables NTP server on Windows server, allowing other devices to query time from this server.

Set-Location HKLM:\SYSTEM\CurrentControlSet\services\W32Time\TimeProviders\NtpServer
Set-ItemProperty . Enabled "1"


w32tm /config /manualpeerlist:0.dk.pool.ntp.org,1.dk.pool.ntp.org /syncfromflags:MANUAL /reliable:yes /update


# Set's the NTP Server to Peers
Set-Location HKLM:\SYSTEM\CurrentControlSet\services\W32Time\Parameters
Set-ItemProperty . NtpServer "Peers"

# Set's the NTP Server to Peers
Set-Location HKLM:\SYSTEM\CurrentControlSet\services\W32Time\Parameters
Set-ItemProperty . Type "NTP"

# Set's the NTP Server to Peers
Set-Location HKLM:\SYSTEM\CurrentControlSet\services\W32Time\Config
Set-ItemProperty . AnnounceFlags "5"

# Set's the NTP Server to Peers
Set-Location HKLM:\SYSTEM\CurrentControlSet\services\W32Time\TimeProviders\NtpClient
Set-ItemProperty . SpecialPollInterval "3600"

Stop-Service w32time
Start-Service w32time