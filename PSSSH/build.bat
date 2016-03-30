rmdir PSSSH\ /q /s

%windir%\Microsoft.NET\Framework\v3.5\csc.exe /t:library /out:PSSSH.dll /o /nostdlib /noconfig /r:C:\Windows\assembly\GAC_MSIL\System.Management.Automation\1.0.0.0__31bf3856ad364e35\System.Management.Automation.dll /r:.\Renci.SshNet.dll /r:.\Ionic.Zlib.dll /r:C:\windows\assembly\GAC_MSIL\System.Xml.Linq\3.5.0.0__b77a5c561934e089\System.Xml.Linq.dll /r:C:\windows\assembly\GAC_MSIL\System.Data.DataSetExtensions\3.5.0.0__b77a5c561934e089\System.Data.DataSetExtensions.dll /r:C:\windows\assembly\GAC_MSIL\System.Xml\2.0.0.0__b77a5c561934e089\System.Xml.dll /r:C:\windows\assembly\GAC_MSIL\System\2.0.0.0__b77a5c561934e089\System.dll /r:C:\windows\assembly\GAC_MSIL\System.Core\3.5.0.0__b77a5c561934e089\System.Core.dll /r:C:\windows\assembly\GAC_MSIL\System.Management\2.0.0.0__b03f5f7f11d50a3a\System.Management.dll /r:C:\windows\Microsoft.NET\Framework\v2.0.50727\mscorlib.dll *.cs Properties\AssemblyInfo.cs

mkdir PSSSH
move PSSSH.dll PSSSH\
copy Renci.SshNet.dll PSSSH\
copy Ionic.Zlib.dll PSSSH\
copy PSSSH.psm1 PSSSH\
copy PSSSH.psd1 PSSSH\
mkdir PSSSH\Format

copy Format PSSSH\Format\