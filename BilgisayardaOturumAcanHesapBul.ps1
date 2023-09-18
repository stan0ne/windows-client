cls
$select = "E"

do
{
$computer=read-host "`nBilgisayar adı / IP Girin" 
if(Test-Connection -ComputerName $computer -Quiet -Count 2 -Delay 1)
{
Get-CimInstance -ClassName Win32_computersystem -comp $computer | select Username,Caption,Manufacturer,Model | out-host
#Get-CimInstance -ClassName Win32_computersystem -comp $computer | select Username,Caption,Manufacturer,Model | out-host
} 
else { Write-Host "$computer makinesine ulaşılamıyor" -ForegroundColor Red | Out-Host }
$select = Read-Host "Başka bilgisayar sorgulama için E basın"
$select
}while ($select -eq "E")