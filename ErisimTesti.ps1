clear
# reset the lists of hosts prior to looping
$OutageHosts = $Null
# specify the time you want email notifications resent for hosts that are down
$EmailTimeOut = 3600 # 5 dakika
# specify the time you want to cycle through your host lists.
$SleepTimeOut = 3600 # 5dakika
$SleepTimeOutDakika = $SleepTimeOut/60
# specify the maximum hosts that can be down before the script is aborted
$MaxOutageCount = 100 # varsayılan=48
# specify who gets notified
$notificationto = "Savaş <admin@savasboluk.com>"
#$notificationto2 = "savas2 <savas2@savasboluk.com>"
#$notificationcc = "Bilgi İşlem <bilgiislem@savasboluk.com>"
# specify where the notifications come from
$notificationfrom = "Sunucu/Cihaz Erişim Testi <erisim.testi@savasboluk.com>"
# specify the SMTP server
$smtpserver = "smtp.savasboluk.com"

# start looping here
Do{
$available = $Null
$notavailable = $Null
Write-Host (Get-Date)
write-host ""
Write-host "Sunucu Erişilebilirlik Testi"
write-host ""

# Read the File with the Hosts every cycle, this way to can add/remove hosts
# from the list without touching the script/scheduled task, 
# also hash/comment (#) out any hosts that are going for maintenance or are down.
get-content \\appsrv1\public\ErisimTesti.txt | Where-Object {!($_ -match "#")} | 
ForEach-Object {
if(Test-Connection -ComputerName $_ -Count 1 -ea silentlycontinue)
    {
     # if the Host is available then just write it to the screen
     write-host $_ -BackgroundColor darkgreen -ForegroundColor White " ---> OK"
     [Array]$available += $_
    }
else
    {
     # If the host is unavailable, give a warning to screen
     write-host "Erişim Sağlanamadı ---> "$_ -BackgroundColor Magenta -ForegroundColor White
     if(!(Test-Connection -ComputerName $_ -Count 4 -ea silentlycontinue))
       {
        # If the host is still unavailable for 4 full pings, write error and send email
        write-host "Sunucu Yanıt Vermiyor! ---> "$_ -BackgroundColor Red -ForegroundColor White
        [Array]$notavailable += $_

        if ($OutageHosts -ne $Null)
            {
                if (!$OutageHosts.ContainsKey($_))
                {
                 # First time down add to the list and send email
                 Write-Host "$_ Is not in the OutageHosts list, first time down"
                 $OutageHosts.Add($_,(get-date))
                 $Now = Get-Date -format G
                $Body = "$now <b>`n$_</b> Sunucu/cihaz ile bağlantı kurulamadı. Pinge yanıt vermiyor."
                Send-MailMessage -Body "$Body" -to $notificationto, $notificationto2 -cc $notificationcc -from $notificationfrom -Subject "$_ Sunucusuna erişilemiyor!" -SmtpServer $smtpserver -encoding UTF8 -BodyAsHtml
                }
                else
                {
                    # If the host is in the list do nothing for 1 hour and then remove from the list.
                    Write-Host "$_ Is in the OutageHosts list"
                    if (((Get-Date) - $OutageHosts.Item($_)).TotalMinutes -gt $EmailTimeOut)
                    {$OutageHosts.Remove($_)}
                }
            }
        else
            {
                # First time down create the list and send email
                Write-Host "Adding $_ to OutageHosts."
                $OutageHosts
                $now = Get-Date -format G
                $Body = "$now <b>`n$_</b> Sunucu/cihaz ile bağlantı kurulamadı. Pinge yanıt vermiyor."
                Send-MailMessage -Body "$body" -to $notificationto, $notificationto2 -cc $notificationcc -from $notificationfrom -Subject "$_ Sunucusuna erişilemiyor!" -SmtpServer $smtpserver -encoding UTF8 -BodyAsHtml
            } 
       }
    }
}
# Report to screen the details
Write-Host ""
Write-Host "Ulaşılan Sunucu Sayısı:"$available.count
Write-Host "Ulaşılamayan Sunucu Sayısı:"$notavailable.count
Write-Host ""
Write-Host "Ulaşılamayan Sunucular:"
$OutageHosts
Write-Host ""
Write-Host "Ping testi $SleepTimeOutDakika dk sonra tekrar başlayacak.."
sleep $SleepTimeOut
if ($OutageHosts.Count -gt $MaxOutageCount)
{
    # If there are more than a certain number of host down in an hour abort the script.
    $Exit = $True
    $body = $OutageHosts | Out-String
    Send-MailMessage -Body "$body" -to $notificationto -from $notificationfrom `
     -Subject "More than $MaxOutageCount Hosts down, monitoring aborted" -SmtpServer $smtpServer -port $smtpport -UseSsl -Credential $credent -BodyAsHtml
}
}
while ($Exit -ne $True)
