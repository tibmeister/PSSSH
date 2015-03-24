PSSSH
=====
This is a PowerShell library and module to implement an SSH/SCP/SFTP client usable from PowerShell. This uses the Renci.SSHClient library (http://sshnet.codeplex.com/),
and the Ionic.Zlib library (https://github.com/jstedfast/Ionic.Zlib). I have to give credit to the POSH-SSH project (https://github.com/darkoperator/Posh-SSH) 
for insperation and the ability to learn how to create PowerShell snapins using C#.

Requirements
=====
* .NET Framework 3.5
* Powershell v2+

Installation
=====
Switch to the PSSSH directory and execute 
```bash
build.bat
```

This will build the assemblies without the need for *Visual Studio*

To install this module, place it either in the **System PowerShell Modules** directory, or in your **User PowerShell Modules** directory.  Then, simply run 
```powershell
Import-Module PSSSH
```
