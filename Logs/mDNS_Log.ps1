$event = (Get-EventLog -LogName Security -Newest 1).Message 
$re = 'Network Information:[\s\S]+?Source Address:\s+(.*)\s+Source Port:\s+(.*)\s+Destination Address:\s+(.*)\s+Destination Port:\s+(.*)\s'
if ($event -match $re){
    $src_ip = $matches[1].Trim()
    $src_port = $matches[2].Trim()
    $dst_ip = $matches[3].Trim()
    $dst_port = $matches[4].Trim()
    if ($dst_port.Trim() -like "5353"){
        Add-Type -AssemblyName System.Windows.Forms 
        $global:balloon = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
        $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning 
        $balloon.BalloonTipText = "$src_ip on port $src_port attempted connection to $dst_ip on $dst_port"
        $balloon.BalloonTipTitle = "mDNS blocked on $src_ip" 
        $balloon.Visible = $true 
        $balloon.ShowBalloonTip(5000) 
    }
}