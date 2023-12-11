# Klasördeki tüm dosyaların ilk 3 karakterini siler
 get-childitem *.* | rename-item -newname { [string]($_.name).substring(3) }

# Klasördeki tüm dosyaların son 3 karakterini siler
Get-ChildItem * | rename-item -newname { $_.name.substring(0,$_.name.Length-3) }

# Klasördeki tüm dosyaların son 3 karakteri haricindeki karakterleri siler
Get-ChildItem * | rename-item -newname { $_.name.substring($_.name.Length-3) }
