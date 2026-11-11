$db = Get-Content "c:\Users\admin\Downloads\companies list\companies_db.json" -Raw | ConvertFrom-Json
Write-Output "Total: $($db.Count)"
$db | Select-Object SNo, Name, Tier, Location | Sort-Object SNo | ForEach-Object {
    "$($_.SNo). $($_.Name) | $($_.Tier) | $($_.Location)"
}
