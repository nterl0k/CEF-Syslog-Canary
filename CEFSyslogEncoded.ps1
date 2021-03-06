
Function CEFSyslogSender ()
{

Param
(
[String]$Destination = $(throw "ERROR: SYSLOG Host Required..."),
[Int32]$Port = 514
)

Try{
    $Con = Test-Connection -ComputerName $Destination -Count 1
    If($con.IPV4Address){
        $Destination = $con.IPV4Address.IPAddressToString
    }
    Else{
        $Destination = $con.Address
    }
}

Catch{
"ERROR: SYSLOG Host Required..."
}

$ObjSyslogSender = New-Object PsObject
$ObjSyslogSender.PsObject.TypeNames.Insert(0, "SyslogSender")
$ObjSyslogSender | Add-Member -MemberType NoteProperty -Name UDPClient -Value $(New-Object System.Net.Sockets.UdpClient)
$ObjSyslogSender.UDPClient.Connect($Destination, $Port)
$ObjSyslogSender | Add-Member -MemberType ScriptMethod -Name Send -Value {

Param
(
[String]$CEFVendor = "Generic Vendor",
[String]$CEFProduct = "Generic Product",
[String]$CEFVersion = "1.2.3.4",
[String]$CEFDvcID = "Device Event ID",
[String]$CEFName = "Generic Event Name",
[String]$CEFSeverity = "1",
[String]$Data = $(throw "Error SyslogSender: No data to send!")
)

[String]$CEFHeader = "CEF:0"
[String]$Timestamp = $(get-date -UFormat %b" "%d" "%T)
[String]$Source = "CEF Syslog Sender"
[String]$Hostname = $env:COMPUTERNAME

$PRI = 8
$Message = "<$PRI>$Timestamp : $CEFHeader|$CEFVendor|$CEFProduct|$CEFVersion|$CEFDvcID|$CEFName|$CEFSeverity|$Data"
$Message = $([System.Text.Encoding]::ASCII).GetBytes($message)

if ($Message.Length -gt 1024)
{
$Message = $Message.Substring(0, 1024)
}

$this.UDPClient.Send($Message, $Message.Length) | Out-Null

}
$ObjSyslogSender

}

