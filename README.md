# CEF Syslog Canary
A set of VBA scripts, AutoIT, and Powershell code for Blue Team usage.

  These artifacts are intended to be used as a way to signal on adversay access to your network. The basic thought was to have some documents and/or an executable that when run would call home to a SIEM(or other logging platform) via a CEF syslog burst. Each of the artifacts here have been crafted with that thought in mind.
  
  The office documents are provided in a vanilla state and will need to be slightly modified to fit your environment. Both documents have form/fields that "unhide" when when the canary marco runs to display either random username/passwords or a fake set of executive employee + salary ranges. 
  
Office document VBA come with some basic manual/hand coded obfuscation techniques:

•	VBA code splatted and suspect functions specifically renamed/stubbed.
•	Uses WMI calls to avoid using cmd/PowerShell directly from Office app.
•	Word document inner contents: 
    o	"VBAProject.bin" renamed to "obfuproject.txt"
    o	[Content_Types].xml - reference to "bin" swapped to "txt"
    o	document.xml.rels - reference to "VBAProject.bin" swapped with "obfuproject.txt".  
         Above 3 are basic vba obfuscation inside the document to fool manual analysis.
    o	"vbaProject.bin.rels" renamed to "obfuproject.txt.rels".  
        	This maintains macro function references.
        
•	Converted to legacy format XML (2003-2007), then renamed to ".doc". 
    o	 This bypasses email filtering for "docm/macro" type documents


Both objects require modication of the following variables, either in the advanced document properties or inside the AutoIt code:
 
-	SyslogTgt: IP or FQDN/Hostname of your syslog/CEF receiver 
-	SyslogPrt: Port of your syslog/CEF receiver
-	EventMsg: The Message field (recommend leaving alone)
-	EventName: The Event Name (recommend leaving alone)
-	EventID: The Event ID  (recommend leaving alone)
-	DeviceVen: Recommend changing to your org/project name
-	DeviceProd: Recommend change to something recognizable like “Canary Feed”
-	Priority: Adjust as needed 1-10

