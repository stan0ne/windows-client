# Klasördeki tüm dosyaların ilk 13 harfini siler
 get-childitem *.* | rename-item -newname { [string]($_.name).substring(13) }
