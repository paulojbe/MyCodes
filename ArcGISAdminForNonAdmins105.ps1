# ArcGISAdminForNonAdmins105.ps1
#
# Script to allow users without administrator privileges change
# ArcGIS Desktop 10.5 license type, license server and authorize
# single-use licenses.
#
# Written by Paulo Estrela - paulojbe@gmail.com
# 07/06/2017
#


$classpath = "HKLM:\SOFTWARE\Classes\Wow6432Node\CLSID\{E6BDAA76-4D35-11D0-98BE-00805F7CED21}"
$licensepath = "HKLM:\SOFTWARE\Wow6432Node\ESRI\License10.5"
$licenseserver = "@arcgis-desktop"
$usergroup = "BUILTIN\Usuários"
#$usergroup = "BUILTIN\Users"

Write-Host "Setting ArcGIS License server to: $licenseserver"

If (!(Test-Path $licensepath)) {
  New-Item -Path $licensepath -Name "LICENSE_SERVER" -Value $licenseserver -PropertyType String -Force | Out-Null
}
Else {
  New-ItemProperty -Path $licensepath -Name "LICENSE_SERVER" -Value $licenseserver -PropertyType String -Force | Out-Null
}


Write-Host "Setting permissions to group: $usergroup"

$acl = Get-ACL -Path $classpath
$rule = New-Object System.Security.AccessControl.RegistryAccessRule($usergroup,"FullControl","Allow")
$acl.SetAccessRule($rule)
$acl | Set-ACL -Path $classpath

$acl = Get-ACL -Path $licensepath
$rule = New-Object System.Security.AccessControl.RegistryAccessRule($usergroup,"FullControl","Allow")
$acl.SetAccessRule($rule)
$acl | Set-ACL -Path $licensepath