@{
	# Script module or binary module file associated with this manifest.
	#RootModule = ''

	# Version number of this module.
	ModuleVersion = '1.1'

	# ID used to uniquely identify this module
	GUID = '01A7AC22-3400-4726-917C-C2FA56DA018E'

	# Author of this module
	Author = 'TCS'

	# Company or vendor of this module
	CompanyName = 'www.tiberiansun.us'

	# Copyright statement for this module
	Copyright = '(c) 2014 TCS. All rights reserved.'

	# Description of the functionality provided by this module
	Description = 'Provide SSH functionality into PowerShell.'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '2.0'

	# Name of the Windows PowerShell host required by this module
	# PowerShellHostName = ''

	# Minimum version of the Windows PowerShell host required by this module
	# PowerShellHostVersion = ''

	# Minimum version of the .NET Framework required by this module
	DotNetFrameworkVersion = '3.5'

	# Minimum version of the common language runtime (CLR) required by this module
	#CLRVersion = '4.0'

	# Processor architecture (None, X86, Amd64) required by this module
	# ProcessorArchitecture = ''

	# Modules that must be imported into the global environment prior to importing this module
	# RequiredModules = @()

	# Assemblies that must be loaded prior to importing this module
	RequiredAssemblies = @('Renci.SshNet.dll')

	# Script files (.ps1) that are run in the caller's environment prior to importing this module.
	# ScriptsToProcess = @()

	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('')

	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess = @('Format\SSHSession.Format.ps1xml','Format\SFTPSession.Format.ps1xml','Format\Renci.SshNet.SshCommand.Format.ps1xml','Format\Renci.SshNet.Sftp.SftpFile.Format.ps1xml')

	# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
	NestedModules = @('PSSSH.dll','PSSSH.psm1')

	# Functions to export from this module
	FunctionsToExport = '*'

	# Cmdlets to export from this module
	CmdletsToExport = '*'

	# Variables to export from this module
	VariablesToExport = '*'

	# Aliases to export from this module
	AliasesToExport = '*'

	# List of all modules packaged with this module.
	# ModuleList = @()

	# List of all files packaged with this module
	FileList = @('PSSSH.psm1','PSSSH.dll','Renci.SshNet.dll')

	# Private data to pass to the module specified in RootModule/ModuleToProcess
	# PrivateData = ''

	# HelpInfo URI of this module
	# HelpInfoURI = ''

	# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
	# DefaultCommandPrefix = ''
}