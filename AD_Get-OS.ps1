# Import AD module
Import-Module ActiveDirectory


# Domain adını bulma
$DomainName = (Get-ADDomain).NetBIOSName 

# Kaç gün öncesine kadar oturum açmış makineleri sorgula
$days = 30
$lastLogonDate = (Get-Date).AddDays(-$days).ToFileTime()


# AD sorgulama
$Computers = @(Get-ADComputer -Properties Name,operatingSystem,lastLogontimeStamp -Filter {(OperatingSystem -like "*Windows*") -AND (OperatingSystem -notLike "*SERVER*") -AND (lastLogontimeStamp -ge $lastLogonDate)})
foreach($Computer in $Computers)
{
    $Computer.OperatingSystem = $Computer.OperatingSystem -replace '®' -replace '™' -replace '专业版','Professional (Ch)' -replace 'Professionnel','Professional (Fr)'
}


$Computers | Group-Object operatingSystem | Select Count,Name | Sort Name | Out-GridView
