/*
 This file is part of PSSSH.

    PSSSH is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    PSSSH is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with PSSSH.  If not, see <http://www.gnu.org/licenses/>.
 */
using Renci.SshNet;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;
using Microsoft.Win32;

namespace PSSSH
{
    //This class will manage the RSA Keys for Trusted SSH Hosts in the Registry
    public class TrustedKeyManagement
    {
        public Dictionary<string,string> GetKeys()
        {
            var hostKeys = new Dictionary<string, string>();
            var sshHostKey = Registry.CurrentUser.OpenSubKey(@"Software\PSSSH", true);

            //If the key exists, then get the host values, otherwise create the key
            if(sshHostKey != null)
            {
                string[] hosts = sshHostKey.GetValueNames();
                foreach(var host in hosts)
                {
                    var hostKey = sshHostKey.GetValue(host).ToString();
                    hostKeys.Add(host, hostKey);
                }
            }
            else
            {
                using (var sshSoftwareKey = Registry.CurrentUser.OpenSubKey(@"Software",true))
                {
                    if(sshSoftwareKey != null)
                    {
                        sshSoftwareKey.CreateSubKey("PSSSH");
                    }
                }
            }
            return hostKeys;
        }
        
        public bool SetKey(string host, string fingerprint)
        {
            var sshHostKey = Registry.CurrentUser.OpenSubKey(@"Software\PSSSH", true);

            //Check to see if the key exists, and if it does, set it's value
            if(sshHostKey != null)
            {
                sshHostKey.SetValue(host, fingerprint);
                return true;
            }

            //Otherwise, let's create the key and set the value
            var sshSoftwareKey = Registry.CurrentUser.OpenSubKey(@"Software", true);

            if(sshSoftwareKey != null)
            {
                sshSoftwareKey.CreateSubKey("PSSSH");
                sshSoftwareKey.SetValue(host, fingerprint);
            }
            
            return true;
        }
    }

    //This class will help with some custom PowerShell objects we need
    public class SSHModuleHelper
    {
        //Use a hashtable to create a custom object
        public static PSObject CreateCustom(Hashtable properties)
        {
            var objPS = new PSObject();

            foreach(DictionaryEntry noteProperty in properties)
            {
                objPS.Properties.Add(new PSNoteProperty(noteProperty.Key.ToString(), noteProperty.Value));
            }

            return objPS;
        }

        public static SSHSession AddToSSHSessionCollection(SshClient sshClient, SessionState psSession)
        {
            var objSession = new SSHSession();
            var sshSessions = new List<SSHSession>();
            Int32 Index = 0;

            //Look at the global session variable for any existing connections
            var varSession = psSession.PSVariable.GetValue("Global:SSHSessions") as List<SSHSession>;

            //If sessions exists, setup the indexes correctly
            if(varSession != null)
            {
                sshSessions.AddRange(varSession);
                Index = sshSessions.Count;
            }

            objSession.Index = Index;
            objSession.Host = sshClient.ConnectionInfo.Host;
            objSession.SSHSess = sshClient;
            sshSessions.Add(objSession);

            //Set the global session variable for the sessions
            psSession.PSVariable.Set((new PSVariable("Global:SSHSessions", sshSessions, ScopedItemOptions.AllScope)));

            return objSession;
        }

        public static SFTPSession AddToSFTPSessionCollection(SftpClient sftpclient, SessionState pssession)
        {
            //Set initial variables
            var objSession = new SFTPSession();
            var sftpSessions = new List<SFTPSession>();
            Int32 Index = 0;

            // Retrive existing sessions from the globla variable.
            var sessionvar = pssession.PSVariable.GetValue("Global:SFTPSessions") as List<SFTPSession>;

            // If sessions exist  we set the proper index number for it.
            if (sessionvar != null)
            {
                sftpSessions.AddRange(sessionvar);
                Index = sftpSessions.Count;
            }

            // Create the object that will be saved
            objSession.Index = Index;
            objSession.Host = sftpclient.ConnectionInfo.Host;
            objSession.SFTPSess = sftpclient;
            sftpSessions.Add(objSession);

            // Set the Global Variable for the sessions.
            pssession.PSVariable.Set((new PSVariable("Global:SFTPSessions", sftpSessions, ScopedItemOptions.AllScope)));
            return objSession;
        }
    }
}
