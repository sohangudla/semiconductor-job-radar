$db = Get-Content "c:\Users\admin\Downloads\companies list\companies_db.json" -Raw | ConvertFrom-Json
$toCheck = @("Soctronics", "InSemi", "Cirel", "Samsung Semiconductor", "Baya Systems", "Black Pepper", "Si2chip", "Polymatech", "CG Semi", "Trident Techlabs", "SiliConch", "CDIL")
foreach ($t in $toCheck) {
    $exists = $db | Where-Object { $_.Name -like "*$t*" }
    Write-Output "$t : $(if ($exists) { 'EXISTS' } else { 'READY TO ADD' })"
}
