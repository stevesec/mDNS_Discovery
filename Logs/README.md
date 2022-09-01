# Logging mDNS

## Enable GPO

Domain Policy > Computer Configuration > Policies > Windows Settings > Security Settings > Advanced Audit Policy Configuration > Audit Policies > Object Access > "Audit Filtering Platform Connection" & "Audit Filtering Platform Packet Drop"

## Windows Defender Firewall

Inbound & Outbound Rules:
- Protocol and Ports
- UDP: 5353
- Action: Depending on threat model ("Allow the connection" or "Block the connection")
- Profile: All
- Name: Block (or Detect) mDNS
- Description: Detect or Block mDNS

1. Right-click on Windows Defender Firewall with Advanced Security
2. Under "(Domain/Private/Public) Profile", click Customize
3. "Log dropped packets" - "Yes"
4. "Log successful connections" - "Yes"

## Event Viewer Logs

### For Detect

Event ID: 5157 "Filtering Platform Connection"
Network Information:
- Direction: Inbound
- Source Address: <>
- Source Port: <>
- Destination Address: <>
- Destination Port: 5353

Event ID: 5152 "Filtering Platform Packet Drop"
Network Information:
- Direction: Inbound
- Source Address: <>
- Source Port: 5353
- Destination Address: <>
- Destination Port: 5353

## Task Scheduler

<TBA>
