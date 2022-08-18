# mDNS_Discovery

## Multicast DNS (mDNS) Overview

> Starting with Windows 10 1703, Microsoft has included native support for multicast DNS, or mDNS. The protocol was developed by Apple, via RFC 6762 and RFC 6763, as a method to perform local network name and service discovery without the need for central name resolution, such as a DNS server, and without user interaction. Simply put, it is how Apple made AirPlay2-based services perform seamless setup via the Bonjour service.

## The Penetration Tester Dilemma

Penetration Testers get asked a lot: "Where are the hosts on my network that have mDNS enabled?" And sometimes we can't give the full answer because either we don't keep a log of the clients that have it, or there is an evergrowing number of hosts on a clients network. 

## Usage:

The following scripts will help answer those questions and help disable mDNS if need be. 

This command will initialze the scripts.
```
Import-Module Discover_mDNS.ps1 
```
This command will get the current status of mDNS (port 5353) on a file of servers(newline separated).
```
Get-MDNS -File .\Servers.txt
```
This command will get the current status of mDNS (port 5353) on a singular server.
```
Get-MDNS -Server 'SampleServer'
```
Sets the registry key for mDNS.
```
Set-MDNS
```

## Current Problems

- Chromium browsers, i.e. Edge and Chrome, cannot turn off mDNS as seen below.

![Chrome MDNS](https://github.com/stevesec/mDNS_Discovery/blob/main/Chrome_mDNS.PNG)

## References

- [mDNS - The informal informer | f20 - Vulnerable VMs](https://f20.be/blog/mdns)
- [mDNS in the Enterprise](https://techcommunity.microsoft.com/t5/networking-blog/mdns-in-the-enterprise/ba-p/3275777)
- [Chromium flags not responding. mDNS cannot be shut off](https://bugs.chromium.org/p/chromium/issues/detail?id=859359)


