<#
	.Synopsis
	   Get current SSH Session that are available for interaction.
	.DESCRIPTION
	   Get current SSH Session that are available for interaction.
	.EXAMPLE
	    Get-SSHSession
	.PARAMETER Index
	    Index number of the session to retrive.
#>
function Get-SSHSession 
{
    [CmdletBinding()]
    param
	( 
        [Parameter(Mandatory=$false)]
        [Int32]$Index
    )

    if ($Index)
    {
        foreach($i in $Index)
        {
            foreach($session in $SSHSessions)
            {
                if ($session.Index -eq $i)
                {
                    $session
                }
            }
        }
    }
    else
    {
        # Can not reference SSHSessions directly so as to be able
        # to remove the sessions when Remove-SSHSession is used
        $return_sessions = @()
        foreach($s in $SSHSessions){$return_sessions += $s}
        $return_sessions
    }
}

<#
	.Synopsis
	   Removes and Closes an existing SSH Session.
	.DESCRIPTION
	    Removes and Closes an existing SSH Session. The session can be a SSH Session object or they can be specified by Index.
	.EXAMPLE
	    Remove-SSHSession -Index 0
	.PARAMETER Index
	    Index number of the session to close and remove.
	.PARAMETER Session
	    SSH Session to close and remove.
#>
function Remove-SSHSession
{
    [CmdletBinding(DefaultParameterSetName='Index')]
    param
	(
        [Parameter(Mandatory=$true,
        ParameterSetName = 'byname',
        ValueFromPipelineByPropertyName=$true)]
        [Int32[]]$Index,

        [Parameter(Mandatory=$false,
        ParameterSetName = 'Session',
        ValueFromPipeline=$true)]
        [Alias('Name')]
        [PSSSH.SSHSession[]]$SSHSession
    )
		
    if ($Index.Count -gt 0)
    {
        $sessions2remove = @()
        foreach($i in $Index)
        {
            Write-Verbose $i
            foreach($session in $Global:SSHSessions)
            {
                if ($session.Index -eq $i)
                {
                    $sessions2remove += $session
                }
            }
        }

        foreach($badsession in $sessions2remove)
        {
             Write-Verbose "Removing session $($badsession.index)"
             if ($badsession.session.IsConnected) 
             { 
                $badsession.session.Disconnect() 
             }
             $badsession.session.Dispose()
             $global:SSHSessions.Remove($badsession)
             Write-Verbose "Session $($badsession.index) Removed"
        }
    }

    if ($SSHSession.Count -gt 0)
    {
        $sessions2remove = @()
         foreach($i in $SSHSession)
        {
            foreach($ssh in $Global:SSHSessions)
            {
                if ($ssh -eq $i)
                {
                    $sessions2remove += $ssh
                }
            }
        }

        foreach($badsession in $sessions2remove)
        {
             Write-Verbose "Removing session $($badsession.index)"
             if ($badsession.session.IsConnected) 
             { 
                $badsession.session.Disconnect() 
             }
             $badsession.session.Dispose()
             $Global:SSHSessions.Remove($badsession)
             Write-Verbose "Session $($badsession.index) Removed"
        }
    }

}

<#
	.Synopsis
	   Executes a given command on a remote SSH host.
	.DESCRIPTION
	   Executes a given command on a remote SSH hosst given credentials to the host or using an existing SSH Session.
	.EXAMPLE
	    Invoke-SSHCommand -Command "uname -a" -Index 0,2,3
	.PARAMETER Command
	    Command to execute in remote host.
	.PARAMETER Index
	    Index number of t session(s) to execute command against.
	.PARAMETER Session
	    SSH Session to execute command against.
#>
function Invoke-SSHCommand
{
    [CmdletBinding(DefaultParameterSetName='Index')]
    param
	(
        [Parameter(Mandatory=$true)]
        [string]$Command,
        
        [Parameter(Mandatory=$true,
        ParameterSetName = 'Session',
        ValueFromPipeline=$true)]
        [Alias('Name')]
        [PSSSH.SSHSession[]]$SSHSession,

        [Parameter(Mandatory=$true,
        ParameterSetName = 'Index')]
        [int32[]]$Index = $null,

        # Ensures a connection is made by reconnecting before command.
        [Parameter(Mandatory=$false)]
        [switch]$EnsureConnection

    )
            
    if ($SSHSession)
    {
        foreach($s in $SSHSession)
        {
            if ($s.SSHSess.IsConnected)
            {
                if ($EnsureConnection)
                {
                    $s.SSHSess.Connect()
                }
                $result = $S.SSHSess.RunCommand($Command)
            }
            else
            {
                $s.session.connect()
                $result = $s.SSHSess.RunCommand($Command)
            }
            if ($result)
                {
                    $ResultObj = New-Object psobject -Property @{
                        Output = $result.Result
                        ExitStatus = $result.ExitStatus 
                        Host = $s.Host
                        Error=$result.Error
                    }

                    $ResultObj.pstypenames.insert(0,'Renci.SshNet.SshCommand')
                    $ResultObj
                }
        }
    }
    elseif ($Index.Length -gt 0)
    {
        foreach($i in $Index)
        {
            [PSSSH.SSHSession]$sess = Get-SSHSession -Index $i
            
            Write-Verbose "Running command against $($sess.Host)"
            if($sess.SSHSess.IsConnected)
            {
                if($EnsureConnection)
                {
                    $sess.SSHSess.Connect()
                }

                $result = $sess.SSHSess.RunCommand($Command)
            }
            else
            {
                $sess.SSHSess.Connect()
                $result = $sess.SSHSess.RunCommand($Command)
            }

            if($result)
            {
                $ResultObj = New-Object PSObject -Property @{
                    Output = $result.ResulT
                    ExitStatus = $result.ExitStatus
                    Host = $sess.Host
                }
                $ResultObj.psTypeNames.insert(0,'Renci.SshNet.SshCommand')
                
                $ResultObj
            }
        }
    }
}

<#
	.Synopsis
		List Host and Fingerprint pairs that are trusted.
	.DESCRIPTION
		List Host and Fingerprint pairs that are trusted.
	.EXAMPLE
		Get-SSHTrustedHosts
#>
 function Get-SSHTrustedHosts
 {
	$pssshkey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Software\PSSSH', $true)

	$hostnames = $PSSSHkey.GetValueNames()
	$TrustedHosts = @()
	foreach($h in $hostnames)
	{
	    $TrustedHost = @{
	        SSHHost        = $h
	        Fingerprint = $pssshkey.GetValue($h)
	    }
	    $TrustedHosts += New-Object -TypeName psobject -Property $TrustedHost
	}
	$TrustedHosts
 }

 <#
	.Synopsis
		Removes a given SSH Host from the list of trusted hosts.
	.DESCRIPTION
		Removes a given SSH Host from the list of trusted hosts.
	.EXAMPLE
		Remove-SSHTrustedHost -SSHHost 192.168.10.20 -Verbose
 #>
 function Remove-SSHTrustedHost
 {
     [CmdletBinding(DefaultParameterSetName='Index')]
     Param
     (
		[Parameter(Mandatory=$true,
		ValueFromPipelineByPropertyName=$true,
		Position=0)]
		$SSHHost
     )

    $softkey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Software')
    if ($softkey.GetSubKeyNames() -contains 'PSSSH' )
    {
        $PSSSHkey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Software\PSSSH', $true)
    }
    else
    {
        Write-warning 'PSSSH Registry key has not Present for this user.'
        return
    }
    Write-Verbose "Removing SSH Host $($SSHHost) from the list of trusted hosts."
    if ($PSSSHkey.GetValueNames() -contains $SSHHost)
    {
        $PSSSHkey.DeleteValue($SSHHost)
        Write-Verbose 'SSH Host has been removed.'
    }
    else
    {
        Write-Warning "SSH Hosts $($SSHHost) was not present in the list of trusted hosts." 
    }
 }

if (!(Test-Path variable:Global:SSHSessions ))
{
    $global:SSHSessions = New-Object System.Collections.ArrayList
}

if (!(Test-Path variable:Global:SFTPSessions ))
{
    $global:SFTPSessions = New-Object System.Collections.ArrayList
}

Export-ModuleMember -Function Get-SSHSession
Export-ModuleMember -Function Remove-SSHSession
Export-ModuleMember -Function Invoke-SSHCommand
Export-ModuleMember -Function Get-SSHTrustedHosts
Export-ModuleMember -Function Remove-SSHTrustedHost
