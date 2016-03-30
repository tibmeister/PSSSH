PSSSH
=====
This is a PowerShell library and module to implement an SSH/SCP/SFTP client usable from PowerShell. This uses the Renci.SSHClient library (http://sshnet.codeplex.com/),
and the Ionic.Zlib library (https://github.com/jstedfast/Ionic.Zlib). I have to give credit to the POSH-SSH project (https://github.com/darkoperator/Posh-SSH) 
for insperation and the ability to learn how to create PowerShell snapins using C#.

PSSSH is licensed under the Fair Source 50 license; if you are a small company, non-commercial user, or only have less than 50 people using this library then you are free to
 use, modify, and distribute the code within the limits of the license.  If you have more than 50 uses of this library please contact me for licensing information. 

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

Usage
=====
Just like any PowerShell module or commandlet, using 
```powershell
Get-Help {Commandlet}
```
will show the in-line documentation.  You can also run 
```powershell
Get-Command -Module PSSSH
```
to list all the command the module provides.
