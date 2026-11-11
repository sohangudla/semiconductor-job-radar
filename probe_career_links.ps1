[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$companies = Get-Content "c:\Users\admin\Downloads\companies list\companies.json" -Raw | ConvertFrom-Json

$careerPaths = @(
    "/careers",
    "/career",
    "/careers/",
    "/career/",
    "/jobs",
    "/jobs/",
    "/job-openings",
    "/join-us",
    "/work-with-us",
    "/current-openings"
)

$results = @()

function Test-Url($url) {
    try {
        $req = [System.Net.HttpWebRequest]::Create($url)
        $req.Timeout = 6000
        $req.ReadWriteTimeout = 6000
        $req.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        $req.AllowAutoRedirect = $true
        $req.MaximumAutomaticRedirections = 3
        $resp = $req.GetResponse()
        $statusCode = [int]$resp.StatusCode
        $finalUrl = $resp.ResponseUri.AbsoluteUri
        $stream = $resp.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        $html = $reader.ReadToEnd()
        $reader.Close()
        $stream.Close()
        $resp.Close()
        return @{ Success = $true; StatusCode = $statusCode; FinalUrl = $finalUrl; Html = $html }
    } catch {
        return @{ Success = $false; Error = $_.Exception.Message }
    }
}

Write-Output "Starting probe for 102 companies..."
$count = 0
foreach ($c in $companies) {
    $count++
    $cleanBase = $c.Url.Trim().TrimEnd('/')
    Write-Output "[$count/102] Testing $($c.Name)..."
    
    $foundCareerUrl = $null
    $careerHtml = $null
    
    # 1. First test base URL
    $baseRes = Test-Url $cleanBase
    if ($baseRes.Success) {
        # Check if homepage contains career link
        $pattern = 'href=["'']([^"'']*(?:career|job|join|opening|work-with)[^"'']*)["'']'
        $matches = [regex]::Matches($baseRes.Html, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($matches.Count -gt 0) {
            $link = $matches[0].Groups[1].Value.Trim()
            if ($link -match '^https?://') {
                $foundCareerUrl = $link
            } elseif ($link -match '^/') {
                $uri = New-Object System.Uri($baseRes.FinalUrl)
                $foundCareerUrl = "$($uri.Scheme)://$($uri.Authority)$link"
            } elseif (-not [string]::IsNullOrWhiteSpace($link) -and -not ($link.StartsWith('#'))) {
                $foundCareerUrl = "$cleanBase/$link"
            }
        }
    }
    
    # 2. If not found in HTML, test common paths
    if (-not $foundCareerUrl) {
        foreach ($p in $careerPaths) {
            $candidate = "$cleanBase$p"
            $pRes = Test-Url $candidate
            if ($pRes.Success -and $pRes.StatusCode -eq 200 -and -not ($pRes.FinalUrl -match '(login|error|404)')) {
                $foundCareerUrl = $pRes.FinalUrl
                $careerHtml = $pRes.Html
                break
            }
        }
    }
    
    $results += [PSCustomObject]@{
        SNo = $c.SNo
        Name = $c.Name
        BaseUrl = $c.Url
        CareerUrl = if ($foundCareerUrl) { $foundCareerUrl } else { $c.Url }
        Status = if ($foundCareerUrl) { "CareerPageFound" } elseif ($baseRes.Success) { "BaseReachable" } else { "Unreachable" }
    }
}

$results | ConvertTo-Json -Depth 3 | Set-Content "c:\Users\admin\Downloads\companies list\companies_career_links.json" -Encoding UTF8
Write-Output "Probe complete! Results saved."
