$latest = Get-Content "c:\Users\admin\Downloads\companies list\latest_results.json" -Raw | ConvertFrom-Json
$checkNames = @("Soctronics", "InSemi", "Samsung Semiconductor", "Baya Systems", "Black Pepper", "Cirel", "Si2chip", "SiliConch", "CG Semi", "Polymatech", "Trident Techlabs", "CDIL")
foreach ($n in $checkNames) {
    $c = $latest | Where-Object { $_.Name -like "*$n*" }
    if ($c) {
        Write-Output "[$($c.Name)] Score: $($c.MatchScore)% | Loc: $($c.Location)"
        Write-Output "   Domain : $($c.Domain)"
        Write-Output "   Path   : $($c.FresherPath)"
        Write-Output "   Email  : $(if ($c.ContactEmail) { $c.ContactEmail } else { 'Portal Only' })"
        Write-Output "   Career : $($c.CareerUrl)"
        Write-Output ""
    }
}
