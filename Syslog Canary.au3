#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=.\download.ico
#AutoIt3Wrapper_Outfile=One-Time Admin Account.exe
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Field=ProductName|One-Time Admin Account
#AutoIt3Wrapper_Res_ProductVersion=12.1.8
#AutoIt3Wrapper_Res_Field=OriginalFileName|Cyberarch_1t_admin.exe
#AutoIt3Wrapper_Res_Description=This tool is used to generate a temporary local administrator account for software installs.
#AutoIt3Wrapper_Res_Comment=One-Time Local Admin Generator
#AutoIt3Wrapper_Res_Fileversion=1.0.0.16
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Cybersecurity Force 2018
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Canary objects by Steven Dick 2019, free to use just give me credit or feedback if useful.
; https://github.com/nterl0k/CEF-Syslog-Canary/
; See the following guidance on including User Defined Functions (UDFs) https://www.autoitscript.com/wiki/User_Defined_Functions

; This UDF allows sending of a syslog UDP packet, must be included.
; https://www.autoitscript.com/forum/topic/184817-syslogsend-udf-send-messages-to-a-syslog-server/
#include "SyslogSend_UDF.au3"
; This allows for local account enumeration
; https://www.autoitscript.com/forum/topic/74118-local-account-udf/
#include "LocalAccount.au3"
#include <Array.au3>
#include <Date.au3>
#include <Inet.au3>


; Set your global CEF / Syslog variables ####CHANGE ME####

Global $SyslogTgt = "YOUR_SERVER_HERE" 		; Your syslog reciever server or target IP
Global $SyslogPrt = 514 		; Your syslog reciever port

; These variables control the CEF header, configure as needed. ####CHANGE ME####

Global $EventMsg = "This is a warning for canary executable file usage"	; The Message field (recommend leaving alone)
Global $EventName =	"Canary File Execution"								; The Event Name (recommend leaving alone)
Global $EventID	= "Canary_Exe"											; The Event ID  (recommend leaving alone)
Global $DeviceVen =	"Your_Company"										; Recommend changing to your org/project name
Global $DeviceProd = "Canary_File"										; Recommend change to something recognizable like “Canary Feed”
Global $Priority = "6"													; Adjust as needed 1-10


;Get DNS Value for the FQDN of the Syslog Server
	TCPStartup()
	$SyslogDNS = TCPNameToIP($SyslogTgt)
	TCPShutdown()

;Grab Running Processes and dump to a variable
$PL = ""
	$PL = ProcessList()
	$list = 'Total Processes: ' & $PL[0][0] & @CRLF
	For $i = 1 To $PL[0][0]
		$list &= 'Process: ' & $PL[$i][0] & ' (' & $PL[$i][1] & ')' & @CR
		;$i = $i + 1
	Next

;Grab if was run as an admin
$RunAdmin = IsAdmin()

	If $RunAdmin = 1 Then
		$RunAdmin = "Yes"
		$RunPriv= "Administrator"
	Else
		$RunAdmin = "No"
		$RunPriv = "User"
	EndIf

;Grab the local admin users
Local $DOS_out, $alist

; Returns members of Administrator group (remove first 6 unwanted lines)
$iPID = Run(@ComSpec & ' /c NET LOCALGROUP Administrators | MORE /E +6', "", @SW_HIDE, 2)
		Do ; wait that dos has finished
			$DOS_out &= StdoutRead($iPID)
		Until @error

		; Parse members of administrators group from DOS output
		$admins = StringSplit(StringStripWS($DOS_out, 7), @CR, 2)
		_ArrayPop($admins); remove last unwanted line

	For $i = 0 To  _ArrayMaxIndex($admins)
		$alist &= $admins[$i] & @CR
	Next

;Generate a psuedo admin user and  random 15 character string, used for "Password" display

$account = ""
	Dim $aArray[50],$z = ""
		$aArray[0]="stonethwaites"
		$aArray[1]="expeditedssls"
		$aArray[2]="hillsboroughs"
		$aArray[3]="choakumchilds"
		$aArray[4]="contributions"
		$aArray[5]="newfoundlands"
		$aArray[6]="shirtsinbulks"
		$aArray[7]="manufacturers"
		$aArray[8]="tatshenshinis"
		$aArray[9]="professionals"
		$aArray[10]="lincolnshires"
		$aArray[11]="saskatchewans"
		$aArray[12]="independences"
		$aArray[13]="relationships"
		$aArray[14]="conversations"
		$aArray[15]="refrigerators"
		$aArray[16]="constructions"
		$aArray[17]="horsepastures"
		$aArray[18]="indianapoliss"
		$aArray[19]="kindergartens"
		$aArray[20]="melchisedechs"
		$aArray[21]="snollygosters"
		$aArray[22]="distributions"
		$aArray[23]="constructions"
		$aArray[24]="warwickshires"
		$aArray[25]="weatherboards"
		$aArray[26]="exterminators"
		$aArray[27]="sleightholmes"
		$aArray[28]="bilergrinders"
		$aArray[29]="lloydminsters"
		$aArray[30]="henhambridges"
		$aArray[31]="vinomadefieds"
		$aArray[32]="saskatchewans"
		$aArray[33]="satisfactions"
		$aArray[34]="organizations"
		$aArray[35]="malagrugrouss"
		$aArray[36]="companionways"
		$aArray[37]="attawapiskats"
		$aArray[38]="honeythunders"
		$aArray[39]="bedfordshires"
		$aArray[40]="chillingwoods"
		$aArray[41]="gainsboroughs"
		$aArray[42]="presentations"
		$aArray[43]="peterboroughs"
		$aArray[44]="disappointeds"
		$aArray[45]="pennsylvanias"
		$aArray[46]="quagswaggings"
		$aArray[47]="johannesburgs"
		$aArray[48]="championships"
		$aArray[49]="butterscotchs"

	$b=Random (0,49,1 )
	$c=Random (100,199,1 )
	$account = $aArray[$b]&$c

$pwd = ""
	Dim $aSpace[3]
	$digits = 15
	For $i = 1 To $digits
		$aSpace[0] = Chr(Random(65, 90, 1)) ;A-Z
		$aSpace[1] = Chr(Random(97, 122, 1)) ;a-z
		$aSpace[2] = Chr(Random(48, 57, 1)) ;0-9
		$pwd &= $aSpace[Random(0, 2, 1)]
	Next

;Get Network Information
Local $sPublicIP = _GetIP()


;Configure Syslog Message (CEF_
$SyslogMsg = "CEF:0|" & $DeviceVen & "|" & $DeviceProd & "|1.0|" & $EventID & "|" & $EventName & "|" & $Priority & "|" & _
						" msg="& $EventMsg & _
						" reason=The user " & @UserName & " launched a canary executable named [" & @ScriptName & "] on the device: " & @ComputerName & "." & _
						" shost=" & @ComputerName & _
						" suser=" & @UserName & _
						" sourceTranslatedAddress=" & @IPAddress1 & _
						" sproc=" & @ScriptName & _
						" spriv=" & $RunPriv & _
						" fname=" & @ScriptName & _
						" filePath=" & @ScriptDir & _
						" cs1Label=Current Procs cs1=" & $list & _
						" cs2Label=Run As Admin cs2=" & $RunAdmin & _
						" cs3Label=Admin User & Group(s) cs3="& $alist & _
						" cs4Label=Local IP(s) cs4="& @IPAddress1 & "," & @CR & @IPAddress2 & ","& @CR & @IPAddress3 & _
						" cs5Label=Public IP cs5=" & $sPublicIP & _
						" cs6Label=User Spoof cs6=" & $account


;Send syslog data to SIEM
	SyslogSend($SyslogMsg, $SyslogDNS, 3, 1, "CanaryClick", @ComputerName, $SyslogPrt,0)

;Fake User/Password
	MsgBox(0, "Temp admin credentials", "Your one-time admin login account is: " & $account  & @CR & "The password is: " & $pwd)




