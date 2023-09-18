#bu commentteki komut network adapter ekler
# Add-VMNetworkAdapter -ManagementOS -Name "VMWARE_VLANID" -SwitchName "confman" -Passthru | Set-VMNetworkAdapterVlan -Access -VlanId 40


###RUN WITH ADMINISTRATOR PRIVILEGES
param([switch]$Elevated)
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

###PENCERE BOYUTU
# $pshost = get-host
# $pswindow = $pshost.ui.rawui
# $newsize = $pswindow.windowsize
# $newsize.height = 20
# $newsize.width = 40
# $pswindow.windowsize = $newsize
$pswindow.windowtitle = "VMWare VLAN Changer"
[console]::WindowWidth=40; 
[console]::WindowHeight=20; 
[console]::BufferWidth=[console]::WindowWidth



clear
write-host "`n"
$vlanid = Read-Host ' VLAN ID GIR'
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "VMWARE_VLAN" -Access -VlanId $vlanid
Disable-NetAdapter -Name "VLAN_VMWARE" -Confirm:$false
Enable-NetAdapter -Name "VLAN_VMWARE" -Confirm:$false
write-host "`n"
$ip = (Get-NetIPAddress -AddressFamily IPV4 -ifAlias "VLAN_VMWARE").IPAddress
write-host "IP Adresi: $ip" -ForegroundColor Green
write-host "`n"
Start-Sleep -Seconds 3.5

#IP bilgisini ağ adaptörünün tanımına ekle
$registryPath = "HKLM:\SYSTEM\ControlSet001\Enum\ROOT\VMS_MP\0002"
$Name = "FriendlyName"
Set-ItemProperty -Path $registryPath -Name $name -Value $ip -Type "String" -Force
Stop-Process -Id $PID
