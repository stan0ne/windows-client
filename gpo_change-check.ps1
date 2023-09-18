ipmo GroupPolicy;Get-GPO -All|?{ $_.ModificationTime -gt (Get-Date).AddDays( -7 ) }|ft -AutoSize 
