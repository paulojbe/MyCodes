# ArcGISAdminForNonAdmins10X.ps1
#
# Script to allow users without administrator privileges change
# ArcGIS Desktop 10.X license type, license server and authorize
# single-use licenses using ArcGIS Administrator
#
# Licensed under MIT License

# Copyright (c) 2017 Paulo Estrela - paulojbe@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Written by Paulo Estrela - paulojbe@gmail.com
# 27/06/2017
#

$licenseserver = "@arcgis-desktop"

$classpath = "HKLM:\SOFTWARE\Classes\Wow6432Node\CLSID\{E6BDAA76-4D35-11D0-98BE-00805F7CED21}"
$licensepathwc = "HKLM:\SOFTWARE\Wow6432Node\ESRI\License10.*"

If ($(Test-Path $classpath) -and $(Test-Path $licensepathwc)) {

  $usersgroup = New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-545') # BUILTIN\Users group SID
  Write-Host "Setting group's permission: $($usersgroup.Translate([System.Security.Principal.NTAccount]))"

  $acl = Get-ACL -Path $classpath
  $rule = New-Object System.Security.AccessControl.RegistryAccessRule($usersgroup,"FullControl","Allow")
  $acl.SetAccessRule($rule)
  $acl | Set-ACL -Path $classpath
  Write-Host "Setting ArcGIS License server to: $licenseserver"
  
  ForEach ($licensepath in Get-ChildItem -Path $licensepathwc) {
  
    New-ItemProperty -Path Registry::$licensepath -Name "LICENSE_SERVER" -Value $licenseserver -Force | Out-Null

    $acl = Get-ACL -Path Registry::$licensepath
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule($usergroup,"FullControl","Allow")
    $acl.SetAccessRule($rule)
    $acl | Set-ACL -Path Registry::$licensepath    
  } 
}
Else {
  Write-Host "ERROR: ArcGIS Desktop 10.X does not seems to be installed on this machine. Registry keys does not exists!"
}