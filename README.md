# mDNS_Discovery

## Multicast DNS (mDNS) Overview

> Starting with Windows 10 1703, Microsoft has included native support for multicast DNS, or mDNS. The protocol was developed by Apple, via RFC 6762 and RFC 6763, as a method to perform local network name and service discovery without the need for central name resolution, such as a DNS server, and without user interaction. Simply put, it is how Apple made AirPlay2-based services perform seamless setup via the Bonjour service.

Penetration Testers get asked a lot: "Where are the hosts on my network that have mDNS enabled?" And sometimes we can't give the full answer because either we don't keep a log of the clients that have it, or there is an evergrowing number of hosts on a clients network. 

The following scripts will help answer those questions and help disable mDNS if need be. 

```
Usage: 

C:\PS> Import-Module Discover_mDNS.ps1 

# File Newline Separated Containing List of Workstations/Servers on the Domain
C:\PS> Get-MDNS -File .\Servers.txt

# Singular Server Support
C:\PS> Get-MDNS -Server 'SampleServer'
```




