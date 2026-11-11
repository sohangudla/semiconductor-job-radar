$db = Get-Content "c:\Users\admin\Downloads\companies list\companies_db.json" -Raw | ConvertFrom-Json
$check = @("Soctronics", "InSemi", "Black Pepper", "Polymatech", "CG Semi", "Trident", "Si2chip", "SignOff", "ASICzen", "Aura", "CoreEL", "Tata Electronics")
foreach ($name in $check) {
    $found = $db | Where-Object { $_.Name -like "*$name*" }
    Write-Output "$name : $(if ($found) { 'Found (' + $found.Name + ' - ' + $found.Location + ')' } else { 'MISSING' })"
}
