function Get-MDNS {
<#
.SYNOPSIS

This script answers the question, "Where is Multicast DNS (mDNS) enabled on my domain?" It will gather the necessary information to allow you to determine which host is running mDNS.

Author: Steve Nelson (@SteveSec)
License: MIT
Required Dependencies: None
Optional Dependencies: None

.DESCRIPTION

This script attempts to find all hosts on the network that are running the Multicast DNS (mDNS) service. This must be run from an Administrative PowerShell window. 

.PARAMETER server

Singular server to use for checking


.PARAMETER File

Newline separated file that contains the resolved hostnames of hosts on the Active Directory domain.

.EXAMPLE

C:\PS> Get-MDNS -Server 'EXAMPLESERVER'

C:\PS> Get-MDNS -File .\List_of_servers.txt


#>
    
    Param(
        [Parameter()]
        [string]$Server,

        [Parameter()]
        [string]$File
    )
    if ($File) {   
        foreach ($line in Get-Content -Path $File) {
            try {
                $test = Resolve-DnsName -Name $line
                if ($test) {
                    Write-Host "[*] Server object $line exists in AD"
                    $mdns = (Invoke-Command -ComputerName $line -ScriptBlock { Get-NetUDPEndpoint | Select-Object -Property LocalAddress, LocalPort,@{name='ProcessName';expression={(Get-Process -Id $_.OwningProcess). Path}},CreationTime})
                    if ($mdns.LocalPort -eq "5353") {
                        Write-Output "Server object $line currently has mDNS enabled and is running on the following processes: " ($mdns | Where-Object -Property LocalPort -eq -Value "5353" | Format-Table) 
                        Write-Output $line | Out-File C:\Temp\Hosts_W_MDNS.txt -Append
                    }
                    else {
                        Write-Host "[*] Server object $line currently has mDNS disabled. "
                        Write-Output $line | Out-File C:\Temp\Hosts_No_MDNS.txt -Append
                    }
                }
            }
            catch [OperationTimeout] {
                Write-Host "[*] Server object $line does not exist in AD"
            }
        }
    }
    elseif ($Server) {
        try {
            $test = Resolve-DnsName -Name $Server
            if ($test) {
                Write-Host "Server object $Server exists in AD"
                $mdns = (Invoke-Command -ComputerName $Server -ScriptBlock { Get-NetUDPEndpoint | Select-Object -Property LocalAddress, LocalPort,@{name='ProcessName';expression={(Get-Process -Id $_.OwningProcess). Path}},CreationTime})
                if ($mdns.LocalPort -eq "5353") {
                    Write-Output "Server object $Server currently has mDNS enabled and is running on the following processes: " ($mdns | Where-Object -Property LocalPort -eq -Value "5353" | Format-Table) 
                    Write-Output $Server | Out-File C:\Temp\Hosts_W_MDNS.txt -Append
                }
                else {
                    Write-Host "Server object $Server currently has mDNS disabled. "
                    Write-Output $Server | Out-File C:\Temp\Hosts_No_MDNS.txt -Append
                }
            }
        }
        catch [OperationTimeout] {
            Write-Host "Server object $Server does not exist in AD"
        }
    } else {
        Write-Host "[*] Need argument."
    }
}


function Set-MDNS {
    Param(
        [Parameter()]
        [string]$file='C:\Temp\Hosts_W_MDNS.txt'
    )
    $ErrorActionPreference = "Continue"
    foreach ($line in Get-Content -Path $file){
        try {
            $regkey = (Invoke-Command -ComputerName $line -ScriptBlock { Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name "EnableMDNS" | Select-Object -ExpandProperty "EnableMDNS"})
            if ($regkey -eq 0) {
                Write-Host "mDNS is disabled on $line" | Out-File C:\Temp\mDNS_Results.txt -Append
            }
            elseif ($regkey -eq 1) {
                Write-Host "mDNS is enabled on $line. Disabling mDNS..."
                Start-Sleep -Seconds 5
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name "EnableMDNS" -Value 0 -Type DWord
                                    
            }
            else {
                Write-Host "Registry Key not set. Creating registry key..."
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name "EnableMDNS" -Value 0 -Type DWord
            } 
            
        }
        catch [System.Management.Automation.PSArgumentException]{
            Write-Host "Error"
                                 
        } finally {
            $Error.Clear()
        }
    }
    
}



