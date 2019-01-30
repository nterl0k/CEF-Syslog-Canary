# CEF Syslog Canary
A set of VBA scripts, AutoIT, and Powershell code for Blue Team usage.

These artifacts are intended to be used as a way to signal on adversary access to your network. The basic thought was to have some documents and/or an executable that when run would call home to a SIEM(or other logging platform) via a CEF syslog burst. Each of the artifacts here have been crafted with that thought in mind.

## Forward/A word on Common Event Format (CEF)

These artifacts were all crafted to use CEF as the main means of transmitting information back to a monitoring solution. As such any additional function or data that is needed can be added using a standard CEF variable keypair value method. The best place to reference CEF syntax and usage is through official documentation

[HPE/Microfocus CEF Guidance](https://community.softwaregrp.com/t5/ArcSight-Connectors/ArcSight-Common-Event-Format-CEF-Implementation-Standard/ta-p/1645557)

## Global Options

Any of these objects require modification prior to usage in your environment. I've tried to keep the variable names consistent where possible. The most important variables to set will be "SyslogTgt" and "SyslogPrt", the artifacts will not communicate with your syslog server otherwise. The of the 6 additional variables, while not critical will allow you to enhance/tailor the CEF syslog header to your environment. 

These variable will either in the advanced document properties or inside the AutoIT code (prior to compiling):
 
-	SyslogTgt: IP or FQDN/Hostname of your syslog/CEF receiver 
-	SyslogPrt: Port of your syslog/CEF receiver

-	EventMsg: The Message field (recommend leaving alone)
-	EventName: The Event Name (recommend leaving alone)
-	EventID: The Event ID  (recommend leaving alone)
-	DeviceVen: Recommend changing to your org/project name
-	DeviceProd: Recommend change to something recognizable like “Canary Feed”
-	Priority: Adjust as needed 1-10

## Office Documents

  The office documents are provided in a vanilla state and will need to be slightly modified to fit your environment. Both documents have form/fields that "unhide" when the canary macro runs to display either random username/passwords or a fake set of executive employee + salary ranges. 
  
Office document VBA has the following quality and manual/hand coded obfuscation techniques:
- Embedded base64 encoded PowerShell function for sending information via PowerShell.
  - Gets dumped to User %temp% folder and deleted upon document exit
- Local file is run which calls back to the indicated syslog target/port 
  - Works with pure IP or DNS
- VBA code splatted and suspect functions specifically renamed/stubbed.
- Uses WMI calls to avoid using cmd/PowerShell directly from Office app.
- Word XML document inner contents: 
  - "VBAProject.bin" renamed to "obfuproject.txt"
  - [Content_Types].xml - reference to "bin" swapped to "txt"
  - document.xml.rels - reference to "VBAProject.bin" swapped with "obfuproject.txt".  
    - Above 3 are basic vba obfuscation inside the document to fool manual analysis.
  - "vbaProject.bin.rels" renamed to "obfuproject.txt.rels".
    - This maintains macro function references.      
- Converted to legacy format XML (2003-2007), then renamed to ".doc".
  - This bypasses email filtering for "docm/macro" type documents
  
  ![Image of Advanced Properties](https://github.com/nterl0k/CEF-Syslog-Canar/adv_properties.png)

## AutoIT Code

This code can be compiled by any recent version of AutoIT. The resultant exe is meant to emulate a "home grown" program that allows for a single use local admin account. The code requires the inclusion of 2 UDF which can be found at the following links

- https://www.autoitscript.com/forum/topic/184817-syslogsend-udf-send-messages-to-a-syslog-server/
- https://www.autoitscript.com/forum/topic/74118-local-account-udf/

These UDFs will need to be placed in the "include" folder in the AutoIT installation.

## Credits
Inspiration/stripped down PowerShell function to send syslog
- https://github.com/poshsecurity/Posh-SYSLOG


AutoIT forum UDF authors for the Syslog and Local Account functions used
- https://www.autoitscript.com/forum/topic/184817-syslogsend-udf-send-messages-to-a-syslog-server/
- https://www.autoitscript.com/forum/topic/74118-local-account-udf/

