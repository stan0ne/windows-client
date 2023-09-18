function Show-LdapMenu {
    param (
        [string]$Title = 'LDAP Kullanıcı Arama'
    )
    $host.ui.RawUI.WindowTitle = "$Title"
    Clear-Host
    Write-Host "=== $Title === `n" -foregroundcolor Yellow
    Write-Host "1: E-Posta Adres ile Kullanıcı & Telefon Bul" -foregroundcolor Green
    Write-Host "2: Kullanıcı Adı ile E-Posta & Telefon Bul" -foregroundcolor Green
    Write-Host "3: Telefon ile Kullanıcı & E-Posta Bul" -foregroundcolor Green
    Write-Host "Q: Çıkış `n" -foregroundcolor Green
}

do
 {
    Show-LdapMenu
    $selection = Read-Host "Seçin "
    switch ($selection)
    {
    '1' {
            $mail = $(Write-Host "`nE-Posta Adresi? " -ForegroundColor Yellow -NoNewline; Read-Host)
            $user = (Get-ADUser -Filter {Emailaddress -eq $mail}).userPrincipalName
            $telefon = (Get-ADUser -Filter {Emailaddress -eq $mail} -Properties *).telephoneNumber
            if ($user -eq $null) {Write-Host "`nKayıt Bulunamadı!`n" -ForegroundColor Red
            pause
            }
            else {Write-Color -text "`nKullanıcı Adı: ","$user" -Color Yellow,White
                  Write-Color -text "`nTelefon: ","$telefon`n" -Color Yellow,White
            pause
            Clear-Variable mail
            }
        }
    '2' {
            $user = $(Write-Host "`nKullanıcı Adı? " -ForegroundColor Yellow -NoNewline; Read-Host)
            $mail = (Get-ADUser -Filter {telephoneNumber -eq $telefon} -Properties *).mail
            $telefon = (Get-ADUser -Filter {telephoneNumber -eq $telefon} -Properties *).telephoneNumber
            if ($mail -eq $null) {Write-Host "`nKayıt Bulunamadı!`n" -ForegroundColor Red
            pause
            }
            else {Write-Color -text "`nE-Posta Adresi: ","$mail" -Color Yellow,White
                  Write-Color -text "`nTelefon: ","$telefon`n" -Color Yellow,White
            pause
            Clear-Variable mail
            }
        }
    '3' {
            $telefon = $(Write-Host "`nTelefon No? " -ForegroundColor Yellow -NoNewline; Read-Host)
            $user = (Get-ADUser -Filter {telephoneNumber -eq $telefon} -Properties *).userPrincipalName
            $mail = (Get-ADUser -Filter {telephoneNumber -eq $telefon} -Properties *).mail
            if ($user -eq $null) {Write-Host "`nKayıt Bulunamadı!`n" -ForegroundColor Red
            pause
            }
            else {Write-Color -text "`nKullanıcı Adı: ","$user" -Color Yellow,White
                  Write-Color -text "`nE-Posta Adresi: ","$mail`n" -Color Yellow,White
            pause
            Clear-Variable mail
            }
        }
    }
 }
 until ($selection -eq 'q')



