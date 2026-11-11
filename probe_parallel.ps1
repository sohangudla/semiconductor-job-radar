# Multi-threaded Career Page Detector and Job Scanner for 102 DLI Semiconductor Companies
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
[System.Net.ServicePointManager]::DefaultConnectionLimit = 50

$workspace = "c:\Users\admin\Downloads\companies list"
$companies = Get-Content "$workspace\companies.json" -Raw | ConvertFrom-Json

$scriptBlock = {
    param($comp)
    
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

    $cName = $comp.Name
    $sno = $comp.SNo
    $rawBase = $comp.Url.Trim().TrimEnd('/')
    
    function Fetch-Url($url, $timeoutMs = 5000) {
        try {
            $req = [System.Net.HttpWebRequest]::Create($url)
            $req.Timeout = $timeoutMs
            $req.ReadWriteTimeout = $timeoutMs
            $req.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
            $req.AllowAutoRedirect = $true
            $req.MaximumAutomaticRedirections = 4
            $resp = $req.GetResponse()
            $finalUrl = $resp.ResponseUri.AbsoluteUri
            $stream = $resp.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($stream)
            $html = $reader.ReadToEnd()
            $reader.Close()
            $stream.Close()
            $resp.Close()
            return @{ Success = $true; Url = $finalUrl; Html = $html; StatusCode = 200 }
        } catch {
            return @{ Success = $false; Error = $_.Exception.Message }
        }
    }

    $foundCareerUrl = $null
    $targetHtml = ""
    $reachable = $false
    
    # Check base URL
    $res = Fetch-Url $rawBase
    if ($res.Success) {
        $reachable = $true
        $targetHtml = $res.Html
        $currentUrl = $res.Url

        # Scan for career/jobs link on homepage
        $regexes = @(
            'href=["'']([^"'']*(?:career|jobs|careers|job-openings|join-us|work-with-us|current-openings)[^"'']*)["'']',
            'href=["'']([^"'']*(?:lever\.co|greenhouse\.io|workday|keka\.com|darwinbox|freshteam)[^"'']*)["'']'
        )
        
        foreach ($rx in $regexes) {
            $matches = [regex]::Matches($res.Html, $rx, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            foreach ($m in $matches) {
                $link = $m.Groups[1].Value.Trim()
                if (-not $link.StartsWith("javascript:") -and -not $link.StartsWith("mailto:") -and -not ($link -eq "#")) {
                    if ($link -match '^https?://') {
                        $foundCareerUrl = $link
                    } elseif ($link -match '^/') {
                        $baseUri = New-Object System.Uri($currentUrl)
                        $foundCareerUrl = "$($baseUri.Scheme)://$($baseUri.Authority)$link"
                    } else {
                        $foundCareerUrl = "$rawBase/$link"
                    }
                    break
                }
            }
            if ($foundCareerUrl) { break }
        }
    }

    # If no link found on homepage, try common endpoints
    if (-not $foundCareerUrl) {
        $probes = @("/careers", "/career", "/jobs", "/join-us", "/work-with-us", "/careers/", "/career/")
        foreach ($p in $probes) {
            $testUrl = "$rawBase$p"
            $tRes = Fetch-Url $testUrl 3500
            if ($tRes.Success -and -not ($tRes.Url -match '(login|error|404|not-found)')) {
                # Check that page actually contains job or career content
                if ($tRes.Html -match '(career|job|opportunity|openings|position|join|apply)' -or $tRes.Url -ne $res.Url) {
                    $foundCareerUrl = $tRes.Url
                    $targetHtml = $tRes.Html
                    $reachable = $true
                    break
                }
            }
        }
    }

    # If career url found and we don't have its html yet, fetch it
    if ($foundCareerUrl -and $targetHtml -ne "" -and $foundCareerUrl -ne $rawBase) {
        $cRes = Fetch-Url $foundCareerUrl 5000
        if ($cRes.Success) {
            $targetHtml = $cRes.Html
        }
    }

    # Keyword analysis for Sohan's profile
    # Domains: RTL Design, Digital Design, Design Verification (DV), FPGA, VLSI, ASIC, Embedded C, Firmware, SoC
    # Level: entry level, fresher, junior, intern, graduate, trainee, 0-1, 0-2 years
    $cleanText = [regex]::Replace($targetHtml, '<[^>]+>', ' ')
    $cleanText = [regex]::Replace($cleanText, '\s+', ' ')

    $hasEntryLevel = ($cleanText -match '(?i)\b(entry[\s-]level|fresher|freshers|trainee|intern|internship|graduate|junior|0\s*-\s*[12]\s*years?)\b')
    $hasSemiconductorRole = ($cleanText -match '(?i)\b(rtl|verilog|systemverilog|verification|dv|fpga|asic|vlsi|soc|physical design|embedded|firmware|microelectronics)\b')
    $hasCareersPortal = ($cleanText -match '(?i)\b(openings|current openings|join our team|work with us|apply now|send your resume|careers@|hr@|jobs@)\b')

    # Extract HR / Careers email if present
    $emailMatch = [regex]::Match($cleanText, '([a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})')
    $contactEmail = if ($emailMatch.Success) { $emailMatch.Value } else { "" }

    return [PSCustomObject]@{
        SNo = $sno
        Name = $cName
        BaseUrl = $comp.Url
        CareerUrl = if ($foundCareerUrl) { $foundCareerUrl } else { $comp.Url }
        Status = if ($reachable) { "Reachable" } else { "Unreachable" }
        CareerPageFound = [bool]$foundCareerUrl
        HasEntrySignals = [bool]$hasEntryLevel
        HasSemiSignals = [bool]$hasSemiconductorRole
        HasCareerPortal = [bool]$hasCareersPortal
        ContactEmail = $contactEmail
    }
}

$pool = [RunspaceFactory]::CreateRunspacePool(1, 15)
$pool.Open()

$runspaces = @()
foreach ($c in $companies) {
    $ps = [PowerShell]::Create().AddScript($scriptBlock).AddArgument($c)
    $ps.RunspacePool = $pool
    $runspaces += [PSCustomObject]@{
        PowerShell = $ps
        AsyncResult = $ps.BeginInvoke()
        Company = $c
    }
}

Write-Output "Processing $($runspaces.Count) companies in parallel..."
$results = @()
$completed = 0

foreach ($r in $runspaces) {
    $res = $r.PowerShell.EndInvoke($r.AsyncResult)
    $results += $res
    $completed++
    if ($completed % 10 -eq 0 -or $completed -eq $runspaces.Count) {
        Write-Output "Progress: $completed / $($runspaces.Count)"
    }
    $r.PowerShell.Dispose()
}

$pool.Close()
$pool.Dispose()

$results | Sort-Object SNo | ConvertTo-Json -Depth 4 | Set-Content "$workspace\companies_scanned.json" -Encoding UTF8
$results | Sort-Object SNo | Export-Csv -Path "$workspace\companies_scanned.csv" -NoTypeInformation -Encoding UTF8

Write-Output "Scan finished! Results saved to companies_scanned.json and companies_scanned.csv"
