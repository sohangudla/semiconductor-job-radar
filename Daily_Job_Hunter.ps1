# ==============================================================================
# Comprehensive Semiconductor Career Radar for Gudla Sohan (216+ Companies)
# Priority Hubs: Bengaluru (High Priority / Alma Mater) & Hyderabad (Current Location)
# ==============================================================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
[System.Net.ServicePointManager]::DefaultConnectionLimit = 60

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $scriptDir) { $scriptDir = "c:\Users\admin\Downloads\companies list" }

$dbPath = Join-Path $scriptDir "companies_db.json"
$historyPath = Join-Path $scriptDir "job_history.json"
$reportPath = Join-Path $scriptDir "Daily_Career_Report.html"
$latestResultsPath = Join-Path $scriptDir "latest_results.json"

if (-not (Test-Path $dbPath)) {
    Write-Error "Database not found at $dbPath"
    exit 1
}

$companies = Get-Content $dbPath -Raw | ConvertFrom-Json

# Load history to track new postings
$previousHashes = @{}
if (Test-Path $historyPath) {
    try {
        $hist = Get-Content $historyPath -Raw | ConvertFrom-Json
        foreach ($h in $hist.Matches) {
            $previousHashes[$h.Key] = $true
        }
    } catch {}
}

Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host " Starting Semiconductor Job Radar for Gudla Sohan (RTL / DV / FPGA)" -ForegroundColor Yellow
Write-Host " Scanning $($companies.Count) Companies across Tier 1 MNCs, VLSI Services & Startups..." -ForegroundColor Cyan
Write-Host " High Priority Hub: Bengaluru (Amrita Alma Mater) | Base: Hyderabad" -ForegroundColor Magenta
Write-Host " Candidate: B.Tech ECE (CGPA: 8.8 / 10), Amrita Vishwa Vidyapeetham" -ForegroundColor Gray
Write-Host "========================================================================" -ForegroundColor Cyan

$workerBlock = {
    param($comp)

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

    function Fetch-Content($url, $timeoutMs = 6000) {
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
            return @{ Success = $true; Url = $finalUrl; Html = $html }
        } catch {
            return @{ Success = $false; Error = $_.Exception.Message }
        }
    }

    $cName = $comp.Name
    $sno = $comp.SNo
    $targetUrl = $comp.CareerUrl
    $tier = $comp.Tier
    $domain = $comp.Domain
    $location = $comp.Location
    $email = $comp.ContactEmail
    $fresherPath = $comp.FresherPath
    $isVerified = if ($comp.PSObject.Properties['Verified']) { [bool]$comp.Verified } else { $true }

    $isTier1 = ($tier -like "*Tier 1*")
    $isTier2 = ($tier -like "*Tier 2*")
    $isBengaluru = ($location -match "(Bengaluru|Bangalore|Blr)")
    $isHyderabad = ($location -match "(Hyderabad|Hyd)")

    $res = Fetch-Content $targetUrl
    if (-not $res.Success -and $targetUrl -ne $comp.BaseUrl -and -not [string]::IsNullOrEmpty($comp.BaseUrl)) {
        $res = Fetch-Content $comp.BaseUrl
    }

    $html = if ($res.Success) { $res.Html } else { "" }
    $resolvedUrl = if ($res.Success) { $res.Url } else { $targetUrl }

    # Strip scripts and styles for clean text analysis
    $cleanText = ""
    if ($html) {
        $cleanText = [regex]::Replace($html, '<script[^>]*>[\s\S]*?</script>', ' ')
        $cleanText = [regex]::Replace($cleanText, '<style[^>]*>[\s\S]*?</style>', ' ')
        $cleanText = [regex]::Replace($cleanText, '<noscript[^>]*>[\s\S]*?</noscript>', ' ')
        $cleanText = [regex]::Replace($cleanText, '<[^>]+>', ' ')
        $cleanText = [regex]::Replace($cleanText, '\s+', ' ')
    }

    # Strict Email Extraction and Sanitization
    $invalidExtensions = @('png','jpg','jpeg','gif','webp','svg','bmp','ico','css','js','woff','ttf','eot')
    $invalidDomains = @('example.com','domain.com','wixpress.com','sentry.io','micahrich.com','impallari.com','fonts.com')

    # Double check existing email to ensure no bogus emails slip in
    if ($email) {
        $emLower = $email.ToLower().Trim()
        $emExt = $emLower.Split('.')[-1]
        if ($invalidExtensions -contains $emExt -or $emLower -like "*impallari*" -or $emLower -like "*micahrich*" -or $emLower -like "*domain.com*") {
            $email = ""
        }
    }

    # Keyword Regexes
    $rxRTL = '\b(RTL|Verilog|SystemVerilog|Digital Design|ASIC Design|Micro-architecture|CDC|Synthesis|STA)\b'
    $rxDV = '\b(Design Verification|DV|Functional Verification|UVM|SVA|Assertions|Coverage|Constrained Random|VIP|Testbench)\b'
    $rxFPGA = '\b(FPGA|Basys|Artix|Vivado|Verilator|Yosys|Xilinx|Altera)\b'
    $rxEmbedded = '\b(Embedded|Firmware|Bare[- ]metal|SoC|ARM|STM32|LPC2148|Microcontroller|C\/C\+\+|Device Driver)\b'
    $rxEntry = '\b(entry[- ]level|fresher|freshers|trainee|intern|internship|graduate|campus|college hire|0\s*-\s*[12]\s*years?|junior)\b'

    $hasRTL = [bool]($cleanText -match $rxRTL)
    $hasDV = [bool]($cleanText -match $rxDV)
    $hasFPGA = [bool]($cleanText -match $rxFPGA)
    $hasEmbedded = [bool]($cleanText -match $rxEmbedded)
    $hasEntry = [bool]($cleanText -match $rxEntry)

    # Base score by tier
    $score = 0
    if ($isTier1) {
        $score = 80
        $hasRTL = $true
        $hasDV = $true
        $hasEntry = $true
    } elseif ($isTier2) {
        $score = 75
        $hasRTL = $true
        $hasDV = $true
        $hasEntry = $true
    } else {
        $metaRTL = ($domain -match $rxRTL -or $fresherPath -match $rxRTL)
        $metaDV = ($domain -match $rxDV -or $fresherPath -match $rxDV)
        $metaFPGA = ($domain -match $rxFPGA -or $fresherPath -match $rxFPGA)
        $metaEntry = ($domain -match $rxEntry -or $fresherPath -match $rxEntry)
        $metaEmbedded = ($domain -match $rxEmbedded -or $fresherPath -match $rxEmbedded)

        if ($isVerified -and ($hasEntry -or $metaEntry)) { $score += 35; $hasEntry = $true } else { if (-not $isVerified) { $hasEntry = $false } }
        if ($hasDV -or $metaDV) { $score += 25; $hasDV = $true }
        if ($hasRTL -or $metaRTL) { $score += 20; $hasRTL = $true }
        if ($hasFPGA -or $metaFPGA) { $score += 15; $hasFPGA = $true }
        if ($hasEmbedded -or $metaEmbedded) { $score += 10; $hasEmbedded = $true }
        if ($email) { $score += 10 }
    }

    # High Priority Location Boosts
    if ($isBengaluru -and $isVerified) { $score += 15 }   # High Priority: Bengaluru (Amrita Alma Mater)
    if ($isHyderabad -and $isVerified) { $score += 10 }   # Base Location: Hyderabad
    if ($email -and -not $isTier1) { $score += 5 }

    # Extract detected snippets with strict anti-garbage filtering
    $snippets = @()
    if ($cleanText) {
        $pattern = '.{0,70}(?:RTL|Verification|Digital Design|FPGA|Embedded|Intern|Fresher|Trainee).{0,70}'
        $matches = [regex]::Matches($cleanText, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        $collected = 0
        foreach ($m in $matches) {
            $val = $m.Value.Trim()
            
            # Reject leaked JSON, CSS, script variables, font paths, or HTML entities
            $isGarbage = ($val -match '(\{|\}|&quot;|id"|page_id|type"|appId=|data-|@font-face|awsm-job|google-site|gtag|var\s+|function\s*\(|\.css|\.js|window\.|<meta)')
            
            if ($val.Length -gt 25 -and -not $isGarbage -and -not ($snippets -contains $val)) {
                $snippets += $val
                $collected++
                if ($collected -ge 2) { break }
            }
        }
    }

    # Clean fallback snippet if no clean scraped text was found
    $combinedSnippet = if ($snippets.Count -gt 0) { 
        ($snippets -join " ... ") 
    } else { 
        "$domain - $fresherPath"
    }

    $status = "Reachable"
    if ($isTier1) {
        $status = "Tier 1 Product Leader (University Hire / NCG)"
    } elseif ($isTier2) {
        $status = "Major VLSI Services / GET Hiring"
    } elseif ($hasEntry -and ($hasDV -or $hasRTL)) {
        $status = "High Match: Entry-Level RTL/DV"
    } elseif ($hasEntry) {
        $status = "Fresher / Intern Friendly"
    }

    $key = "$($cName)_$([Math]::Round($score/10))"

    $focusPhrase = if ($comp.PSObject.Properties['FocusPhrase']) { [string]$comp.FocusPhrase } else { "" }
    $emailSource = if ($comp.PSObject.Properties['EmailSource']) { [string]$comp.EmailSource } else { "" }
    $emailDate = if ($comp.PSObject.Properties['EmailCheckedDate']) { [string]$comp.EmailCheckedDate } else { "" }

    return [PSCustomObject]@{
        SNo = $sno
        Name = $cName
        Tier = $tier
        Domain = $domain
        Location = $location
        CareerUrl = $resolvedUrl
        ContactEmail = $email
        FresherPath = $fresherPath
        Status = $status
        HasEntryLevel = ($hasEntry -and $isVerified)
        HasRTL_DV = ($hasRTL -or $hasDV)
        HasFPGA_Embedded = ($hasFPGA -or $hasEmbedded)
        IsBengaluru = [bool]$isBengaluru
        IsHyderabad = [bool]$isHyderabad
        IsVerified = [bool]$isVerified
        FocusPhrase = $focusPhrase
        EmailSource = $emailSource
        EmailCheckedDate = $emailDate
        MatchScore = $score
        Snippet = $combinedSnippet
        IsNew = $false
        Key = $key
    }
}

$pool = [RunspaceFactory]::CreateRunspacePool(1, 20)
$pool.Open()

$runspaces = @()
foreach ($c in $companies) {
    $ps = [PowerShell]::Create().AddScript($workerBlock).AddArgument($c)
    $ps.RunspacePool = $pool
    $runspaces += [PSCustomObject]@{
        PowerShell = $ps
        AsyncResult = $ps.BeginInvoke()
        Company = $c
    }
}

$results = @()
$completed = 0
foreach ($r in $runspaces) {
    $res = $r.PowerShell.EndInvoke($r.AsyncResult)
    $isNew = (-not $previousHashes.ContainsKey($res.Key) -and $res.MatchScore -ge 40)
    $res | Add-Member -MemberType NoteProperty -Name IsNew -Value $isNew -Force
    $results += $res
    $completed++
    if ($completed % 35 -eq 0 -or $completed -eq $runspaces.Count) {
        Write-Host " Scanned $completed / $($runspaces.Count) companies..." -ForegroundColor Green
    }
    $r.PowerShell.Dispose()
}

$pool.Close()
$pool.Dispose()

# Save latest results as JSON
$results | Sort-Object MatchScore, Name -Descending | ConvertTo-Json -Depth 4 | Set-Content $latestResultsPath -Encoding UTF8

# Save History
$newHistory = [PSCustomObject]@{
    LastRun = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Matches = $results | Where-Object { $_.MatchScore -gt 0 } | ForEach-Object { @{ Key = $_.Key; Name = $_.Name } }
}
$newHistory | ConvertTo-Json -Depth 3 | Set-Content $historyPath -Encoding UTF8

# Sort by MatchScore descending, then by Name
$sortedResults = $results | Sort-Object MatchScore, Name -Descending

# Top Metrics
$totalScanned = $sortedResults.Count
$blrCount = ($sortedResults | Where-Object { $_.IsBengaluru }).Count
$hydCount = ($sortedResults | Where-Object { $_.IsHyderabad }).Count
$tier1Count = ($sortedResults | Where-Object { $_.Tier -like "*Tier 1*" }).Count
$tier2Count = ($sortedResults | Where-Object { $_.Tier -like "*Tier 2*" }).Count
$tier3Count = ($sortedResults | Where-Object { $_.Tier -like "*Tier 3*" }).Count
$directEntryCount = ($sortedResults | Where-Object { $_.HasEntryLevel }).Count
$rtlDvCount = ($sortedResults | Where-Object { $_.HasRTL_DV }).Count
$emailCount = ($sortedResults | Where-Object { $_.ContactEmail -ne "" }).Count
$confirmedEmailCount = ($sortedResults | Where-Object { $_.EmailSource -and $_.EmailSource -ne "unconfirmed" }).Count

Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host " Scan Finished Successfully!" -ForegroundColor Green
Write-Host " Total Companies Tracked       : $totalScanned" -ForegroundColor White
Write-Host " Bengaluru Hubs (High Priority): $blrCount" -ForegroundColor Yellow
Write-Host " Hyderabad Hubs                : $hydCount" -ForegroundColor Yellow
Write-Host " Tier 1 Global Giants          : $tier1Count" -ForegroundColor Cyan
Write-Host " Tier 2 VLSI Services          : $tier2Count" -ForegroundColor Cyan
Write-Host " Tier 3 Startups & DLI         : $tier3Count" -ForegroundColor Cyan
Write-Host " Verified Direct HR Emails     : $confirmedEmailCount (out of $emailCount total)" -ForegroundColor Green
Write-Host "========================================================================" -ForegroundColor Cyan

# Candidate Profile & Configuration
$resumeUrl = "<link that opens without sign-in>"
$githubUrl = "https://github.com/<your-username>"
$linkedinUrl = "https://www.linkedin.com/in/<your-profile>"
$candidateProjects = @(
    @{ Name = "Low-Power 4-Bit ALU (SV/SVA, Basys-3)"; Url = "<repo link>" },
    @{ Name = "Multi-User ATM Controller (Verilog FSM, 36 assertions)"; Url = "<repo link>" },
    @{ Name = "ARM7 LPC2148 Bare-Metal Firmware"; Url = "<repo link>" }
)
$nowStr = (Get-Date).ToString("dd MMM yyyy, hh:mm tt")
$nowIso = (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz")

$htmlRows = ""
foreach ($item in $sortedResults) {
    $scoreBadgeColor = if ($item.MatchScore -ge 85) { "#10b981" } elseif ($item.MatchScore -ge 70) { "#3b82f6" } elseif ($item.MatchScore -ge 50) { "#f59e0b" } else { "#64748b" }
    
    # Badges
    $badgeCategory = ""
    $tierBadgeClass = if ($item.Tier -like "*Tier 1*") { "badge-tier1" } elseif ($item.Tier -like "*Tier 2*") { "badge-tier2" } else { "badge-tier3" }
    $tierShort = if ($item.Tier -like "*Tier 1*") { "Tier 1: Global Giant" } elseif ($item.Tier -like "*Tier 2*") { "Tier 2: VLSI Services" } else { "Tier 3: Startup / DLI" }
    $badgeCategory += "<span class='badge " + $tierBadgeClass + "'>" + $tierShort + "</span> "

    if (-not $item.IsVerified) {
        $badgeCategory += "<span class='badge badge-unverified'>Unverified</span> "
    }

    if ($item.IsBengaluru) {
        $badgeCategory += "<span class='badge badge-blr'>Bengaluru [Top Priority]</span> "
    }

    if ($item.IsHyderabad) {
        $badgeCategory += "<span class='badge badge-hyd'>Hyderabad Office</span> "
    }

    if ($item.HasEntryLevel) {
        $badgeCategory += "<span class='badge badge-entry'>Fresher / Entry Match</span> "
    }

    if ($item.HasRTL_DV) {
        $badgeCategory += "<span class='badge badge-rtl'>RTL & DV</span> "
    }

    if ($item.IsNew) {
        $badgeCategory += "<span class='badge badge-new'>NEW TODAY!</span> "
    }

    $emailBtn = ""
    if ($item.ContactEmail) {
        $cleanBrand = ($item.Name -replace '\s*\(.*$', '').Trim()
        
        $personalSentence = if (-not [string]::IsNullOrWhiteSpace($item.FocusPhrase)) {
            "I am particularly keen to contribute to your team's work in $($item.FocusPhrase)."
        } else {
            "I am particularly eager to contribute my RTL design and verification skills to your team."
        }

        $resumeLine = ""
        if (-not [string]::IsNullOrWhiteSpace($resumeUrl) -and $resumeUrl -notmatch "PASTE" -and $resumeUrl -notmatch "<.*?>") {
            $resumeLine = "`n`nResume: $resumeUrl"
        }

        $companyCoverLetter = @"
Dear Hiring Team at $cleanBrand,

I am writing to express my strong interest in entry-level RTL Design, Verification (DV), or Embedded Firmware roles at $cleanBrand. $personalSentence

I am a final-year B.Tech ECE student at Amrita Vishwa Vidyapeetham, Bengaluru (CGPA: 8.8/10), with practical experience in Verilog, SystemVerilog, UVM, FPGA prototyping (Basys-3), and AMBA APB/AXI-Lite.

Key Technical Projects:
1. Low-Power 4-Bit ALU: SV/SVA testbench, 100% functional coverage, 48.8% power reduction on Basys-3 FPGA.
2. Multi-User ATM Controller: 15-state Moore FSM in Verilog with 36 assertions (100% pass rate).
3. Embedded SoC Firmware: Bare-metal C on ARM7 LPC2148 (Interrupt-driven RTC, LCD, UART).$resumeLine

I would welcome the opportunity to discuss how I can contribute to your team.

Sincerely,
Gudla Sohan
Hyderabad & Bengaluru | +91 XXXXXXXXXX | sohangudla04@gmail.com
"@

        $mailSubject = [System.Uri]::EscapeDataString("Application: RTL Design & Verification Entry-Level Role - Gudla Sohan (B.Tech ECE Amrita, CGPA 8.8)").Replace("'", "%27")
        $mailBodyEncoded = [System.Uri]::EscapeDataString($companyCoverLetter).Replace("'", "%27")
        $mailHref = "mailto:" + $item.ContactEmail + "?subject=" + $mailSubject + "&body=" + $mailBodyEncoded
        # Gmail web compose works even when Windows has no default mail app
        $gmailHref = "https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=" + [System.Uri]::EscapeDataString($item.ContactEmail) + "&amp;su=" + $mailSubject + "&amp;body=" + $mailBodyEncoded

        $isEmailConfirmed = ($item.EmailSource -and $item.EmailSource -ne "unconfirmed")

        if ($isEmailConfirmed) {
            $btnClass = "btn-email"
            $btnLabel = "Email HR in Gmail &#8599;"
            $emailTooltip = [System.Web.HttpUtility]::HtmlEncode("Found on $($item.EmailSource)").Replace("'", "&#39;")
        } else {
            $btnClass = "btn-email btn-email-unconfirmed"
            $btnLabel = "Email HR in Gmail (unconfirmed) &#8599;"
            $emailTooltip = "Not confirmed - prefer career portal"
        }

        $emailAddr = [System.Web.HttpUtility]::HtmlEncode($item.ContactEmail)
        $emailBtn = "<a href='" + $gmailHref + "' target='_blank' rel='noopener' class='$btnClass' title='$emailTooltip'>$btnLabel</a>" +
            "<div class='email-alt'>$emailAddr &bull; <a href='" + $mailHref + "' class='sublink' title='Open in your default mail app instead'>use mail app</a></div>"
    } else {
        $emailBtn = "<span class='no-email'>Apply via Portal</span>"
    }

    $cleanSnippet = [System.Web.HttpUtility]::HtmlEncode($item.Snippet)
    $cleanName = [System.Web.HttpUtility]::HtmlEncode($item.Name)
    $cleanDomain = [System.Web.HttpUtility]::HtmlEncode($item.Domain)
    $cleanLoc = [System.Web.HttpUtility]::HtmlEncode($item.Location)
    $cleanPath = [System.Web.HttpUtility]::HtmlEncode($item.FresherPath)

    # Clean brand name for precision LinkedIn search queries
    $brand = ($item.Name -replace '\s*\(.*$', '').Trim()
    if ($brand -like "*Apple*") { $brand = "Apple" }
    elseif ($brand -like "*Cisco*") { $brand = "Cisco" }
    elseif ($brand -like "*Google*") { $brand = "Google" }
    elseif ($brand -like "*Microsoft*") { $brand = "Microsoft" }
    elseif ($brand -like "*Samsung*") { $brand = "Samsung Semiconductor" }
    elseif ($brand -like "*L&T Semiconductor*") { $brand = "L&T Semiconductor" }
    elseif ($brand -like "*L&T Technology*") { $brand = "LTTS" }
    elseif ($brand -like "*Western Digital*") { $brand = "Western Digital" }
    elseif ($brand -like "*Siemens EDA*") { $brand = "Siemens EDA" }
    elseif ($brand -like "*C-DAC*") { $brand = "CDAC" }

    $encodedBrand = [System.Uri]::EscapeDataString($brand)
    $liPostsUrl = "https://www.linkedin.com/search/results/content/?keywords=hiring%20(DV%20OR%20RTL%20OR%20VLSI%20OR%20Verification)%20" + $encodedBrand + "&sortBy=%22date_posted%22"
    $liManagersUrl = "https://www.linkedin.com/search/results/people/?keywords=" + [System.Uri]::EscapeDataString("$brand Manager (Verification OR RTL OR VLSI)")
    $liAlumniUrl = "https://www.linkedin.com/school/amrita-vishwa-vidyapeetham/people/?keywords=" + $encodedBrand

    $categoryFilter = "all"
    if ($item.IsBengaluru) { $categoryFilter += " blr" }
    if ($item.IsHyderabad) { $categoryFilter += " hyd" }
    if ($item.Tier -like "*Tier 1*") { $categoryFilter += " tier1" }
    if ($item.Tier -like "*Tier 2*") { $categoryFilter += " tier2" }
    if ($item.Tier -like "*Tier 3*") { $categoryFilter += " tier3" }
    if ($item.HasEntryLevel) { $categoryFilter += " entry" }
    if ($item.HasRTL_DV) { $categoryFilter += " rtldv" }
    if ($item.ContactEmail) { $categoryFilter += " hasemail" }
    if (-not $item.IsVerified) { $categoryFilter += " unverified" }

    $htmlRows += @"
    <tr class='job-row $categoryFilter' data-name='$cleanName' data-score='$($item.MatchScore)'>
        <td class='td-rank'>#$($item.SNo)</td>
        <td class='td-company'>
            <div class='comp-name'>$cleanName</div>
            <div class='comp-domain'>$cleanDomain</div>
            <div class='comp-loc'>Location: $cleanLoc</div>
        </td>
        <td class='td-badges'>
            <div class='score-pill' style='background-color: $scoreBadgeColor;'>Score: $($item.MatchScore)%</div>
            <div class='badge-list'>$badgeCategory</div>
        </td>
        <td class='td-snippet'>
            <div class='fresher-path'><strong>Hiring Pathway:</strong> $cleanPath</div>
            <div class='snippet-box'>$cleanSnippet</div>
        </td>
        <td class='td-actions'>
            <a href='$($item.CareerUrl)' target='_blank' rel='noopener' class='btn-apply'>Career Portal &rarr;</a>
            $emailBtn
            <a href='$liPostsUrl' target='_blank' rel='noopener' class='btn-linkedin' title='Search recent hiring posts on LinkedIn for $cleanName'>LinkedIn Posts &nearr;</a>
            <div class='action-sublinks'>
                <a href='$liManagersUrl' target='_blank' rel='noopener' class='sublink' title='Search DV / RTL Managers at $cleanName on LinkedIn'>Find Leads</a>
                <span class='sublink-sep'>&bull;</span>
                <a href='$liAlumniUrl' target='_blank' rel='noopener' class='sublink' title='Find Amrita Alumni at $cleanName on LinkedIn'>Amrita Alumni</a>
            </div>
        </td>
    </tr>
"@
}

# Task 4: Profile Links & Project Chips
# Per rules: Leave out any item left as placeholder <...> or empty; do not invent links.
function Test-IsRealLink($url) {
    if ([string]::IsNullOrWhiteSpace($url)) { return $false }
    if ($url -match '<.*?>' -or $url -match 'PASTE') { return $false }
    return $true
}

$validProfileLinks = @()
if (Test-IsRealLink $githubUrl) {
    $cleanGh = [System.Web.HttpUtility]::HtmlEncode($githubUrl)
    $validProfileLinks += "<a href='$cleanGh' target='_blank' rel='noopener' class='profile-link'>GitHub &#8599;</a>"
}
if (Test-IsRealLink $linkedinUrl) {
    $cleanLi = [System.Web.HttpUtility]::HtmlEncode($linkedinUrl)
    $validProfileLinks += "<a href='$cleanLi' target='_blank' rel='noopener' class='profile-link'>LinkedIn &#8599;</a>"
}
if (Test-IsRealLink $resumeUrl) {
    $cleanRes = [System.Web.HttpUtility]::HtmlEncode($resumeUrl)
    $validProfileLinks += "<a href='$cleanRes' target='_blank' rel='noopener' class='profile-link'>Resume &#8599;</a>"
}
$profileLinksItem = if ($validProfileLinks.Count -gt 0) {
    "`n        <div class=`"res-item`"><strong>Profiles:</strong> <span class=`"profile-links`">" + ($validProfileLinks -join " ") + "</span></div>"
} else { "" }

$validProjectChips = @()
foreach ($proj in $candidateProjects) {
    if (Test-IsRealLink $proj.Url) {
        $cleanProjUrl = [System.Web.HttpUtility]::HtmlEncode($proj.Url)
        $cleanProjName = [System.Web.HttpUtility]::HtmlEncode($proj.Name)
        $validProjectChips += "<a href='$cleanProjUrl' target='_blank' rel='noopener' class='project-chip'>$cleanProjName &#8599;</a>"
    }
}
$projectChipsItem = if ($validProjectChips.Count -gt 0) {
    "`n        <div class=`"res-item`"><strong>Key Projects:</strong> <span class=`"project-chips`">" + ($validProjectChips -join " ") + "</span></div>"
} else { "" }

$htmlTemplate = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Semiconductor Career Radar | Gudla Sohan (Bengaluru & Hyderabad)</title>
    <style>
        :root {
            --bg: #0b1120;
            --surface: #1e293b;
            --surface-hover: #273549;
            --border: #334155;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --accent-cyan: #38bdf8;
            --accent-green: #10b981;
            --accent-amber: #f59e0b;
            --accent-orange: #fb923c;
            --accent-indigo: #818cf8;
            --accent-purple: #c084fc;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; }
        body { background: var(--bg); color: var(--text-main); min-height: 100vh; padding: 24px; }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            padding: 24px 32px;
            border-radius: 16px;
            border: 1px solid var(--border);
            margin-bottom: 24px;
            box-shadow: 0 10px 25px -5px rgba(0,0,0,0.5);
        }
        .header-title h1 { font-size: 26px; font-weight: 700; color: #fff; display: flex; align-items: center; gap: 12px; }
        .header-title p { color: var(--text-muted); margin-top: 6px; font-size: 14px; }
        .candidate-tag {
            background: rgba(56, 189, 248, 0.15);
            border: 1px solid var(--accent-cyan);
            color: var(--accent-cyan);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
        }
        .priority-badge-header {
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.25) 0%, rgba(251, 146, 60, 0.25) 100%);
            border: 1px solid var(--accent-amber);
            color: #fcd34d;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .resume-summary {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px 24px;
            margin-bottom: 24px;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            font-size: 13px;
        }
        .res-item strong { color: var(--accent-cyan); }
        .res-item span { color: var(--text-muted); }
        .profile-links { display: inline-flex; flex-wrap: wrap; gap: 8px; align-items: center; }
        .profile-link {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 2px 8px;
            background: rgba(56, 189, 248, 0.1);
            border: 1px solid rgba(56, 189, 248, 0.3);
            border-radius: 4px;
            color: #38bdf8;
            font-size: 12px;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .profile-link:hover {
            background: rgba(56, 189, 248, 0.25);
            border-color: #38bdf8;
            color: #fff;
        }
        .project-chips { display: inline-flex; flex-wrap: wrap; gap: 8px; align-items: center; }
        .project-chip {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 2px 10px;
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.3);
            border-radius: 6px;
            color: #34d399;
            font-size: 12px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .project-chip:hover {
            background: rgba(16, 185, 129, 0.25);
            border-color: #10b981;
            color: #fff;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 14px;
            margin-bottom: 24px;
        }
        .metric-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 18px;
            text-align: center;
            transition: transform 0.2s;
        }
        .metric-card:hover { transform: translateY(-2px); border-color: var(--accent-cyan); }
        .metric-card.priority-card {
            border: 1px solid rgba(245, 158, 11, 0.5);
            background: linear-gradient(180deg, rgba(245, 158, 11, 0.08) 0%, rgba(30, 41, 59, 1) 100%);
        }
        .metric-val { font-size: 32px; font-weight: 800; margin-bottom: 4px; }
        .metric-label { font-size: 12px; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }

        .controls {
            display: flex;
            flex-direction: column;
            gap: 14px;
            margin-bottom: 20px;
        }
        .tabs { display: flex; gap: 8px; flex-wrap: wrap; }
        .tab-btn {
            background: var(--surface);
            border: 1px solid var(--border);
            color: var(--text-muted);
            padding: 8px 14px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .tab-btn.active, .tab-btn:hover {
            background: var(--accent-cyan);
            color: #0f172a;
            border-color: var(--accent-cyan);
        }
        .tab-btn.tab-blr {
            background: rgba(245, 158, 11, 0.15);
            border-color: var(--accent-amber);
            color: #fcd34d;
            font-weight: 700;
        }
        .tab-btn.tab-blr.active, .tab-btn.tab-blr:hover {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: #0f172a;
            border-color: #f59e0b;
        }

        .search-box input {
            background: var(--surface);
            border: 1px solid var(--border);
            color: #fff;
            padding: 10px 18px;
            border-radius: 8px;
            font-size: 14px;
            width: 100%;
            max-width: 480px;
            outline: none;
        }
        .search-box input:focus { border-color: var(--accent-cyan); }

        .table-container {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow-x: auto;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.3);
        }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th {
            background: #172033;
            color: var(--text-muted);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 14px 18px;
            border-bottom: 1px solid var(--border);
        }
        td {
            padding: 14px 18px;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
            font-size: 13px;
        }
        tr:hover { background: var(--surface-hover); }

        .td-rank { color: var(--text-muted); font-weight: 600; width: 50px; }
        .comp-name { font-size: 15px; font-weight: 700; color: #fff; }
        .comp-domain { color: var(--accent-cyan); font-size: 12px; margin-top: 2px; }
        .comp-loc { color: #cbd5e1; font-size: 11px; margin-top: 3px; }

        .score-pill {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 6px;
            color: #fff;
            font-size: 11px;
            font-weight: 700;
            margin-bottom: 6px;
        }
        .badge-list { display: flex; flex-direction: column; gap: 4px; }
        .badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 10px;
            font-weight: 600;
            text-transform: uppercase;
            width: fit-content;
        }
        .badge-blr { background: rgba(245, 158, 11, 0.25); color: #fcd34d; border: 1px solid #f59e0b; font-weight: 700; }
        .badge-hyd { background: rgba(239, 68, 68, 0.2); color: #fca5a5; border: 1px solid #ef4444; }
        .badge-tier1 { background: rgba(192, 132, 252, 0.2); color: #d8b4fe; border: 1px solid #c084fc; }
        .badge-tier2 { background: rgba(56, 189, 248, 0.2); color: #7dd3fc; border: 1px solid #38bdf8; }
        .badge-tier3 { background: rgba(100, 116, 139, 0.2); color: #cbd5e1; border: 1px solid #64748b; }
        .badge-entry { background: rgba(16, 185, 129, 0.2); color: #34d399; border: 1px solid #10b981; }
        .badge-rtl { background: rgba(129, 140, 248, 0.2); color: #c7d2fe; border: 1px solid #818cf8; }
        .badge-new { background: #ef4444; color: #fff; }
        .badge-unverified { background: rgba(239, 68, 68, 0.15); color: #fca5a5; border: 1px solid rgba(239, 68, 68, 0.4); }

        .fresher-path {
            font-size: 12px;
            color: #38bdf8;
            margin-bottom: 6px;
            background: rgba(56, 189, 248, 0.08);
            padding: 4px 8px;
            border-radius: 4px;
            border-left: 3px solid #38bdf8;
        }
        .snippet-box {
            color: #94a3b8;
            font-size: 12px;
            line-height: 1.4;
            max-width: 480px;
        }

        .td-actions { display: flex; flex-direction: column; gap: 7px; min-width: 175px; }
        .btn-apply {
            display: block;
            text-align: center;
            background: var(--accent-cyan);
            color: #0f172a;
            padding: 7px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 700;
            font-size: 11px;
            transition: all 0.2s;
        }
        .btn-apply:hover { background: #7dd3fc; }
        .btn-email {
            display: block;
            text-align: center;
            background: #22c55e;
            color: #052e16;
            padding: 7px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 700;
            font-size: 11px;
            transition: all 0.2s;
        }
        .btn-email:hover { background: #4ade80; }
        .btn-email-unconfirmed {
            background: #475569;
            color: #f1f5f9;
            border: 1px solid #64748b;
        }
        .btn-email-unconfirmed:hover { background: #64748b; color: #ffffff; }
        .email-alt { font-size: 10px; color: var(--text-muted); text-align: center; margin-top: -3px; word-break: break-all; }
        .btn-linkedin {
            display: block;
            text-align: center;
            background: #0a66c2;
            color: #ffffff;
            padding: 7px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 700;
            font-size: 11px;
            transition: all 0.2s;
        }
        .btn-linkedin:hover { background: #004182; color: #fff; }
        .action-sublinks {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            margin-top: 2px;
        }
        .sublink {
            color: #38bdf8;
            text-decoration: none;
            font-weight: 600;
        }
        .sublink:hover { text-decoration: underline; color: #7dd3fc; }
        .sublink-sep { color: var(--border); font-size: 10px; }
        .no-email { color: var(--text-muted); font-size: 11px; text-align: center; }

        /* LinkedIn Command Center */
        .linkedin-command-hub {
            background: linear-gradient(135deg, rgba(10, 102, 194, 0.14) 0%, rgba(30, 41, 59, 0.98) 100%);
            border: 1px solid rgba(10, 102, 194, 0.45);
            border-radius: 14px;
            padding: 20px 24px;
            margin-bottom: 24px;
            box-shadow: 0 8px 24px -4px rgba(0,0,0,0.4);
        }
        .hub-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 14px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            padding-bottom: 12px;
        }
        .hub-title {
            font-size: 18px;
            font-weight: 800;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .hub-badge {
            background: #0a66c2;
            color: #fff;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }
        .hub-subtitle {
            font-size: 13px;
            color: #94a3b8;
            margin-top: 4px;
            line-height: 1.4;
        }
        .hub-nav {
            display: flex;
            gap: 8px;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }
        .hub-tab-btn {
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid var(--border);
            color: var(--text-muted);
            padding: 7px 14px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }
        .hub-tab-btn.active, .hub-tab-btn:hover {
            background: #0a66c2;
            color: #fff;
            border-color: #0a66c2;
        }
        .hub-tab-content { display: none; }
        .hub-tab-content.active { display: block; }
        .hub-quick-searches {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .btn-quick-li {
            background: rgba(10, 102, 194, 0.25);
            border: 1px solid #0a66c2;
            color: #7dd3fc;
            padding: 8px 15px;
            border-radius: 20px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-quick-li:hover {
            background: #0a66c2;
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(10, 102, 194, 0.3);
        }
        .btn-quick-li.highlight {
            border-color: #f59e0b;
            color: #fcd34d;
            background: rgba(245, 158, 11, 0.15);
        }
        .btn-quick-li.highlight:hover {
            background: #f59e0b;
            color: #0f172a;
        }
        .templates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 14px;
        }
        .template-card {
            background: rgba(15, 23, 42, 0.85);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 14px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .template-card:hover { border-color: #38bdf8; }
        .tpl-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        .tpl-title { font-size: 13px; font-weight: 700; color: #f1f5f9; }
        .tpl-badge { font-size: 10px; padding: 2px 6px; border-radius: 4px; background: rgba(56, 189, 248, 0.2); color: #38bdf8; font-weight: 700; }
        .tpl-body {
            font-family: Consolas, "Courier New", monospace;
            font-size: 11px;
            color: #cbd5e1;
            background: #0b1120;
            padding: 10px;
            border-radius: 6px;
            white-space: pre-wrap;
            line-height: 1.4;
            border: 1px solid rgba(255,255,255,0.06);
            margin-bottom: 10px;
            user-select: all;
            max-height: 150px;
            overflow-y: auto;
        }
        .btn-copy-tpl {
            background: #334155;
            color: #f8fafc;
            border: 1px solid #475569;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            width: fit-content;
            align-self: flex-end;
        }
        .btn-copy-tpl:hover {
            background: #38bdf8;
            color: #0f172a;
            border-color: #38bdf8;
        }
        .playbook-steps {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 12px;
        }
        .step-box {
            background: rgba(15, 23, 42, 0.85);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 14px;
        }
        .step-num { font-size: 11px; font-weight: 800; color: #f59e0b; text-transform: uppercase; margin-bottom: 4px; }
        .step-title { font-size: 13px; font-weight: 700; color: #fff; margin-bottom: 6px; }
        .step-desc { font-size: 12px; color: #94a3b8; line-height: 1.4; }

        .footer {
            margin-top: 32px;
            text-align: center;
            color: var(--text-muted);
            font-size: 12px;
        }

        /* Progress tracker */
        .progress-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 14px;
            margin-bottom: 24px;
        }
        .progress-grid .metric-card { border-color: rgba(16, 185, 129, 0.4); }
        .progress-grid .metric-val { font-size: 26px; }
        .progress-actions {
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 8px;
        }
        .btn-ghost {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--text-muted);
            padding: 7px 12px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-ghost:hover { border-color: var(--accent-cyan); color: var(--accent-cyan); }

        .filter-row { display: flex; flex-wrap: wrap; gap: 10px; align-items: center; }
        .filter-row .search-box { flex: 1 1 320px; }
        .filter-row select, .status-cell select, .status-cell input, .status-cell textarea {
            background: var(--surface);
            border: 1px solid var(--border);
            color: var(--text-main);
            border-radius: 8px;
            font-size: 13px;
            outline: none;
        }
        .filter-row select { padding: 10px 12px; }
        .filter-row select:focus, .status-cell select:focus, .status-cell input:focus, .status-cell textarea:focus { border-color: var(--accent-cyan); }
        .result-count { color: var(--text-muted); font-size: 12px; }

        th.sortable { cursor: pointer; user-select: none; white-space: nowrap; }
        th.sortable:hover { color: var(--accent-cyan); }
        th.sortable::after { content: " \2195"; opacity: 0.4; }
        th.sort-asc::after { content: " \2191"; opacity: 1; color: var(--accent-cyan); }
        th.sort-desc::after { content: " \2193"; opacity: 1; color: var(--accent-cyan); }

        .score-pill.unscored { background-color: #475569 !important; }
        .status-cell { min-width: 170px; }
        .status-cell select, .status-cell input, .status-cell textarea { width: 100%; padding: 6px 8px; font-size: 12px; margin-bottom: 6px; }
        .status-cell textarea { resize: vertical; min-height: 34px; font-family: inherit; }
        .status-cell label { display: block; font-size: 10px; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 2px; }
        .followup-flag { display: none; font-size: 10px; font-weight: 700; color: #0f172a; background: var(--accent-amber); padding: 2px 6px; border-radius: 4px; margin-bottom: 6px; width: fit-content; }
        tr.followup-due .followup-flag { display: block; }
        tr[data-status="applied"] { box-shadow: inset 3px 0 0 var(--accent-cyan); }
        tr[data-status="emailed"] { box-shadow: inset 3px 0 0 var(--accent-indigo); }
        tr[data-status="connected"] { box-shadow: inset 3px 0 0 #0a66c2; }
        tr[data-status="interview"] { box-shadow: inset 3px 0 0 var(--accent-green); }
        tr[data-status="offer"] { box-shadow: inset 3px 0 0 #facc15; }
        tr[data-status="rejected"] { opacity: 0.55; }

        /* Phones & small tablets: header stacks, table rows become cards */
        @media (max-width: 768px) {
            body { padding: 12px; }
            .header { flex-direction: column; align-items: flex-start; gap: 14px; padding: 18px; }
            .header-title h1 { font-size: 20px; flex-wrap: wrap; gap: 8px; }
            .resume-summary { padding: 14px; gap: 10px; flex-direction: column; }
            .metrics-grid, .progress-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; }
            .metric-val { font-size: 24px; }
            .linkedin-command-hub { padding: 16px; }
            .hub-title { flex-wrap: wrap; font-size: 16px; }
            .templates-grid { grid-template-columns: 1fr; }
            .tabs { flex-wrap: nowrap; overflow-x: auto; padding-bottom: 4px; -webkit-overflow-scrolling: touch; }
            .tab-btn { white-space: nowrap; flex: 0 0 auto; }
            .search-box input { max-width: none; }
            .filter-row select { flex: 1 1 140px; }

            .table-container { background: transparent; border: none; box-shadow: none; overflow: visible; }
            table, tbody, tr, td { display: block; width: 100%; }
            thead { display: none; }
            tr.job-row {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 12px;
                margin-bottom: 12px;
                padding: 6px 0;
                position: relative;
            }
            td { border-bottom: none; padding: 8px 14px; }
            td.td-rank { position: absolute; top: 10px; right: 6px; width: auto; font-size: 12px; }
            .td-company { padding-right: 48px; }
            .badge-list { flex-direction: row; flex-wrap: wrap; }
            .snippet-box { max-width: none; }
            .td-actions { min-width: 0; }
            .status-cell { min-width: 0; border-top: 1px solid var(--border); padding-top: 12px; }
        }
    </style>
</head>
<body>

    <div class="header">
        <div class="header-title">
            <h1>India Semiconductor Job Radar <span class="candidate-tag">Gudla Sohan</span> <span class="priority-badge-header">Bengaluru [High Priority Hub]</span></h1>
            <p>$totalScanned Companies Monitored (Tier 1 Global Giants &bull; Tier 2 VLSI Services &bull; Tier 3 Startups/DLI) &bull; Last Scanned: $nowStr &bull; <span id="scanAge" data-scanned="$nowIso"></span></p>
        </div>
        <div>
            <button onclick="window.location.reload()" class="btn-apply" style="padding: 10px 18px; font-size: 13px;">Reload page</button>
        </div>
    </div>

    <div class="resume-summary">
        <div class="res-item"><strong>Target Roles:</strong> <span>RTL Design Engineer, Design Verification (DV) Engineer, FPGA Engineer, Embedded Firmware</span></div>
        <div class="res-item"><strong>Priority Hubs:</strong> <span style="color: #fcd34d; font-weight: 700;">Bengaluru (Top Priority / Amrita Campus)</span> | <span style="color: #fca5a5;">Hyderabad (Base City)</span></div>
        <div class="res-item"><strong>Matched Profile:</strong> <span>B.Tech ECE (4th Yr, Amrita Vishwa Vidyapeetham, Bengaluru), CGPA: 8.8 / 10</span></div>
        <div class="res-item"><strong>Core Skills:</strong> <span>Verilog, SystemVerilog, UVM / SVA Assertions, Basys-3 Artix-7, Vivado, Low-Power Design, Embedded C</span></div>$profileLinksItem$projectChipsItem
    </div>

    <div class="metrics-grid">
        <div class="metric-card">
            <div class="metric-val" style="color: var(--accent-cyan);">$totalScanned</div>
            <div class="metric-label">Total Companies</div>
        </div>
        <div class="metric-card priority-card">
            <div class="metric-val" style="color: #f59e0b;">$blrCount</div>
            <div class="metric-label" style="color: #fcd34d; font-weight: 700;">Bengaluru (Top Priority)</div>
        </div>
        <div class="metric-card">
            <div class="metric-val" style="color: #f87171;">$hydCount</div>
            <div class="metric-label">Hyderabad Offices</div>
        </div>
        <div class="metric-card">
            <div class="metric-val" style="color: var(--accent-purple);">$tier1Count</div>
            <div class="metric-label">Tier 1 MNC Giants</div>
        </div>
        <div class="metric-card">
            <div class="metric-val" style="color: var(--accent-indigo);">$tier2Count</div>
            <div class="metric-label">Tier 2 VLSI Services</div>
        </div>
        <div class="metric-card">
            <div class="metric-val" style="color: var(--accent-green);">$confirmedEmailCount</div>
            <div class="metric-label">Verified HR Emails</div>
        </div>
    </div>

    <!-- My application progress (saved in this browser) -->
    <div class="progress-grid">
        <div class="metric-card">
            <div class="metric-val" id="pg-applied" style="color: var(--accent-cyan);">0</div>
            <div class="metric-label">Applied / Emailed</div>
        </div>
        <div class="metric-card">
            <div class="metric-val" id="pg-connected" style="color: #60a5fa;">0</div>
            <div class="metric-label">LinkedIn Connected</div>
        </div>
        <div class="metric-card">
            <div class="metric-val" id="pg-interview" style="color: var(--accent-green);">0</div>
            <div class="metric-label">Interviews / Offers</div>
        </div>
        <div class="metric-card">
            <div class="metric-val" id="pg-followup" style="color: var(--accent-amber);">0</div>
            <div class="metric-label">Follow-ups Due (7+ days)</div>
        </div>
        <div class="metric-card progress-actions">
            <button class="btn-ghost" onclick="exportProgress()">Export progress</button>
            <button class="btn-ghost" onclick="document.getElementById('importFile').click()">Import progress</button>
            <input type="file" id="importFile" accept=".json,application/json" style="display:none" onchange="importProgress(this)">
        </div>
    </div>

    <!-- LinkedIn 2026 Direct Networking & Feed Radar -->
    <div class="linkedin-command-hub">
        <div class="hub-header">
            <div>
                <div class="hub-title">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="#38bdf8"><path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/></svg>
                    LinkedIn 2026 Direct Outreach & Feed Radar
                </div>
                <div class="hub-subtitle">
                    Why career portals alone fail in 2026: Managers post on LinkedIn before roles reach portals. Connect directly with hiring managers, track live posts, and leverage your Amrita alumni network.
                </div>
            </div>
        </div>

        <div class="hub-nav">
            <button class="hub-tab-btn active" onclick="switchHubTab('hub-live-feed', this)">[Radar] 1-Click Live Feed Searches</button>
            <button class="hub-tab-btn" onclick="switchHubTab('hub-templates', this)">[Templates] Copy-Paste Outreach Messages</button>
            <button class="hub-tab-btn" onclick="switchHubTab('hub-playbook', this)">[Plan] 30-Day Networking Execution Plan</button>
        </div>

        <!-- Sub-Tab 1: Live Feed Searches -->
        <div id="hub-live-feed" class="hub-tab-content active">
            <div class="hub-quick-searches">
                <a href="https://www.linkedin.com/search/results/content/?keywords=hiring%20(%22Design%20Verification%22%20OR%20%22DV%20Engineer%22)%20(Bangalore%20OR%20Bengaluru%20OR%20Hyderabad)&sortBy=%22date_posted%22" target="_blank" rel="noopener" class="btn-quick-li highlight">
                    Hiring "Design Verification" Posts (BLR / HYD) &nearr;
                </a>
                <a href="https://www.linkedin.com/search/results/content/?keywords=hiring%20(%22RTL%22%20OR%20%22FPGA%22%20OR%20%22Vivado%22)%20(Bangalore%20OR%20Bengaluru%20OR%20Hyderabad)&sortBy=%22date_posted%22" target="_blank" rel="noopener" class="btn-quick-li">
                    Hiring "RTL / FPGA" Posts &nearr;
                </a>
                <a href="https://www.linkedin.com/search/results/content/?keywords=hiring%20(VLSI%20OR%20Semiconductor)%20(Fresher%20OR%20Trainee%20OR%20GET%20OR%20%220-1%20years%22)&sortBy=%22date_posted%22" target="_blank" rel="noopener" class="btn-quick-li">
                    VLSI Fresher / GET Posts (Latest) &nearr;
                </a>
                <a href="https://www.linkedin.com/school/amrita-vishwa-vidyapeetham/people/?keywords=semiconductor%20OR%20VLSI%20OR%20%22Design%20Verification%22" target="_blank" rel="noopener" class="btn-quick-li highlight">
                    Amrita Alumni in Semiconductors (Bengaluru Hubs) &nearr;
                </a>
                <a href="https://www.linkedin.com/search/results/people/?keywords=(%22Design%20Verification%22%20OR%20%22RTL%20Design%22)%20Manager%20(Bangalore%20OR%20Bengaluru)" target="_blank" rel="noopener" class="btn-quick-li">
                    DV & RTL Engineering Managers in Bengaluru &nearr;
                </a>
                <a href="https://www.linkedin.com/search/results/people/?keywords=(%22Technical%20Recruiter%22%20OR%20%22Talent%20Acquisition%22)%20(Semiconductor%20OR%20VLSI)%20Bangalore" target="_blank" rel="noopener" class="btn-quick-li">
                    Semiconductor Talent Acquisition / Recruiters &nearr;
                </a>
            </div>
        </div>

        <!-- Sub-Tab 2: Message Templates -->
        <div id="hub-templates" class="hub-tab-content">
            <div class="templates-grid">
                <!-- Card 1 -->
                <div class="template-card">
                    <div>
                        <div class="tpl-head">
                            <span class="tpl-title">1. Connection Note to Engineering Managers</span>
                            <span class="tpl-badge">&lt; 300 chars</span>
                        </div>
                        <div class="tpl-body" id="tpl-mgr">Hi [Name], I'm a final-year B.Tech ECE student at Amrita Bengaluru (CGPA 8.8) focusing on RTL Design & UVM Verification. I came across your engineering leadership in semiconductor design and would love to connect and learn from your updates.</div>
                    </div>
                    <button class="btn-copy-tpl" onclick="copyTpl('tpl-mgr', this)">Copy Note</button>
                </div>

                <!-- Card 2 -->
                <div class="template-card">
                    <div>
                        <div class="tpl-head">
                            <span class="tpl-title">2. Connection Note to Amrita Alumni</span>
                            <span class="tpl-badge">&lt; 300 chars</span>
                        </div>
                        <div class="tpl-body" id="tpl-alum">Hi [Name], I'm a final-year ECE student at Amrita Bengaluru targeting RTL & DV roles. As a fellow Amritian, I admire your work at [Company]. I'd love to connect, follow your updates, and seek any guidance for early-career semiconductor engineers!</div>
                    </div>
                    <button class="btn-copy-tpl" onclick="copyTpl('tpl-alum', this)">Copy Note</button>
                </div>

                <!-- Card 3 -->
                <div class="template-card">
                    <div>
                        <div class="tpl-head">
                            <span class="tpl-title">3. Connection Note to Recruiters / TA</span>
                            <span class="tpl-badge">&lt; 300 chars</span>
                        </div>
                        <div class="tpl-body" id="tpl-ta">Hi [Name], I'm a final-year B.Tech ECE student at Amrita Bengaluru (CGPA 8.8) specializing in SystemVerilog, UVM, and FPGA design. I'd love to connect regarding entry-level RTL/DV or hardware engineering opportunities at [Company].</div>
                    </div>
                    <button class="btn-copy-tpl" onclick="copyTpl('tpl-ta', this)">Copy Note</button>
                </div>

                <!-- Card 4 -->
                <div class="template-card" style="grid-column: 1 / -1;">
                    <div>
                        <div class="tpl-head">
                            <span class="tpl-title">4. Direct InMail / DM on a Hiring Post (When Manager posts "My team is hiring")</span>
                            <span class="tpl-badge">Direct Outreach</span>
                        </div>
                        <div class="tpl-body" id="tpl-direct" style="max-height: 200px;">Hi [Name],

I saw your recent post regarding the entry-level / junior opening in [RTL Design / Design Verification / FPGA] on your team.

I am a final-year B.Tech ECE student at Amrita Vishwa Vidyapeetham, Bengaluru (CGPA: 8.8 / 10), actively targeting pre-silicon design and verification roles.

Why my profile matches your team:
- Design Verification: SystemVerilog, SVA assertions, UVM testbench architecture (generator, driver, monitor, scoreboard), functional coverage & constrained-random verification.
- RTL & FPGA: Verilog/SystemVerilog, Basys-3 Artix-7 FPGA, Xilinx Vivado, AMBA APB/AXI-Lite, Low-Power 4-Bit ALU (48.8% power reduction), and Multi-User ATM Moore FSM (100% assertion pass rate).
- Embedded: Bare-metal C on LPC2148 ARM7 (interrupt-driven RTC, UART).

I have attached my resume for your review. Would you be open to considering me or guiding me on the best way to apply through your team?

Best regards,
Gudla Sohan | +91 XXXXXXXXXX | sohangudla04@gmail.com
Bengaluru & Hyderabad</div>
                    </div>
                    <button class="btn-copy-tpl" onclick="copyTpl('tpl-direct', this)">Copy Full Message</button>
                </div>

                <!-- Card 5 -->
                <div class="template-card" style="grid-column: 1 / -1;">
                    <div>
                        <div class="tpl-head">
                            <span class="tpl-title">5. Polite 4-Day Follow-Up Message</span>
                            <span class="tpl-badge">Follow-Up</span>
                        </div>
                        <div class="tpl-body" id="tpl-followup">Hi [Name], I hope you're having a great week! I just wanted to gently follow up on my earlier note regarding the [Role Name] opening on your team. I would love the opportunity to contribute my SystemVerilog/UVM and FPGA skills to your projects. Thank you again for your time!</div>
                    </div>
                    <button class="btn-copy-tpl" onclick="copyTpl('tpl-followup', this)">Copy Note</button>
                </div>
            </div>
        </div>

        <!-- Sub-Tab 3: 30-Day Plan -->
        <div id="hub-playbook" class="hub-tab-content">
            <div class="playbook-steps">
                <div class="step-box">
                    <div class="step-num">Week 1</div>
                    <div class="step-title">Profile Polish & Target List</div>
                    <div class="step-desc">Headline: "B.Tech ECE @ Amrita | RTL Design & UVM Verification | Artix-7 FPGA". Feature your Low-Power ALU and ATM FSM projects with GitHub links. Follow top 20 target companies.</div>
                </div>
                <div class="step-box">
                    <div class="step-num">Week 2</div>
                    <div class="step-title">10&ndash;15 Targeted Requests/Day</div>
                    <div class="step-desc">Target DV/RTL Engineering Managers, engineers 2&ndash;5 years ahead of you, and Amrita alumni. Always attach a tailored connection note (&lt;300 chars). Quality over quantity.</div>
                </div>
                <div class="step-box">
                    <div class="step-num">Week 3</div>
                    <div class="step-title">15 Mins/Day Feed Cultivation</div>
                    <div class="step-desc">Spend 15 mins commenting thoughtfully on engineering updates and reacting to hiring posts. Share 1 post about a concept you learned (e.g. SVA assertions or CDC clock sync).</div>
                </div>
                <div class="step-box">
                    <div class="step-num">Week 4</div>
                    <div class="step-title">Direct Outreach on Hiring Posts</div>
                    <div class="step-desc">Check "Hiring DV/RTL" posts every morning. When a manager posts, DM them immediately with your proof of work (Template 4) and resume. Follow up once after 4 days.</div>
                </div>
            </div>
        </div>
    </div>

    <div class="controls">
        <div class="tabs">
            <button class="tab-btn tab-blr active" onclick="filterCategory('blr', this)">Bengaluru [High Priority] ($blrCount)</button>
            <button class="tab-btn" onclick="filterCategory('all', this)">All Companies ($totalScanned)</button>
            <button class="tab-btn" onclick="filterCategory('hyd', this)">Hyderabad ($hydCount)</button>
            <button class="tab-btn" onclick="filterCategory('tier1', this)">Tier 1: MNC Giants ($tier1Count)</button>
            <button class="tab-btn" onclick="filterCategory('tier2', this)">Tier 2: VLSI Services ($tier2Count)</button>
            <button class="tab-btn" onclick="filterCategory('tier3', this)">Tier 3: Startups & DLI ($tier3Count)</button>
            <button class="tab-btn" onclick="filterCategory('entry', this)">Fresher / Entry Match ($directEntryCount)</button>
            <button class="tab-btn" onclick="filterCategory('rtldv', this)">RTL & DV ($rtlDvCount)</button>
            <button class="tab-btn" onclick="filterCategory('hasemail', this)">Email Apply ($emailCount, $confirmedEmailCount confirmed)</button>
        </div>
        <div class="filter-row">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search within active category (e.g. SiFive, Qualcomm, Verification, FPGA)..." oninput="searchTable()">
            </div>
            <select id="statusFilter" onchange="applyFilters()" aria-label="Filter by my status">
                <option value="any">Any status</option>
                <option value="none">Not started</option>
                <option value="applied">Applied</option>
                <option value="emailed">Emailed HR</option>
                <option value="connected">Connected on LinkedIn</option>
                <option value="interview">Interview</option>
                <option value="offer">Offer</option>
                <option value="rejected">Rejected</option>
                <option value="followup">Follow-up due</option>
            </select>
            <select id="sortSelect" onchange="setSort(this.value)" aria-label="Sort companies">
                <option value="score:desc">Sort: Best match</option>
                <option value="name:asc">Sort: Company A&ndash;Z</option>
                <option value="tier:asc">Sort: Tier 1 &rarr; 3</option>
                <option value="status:desc">Sort: My progress</option>
                <option value="date:desc">Sort: Recently updated</option>
            </select>
            <span class="result-count" id="resultCount"></span>
        </div>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th class="sortable" data-sort="name" onclick="headerSort('name')">Company & City</th>
                    <th class="sortable" data-sort="score" onclick="headerSort('score')">Tier & Match Score</th>
                    <th>Hiring Pathway & Details</th>
                    <th>Application Actions</th>
                    <th class="sortable" data-sort="status" onclick="headerSort('status')">My Status</th>
                </tr>
            </thead>
            <tbody id="jobTableBody">
                $htmlRows
            </tbody>
        </table>
    </div>

    <div class="footer">
        Generated automatically by Gudla Sohan's Daily Semiconductor Job Radar &bull; Configured for daily auto-runs
    </div>

    <script>
        function updateScanAge() {
            const el = document.getElementById('scanAge');
            if (!el || !el.dataset.scanned) return;
            const scannedDate = new Date(el.dataset.scanned);
            const now = new Date();
            const diffMs = now - scannedDate;
            const diffHours = Math.max(0, Math.floor(diffMs / 3600000));
            const hoursLabel = diffHours === 1 ? '1 hour' : diffHours + ' hours';
            el.textContent = 'Scanned ' + hoursLabel + ' ago';
            if (diffHours >= 26 || diffMs > 26 * 3600000) {
                el.style.color = '#f59e0b';
                el.style.fontWeight = '700';
            }
        }
        updateScanAge();

        function switchHubTab(tabId, btn) {
            document.querySelectorAll('.hub-tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.hub-tab-content').forEach(c => c.classList.remove('active'));
            btn.classList.add('active');
            const target = document.getElementById(tabId);
            if (target) { target.classList.add('active'); }
        }

        function copyTpl(elementId, btn) {
            const el = document.getElementById(elementId);
            if (!el) return;
            const text = el.innerText;
            navigator.clipboard.writeText(text).then(function() {
                const orig = btn.innerText;
                btn.innerText = String.fromCharCode(10003) + " Copied!";
                btn.style.background = "#10b981";
                btn.style.color = "#fff";
                btn.style.borderColor = "#10b981";
                setTimeout(function() {
                    btn.innerText = orig;
                    btn.style.background = "";
                    btn.style.color = "";
                    btn.style.borderColor = "";
                }, 2000);
            });
        }

        let currentCategory = 'blr';
        let sortKey = 'score';
        let sortDir = 'desc';

        const STORE_KEY = 'careerRadar.progress.v1';
        const FOLLOWUP_DAYS = 7;
        const STATUSES = [
            ['none', 'Not started'],
            ['applied', 'Applied'],
            ['emailed', 'Emailed HR'],
            ['connected', 'Connected on LinkedIn'],
            ['interview', 'Interview'],
            ['offer', 'Offer'],
            ['rejected', 'Rejected']
        ];
        // Order used when sorting by "My progress"
        const STATUS_RANK = { none: 0, rejected: 1, connected: 2, emailed: 3, applied: 4, interview: 5, offer: 6 };

        let progress = loadProgress();

        function loadProgress() {
            try { return JSON.parse(localStorage.getItem(STORE_KEY)) || {}; } catch (e) { return {}; }
        }

        function saveProgress() {
            try { localStorage.setItem(STORE_KEY, JSON.stringify(progress)); } catch (e) { /* storage blocked: progress stays for this visit only */ }
        }

        function todayISO() {
            const d = new Date();
            return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
        }

        function isFollowupDue(entry) {
            if (!entry || !entry.date || (entry.status !== 'applied' && entry.status !== 'emailed')) return false;
            const days = (Date.now() - new Date(entry.date + 'T00:00:00').getTime()) / 86400000;
            return days >= FOLLOWUP_DAYS;
        }

        function escapeAttr(s) {
            return String(s).replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;');
        }

        // Turn raw data-score values into a 0-100 match % relative to the best-scored company
        function normalizeScores(rows) {
            const max = Math.max.apply(null, rows.map(r => Number(r.dataset.score) || 0)) || 1;
            rows.forEach(r => {
                const raw = Number(r.dataset.score) || 0;
                const pill = r.querySelector('.score-pill');
                if (!pill) return;
                if (raw === 0) {
                    pill.textContent = 'Unscored';
                    pill.classList.add('unscored');
                    pill.title = 'Not enough data to score this company yet';
                    return;
                }
                const pct = Math.round(raw / max * 100);
                pill.textContent = 'Match: ' + pct + '%';
                pill.style.backgroundColor = pct >= 85 ? '#10b981' : pct >= 60 ? '#d97706' : '#ea580c';
            });
        }

        function buildStatusCell(row) {
            const name = row.dataset.name;
            const entry = progress[name] || {};
            const td = document.createElement('td');
            td.className = 'status-cell';
            const options = STATUSES.map(([v, label]) =>
                '<option value="' + v + '"' + ((entry.status || 'none') === v ? ' selected' : '') + '>' + label + '</option>').join('');
            td.innerHTML =
                '<div class="followup-flag">Follow-up due</div>' +
                '<select class="st-status" aria-label="My status for ' + escapeAttr(name) + '">' + options + '</select>' +
                '<label>Date</label><input type="date" class="st-date" value="' + escapeAttr(entry.date || '') + '">' +
                '<textarea class="st-notes" rows="1" placeholder="Notes (contact, referral, round...)">' + escapeAttr(entry.notes || '') + '</textarea>';
            row.appendChild(td);

            const statusEl = td.querySelector('.st-status');
            const dateEl = td.querySelector('.st-date');
            const notesEl = td.querySelector('.st-notes');
            const commit = function() {
                const status = statusEl.value;
                if (status !== 'none' && !dateEl.value) dateEl.value = todayISO();
                if (status === 'none' && !dateEl.value && !notesEl.value.trim()) {
                    delete progress[name];
                } else {
                    progress[name] = { status: status, date: dateEl.value, notes: notesEl.value, updated: Date.now() };
                }
                saveProgress();
                paintRow(row);
                updateProgressMetrics();
            };
            statusEl.addEventListener('change', function() { commit(); applyFilters(); });
            dateEl.addEventListener('change', function() { commit(); applyFilters(); });
            notesEl.addEventListener('change', commit);
        }

        function paintRow(row) {
            const entry = progress[row.dataset.name];
            row.dataset.status = (entry && entry.status) || 'none';
            row.classList.toggle('followup-due', isFollowupDue(entry));
        }

        function updateProgressMetrics() {
            const entries = Object.values(progress);
            const count = fn => entries.filter(fn).length;
            document.getElementById('pg-applied').textContent = count(e => e.status === 'applied' || e.status === 'emailed');
            document.getElementById('pg-connected').textContent = count(e => e.status === 'connected');
            document.getElementById('pg-interview').textContent = count(e => e.status === 'interview' || e.status === 'offer');
            document.getElementById('pg-followup').textContent = count(isFollowupDue);
        }

        function exportProgress() {
            const blob = new Blob([JSON.stringify(progress, null, 2)], { type: 'application/json' });
            const a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = 'career-radar-progress-' + todayISO() + '.json';
            a.click();
            setTimeout(() => URL.revokeObjectURL(a.href), 1000);
        }

        function importProgress(input) {
            const file = input.files && input.files[0];
            if (!file) return;
            const reader = new FileReader();
            reader.onload = function() {
                try {
                    const data = JSON.parse(reader.result);
                    if (typeof data !== 'object' || Array.isArray(data)) throw new Error('bad format');
                    progress = Object.assign(progress, data);
                    saveProgress();
                    location.reload();
                } catch (e) {
                    alert('Could not import: the file is not a Career Radar progress export.');
                }
            };
            reader.readAsText(file);
            input.value = '';
        }

        function tierOf(row) {
            return row.classList.contains('tier1') ? 1 : row.classList.contains('tier2') ? 2 : 3;
        }

        function compareRows(a, b) {
            const byName = a.dataset.name.localeCompare(b.dataset.name);
            let diff = 0;
            if (sortKey === 'score') diff = (Number(a.dataset.score) || 0) - (Number(b.dataset.score) || 0);
            else if (sortKey === 'name') diff = byName;
            else if (sortKey === 'tier') diff = tierOf(a) - tierOf(b);
            else if (sortKey === 'status') diff = STATUS_RANK[a.dataset.status] - STATUS_RANK[b.dataset.status];
            else if (sortKey === 'date') diff = ((progress[a.dataset.name] || {}).updated || 0) - ((progress[b.dataset.name] || {}).updated || 0);
            if (sortDir === 'desc') diff = -diff;
            return diff || (sortKey === 'name' ? 0 : (Number(b.dataset.score) || 0) - (Number(a.dataset.score) || 0)) || byName;
        }

        function sortRows() {
            const tbody = document.getElementById('jobTableBody');
            Array.from(tbody.querySelectorAll('.job-row')).sort(compareRows).forEach(r => tbody.appendChild(r));
            document.querySelectorAll('th.sortable').forEach(th => {
                th.classList.remove('sort-asc', 'sort-desc');
                if (th.dataset.sort === sortKey) th.classList.add(sortDir === 'asc' ? 'sort-asc' : 'sort-desc');
            });
            const sel = document.getElementById('sortSelect');
            const val = sortKey + ':' + sortDir;
            if (Array.from(sel.options).some(o => o.value === val)) sel.value = val;
        }

        function setSort(value) {
            const parts = value.split(':');
            sortKey = parts[0];
            sortDir = parts[1];
            sortRows();
            applyFilters();
        }

        function headerSort(key) {
            if (sortKey === key) {
                sortDir = sortDir === 'asc' ? 'desc' : 'asc';
            } else {
                sortKey = key;
                sortDir = key === 'name' ? 'asc' : 'desc';
            }
            sortRows();
            applyFilters();
        }

        document.addEventListener('DOMContentLoaded', function() {
            updateScanAge();
            const rows = Array.from(document.querySelectorAll('.job-row'));
            normalizeScores(rows);
            rows.forEach(r => {
                // Cache search text before the status controls are added
                r.dataset.search = r.innerText.toLowerCase();
                buildStatusCell(r);
                paintRow(r);
            });
            updateProgressMetrics();
            sortRows();
            const blrBtn = document.querySelector('.tab-blr');
            if (blrBtn) { filterCategory('blr', blrBtn); } else { applyFilters(); }
        });

        function filterCategory(category, btn) {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentCategory = category;
            applyFilters();
        }

        let searchTimer = null;
        function searchTable() {
            clearTimeout(searchTimer);
            searchTimer = setTimeout(applyFilters, 120);
        }

        function applyFilters() {
            const query = document.getElementById('searchInput').value.toLowerCase().trim();
            const statusFilter = document.getElementById('statusFilter').value;
            const rows = document.querySelectorAll('.job-row');
            let shown = 0;

            rows.forEach(r => {
                const matchesCategory = (currentCategory === 'all' || r.classList.contains(currentCategory));
                const matchesSearch = (!query || (r.dataset.search || '').includes(query));
                const matchesStatus = statusFilter === 'any'
                    || (statusFilter === 'followup' ? r.classList.contains('followup-due') : r.dataset.status === statusFilter);

                if (matchesCategory && matchesSearch && matchesStatus) {
                    r.style.display = '';
                    shown++;
                    // Rank = position in the current filtered, sorted list
                    r.querySelector('.td-rank').textContent = '#' + shown;
                } else {
                    r.style.display = 'none';
                }
            });
            document.getElementById('resultCount').textContent = 'Showing ' + shown + ' of ' + rows.length;
        }
    </script>
</body>
</html>
"@

[System.IO.File]::WriteAllText($reportPath, $htmlTemplate, (New-Object System.Text.UTF8Encoding $false))

# Toast notification
try {
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
    
    $toastXml = @"
<toast>
    <visual>
        <binding template="ToastGeneric">
            <text>Semiconductor Job Radar (Bengaluru & Hyderabad)</text>
            <text>Scan complete! Tracked $totalScanned companies ($blrCount in Bengaluru, $hydCount in Hyderabad).</text>
        </binding>
    </visual>
</toast>
"@
    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($toastXml)
    $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("SemiconductorJobRadar").Show($toast)
} catch {}

Write-Host " Dashboard generated at: $reportPath" -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
