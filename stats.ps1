$db = Get-Content "c:\Users\admin\Downloads\companies list\companies_db.json" -Raw | ConvertFrom-Json
$blr = $db | Where-Object { $_.Location -match "(Bengaluru|Bangalore|Blr)" }
$hyd = $db | Where-Object { $_.Location -match "(Hyderabad|Hyd)" }
Write-Output "Total Companies: $($db.Count)"
Write-Output "Bengaluru Hubs : $($blr.Count)"
Write-Output "Hyderabad Hubs : $($hyd.Count)"
$db | Group-Object Tier | Select-Object Name, Count
