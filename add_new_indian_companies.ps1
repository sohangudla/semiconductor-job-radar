# Script to add the newly identified Indian semiconductor companies and re-index
$workspace = "c:\Users\admin\Downloads\companies list"
$db = Get-Content "$workspace\companies_db.json" -Raw | ConvertFrom-Json

$newIndianCompanies = @(
    @{
        Name = "Soctronics"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Turnkey ASIC/SoC Design, Pre-Silicon Verification (SV/UVM), FPGA & Physical Design"
        Location = "Hyderabad (Base City)"
        CareerUrl = "https://www.soctronics.com/careers.html"
        FresherPath = "VLSI Trainee Engineer / Fresher DV & RTL Design (Hyderabad Campus & Off-Campus)"
        ContactEmail = "careers@soctronics.com"
    },
    @{
        Name = "InSemi Technology (An Infosys Company)"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "ASIC/SoC Design, SystemVerilog/UVM Verification, Emulation & Embedded Firmware"
        Location = "Bengaluru (High Priority), Hyderabad"
        CareerUrl = "https://insemitech.com/careers/"
        FresherPath = "Associate Engineer - Verification & RTL Design (Bengaluru / Hyderabad)"
        ContactEmail = "careers@insemitech.com"
    },
    @{
        Name = "Samsung Semiconductor India Research (SSIR)"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "Exynos Mobile SoCs, High-Speed Memory Controllers, Image Sensor ISP & Pre-Silicon DV"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://research.samsung.com/ssir"
        FresherPath = "Campus Graduate Engineer Trainee - Logic Design & Functional Verification"
        ContactEmail = ""
    },
    @{
        Name = "Baya Systems"
        Tier = "Tier 3: Startups & DLI Scheme Ecosystem"
        Domain = "Next-Gen SoC Data Fabric, Cache Coherence Architecture & Chiplet Interconnects"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.bayasystems.com/careers"
        FresherPath = "Hardware Verification Engineer / RTL Architecture Trainee"
        ContactEmail = "careers@bayasystems.com"
    },
    @{
        Name = "Black Pepper Technologies"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "End-to-End Silicon Design, SystemVerilog/UVM Verification, FPGA & Physical Design"
        Location = "Bengaluru (High Priority), Hyderabad"
        CareerUrl = "https://www.blackpeppertech.com/careers.html"
        FresherPath = "Graduate Engineer Trainee (GET) - Silicon Design & Verification"
        ContactEmail = "careers@blackpeppertech.com"
    },
    @{
        Name = "Cirel Systems"
        Tier = "Tier 3: Startups & DLI Scheme Ecosystem"
        Domain = "Custom Mixed-Signal ASICs, Power Management ICs (PMIC) & Digital Control Logic"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.cirelsystems.com/careers/"
        FresherPath = "Junior Digital Design & Verification Engineer"
        ContactEmail = "careers@cirelsystems.com"
    },
    @{
        Name = "Si2chip Technologies"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "ASIC/SoC Design, Digital RTL, Functional Verification, FPGA & Synthesis"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://si2chip.com/careers/"
        FresherPath = "VLSI Verification Engineer Trainee (SystemVerilog / UVM)"
        ContactEmail = "careers@si2chip.com"
    },
    @{
        Name = "SiliConch Systems"
        Tier = "Tier 3: Startups & DLI Scheme Ecosystem"
        Domain = "High-Speed USB PHY IP, Mixed-Signal ASICs & Power Management Controllers"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.siliconch.com/careers"
        FresherPath = "Design Verification Engineer Trainee / Digital RTL Design"
        ContactEmail = "careers@siliconch.com"
    },
    @{
        Name = "CG Semi (Murugappa Group / Renesas JV)"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "Semiconductor Assembly, Testing, Packaging & Automotive Semiconductor Solutions"
        Location = "Bengaluru (High Priority), Sanand"
        CareerUrl = "https://www.cgpower.com/"
        FresherPath = "Graduate Engineer Trainee - Semiconductor Operations & Engineering"
        ContactEmail = "contact@cgpower.com"
    },
    @{
        Name = "Polymatech Electronics"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Indigenous Opto-Semiconductor Chip Design, Manufacturing & Advanced Packaging"
        Location = "Chennai, Bengaluru (High Priority)"
        CareerUrl = "https://www.polymatech.in/careers"
        FresherPath = "Graduate Trainee Engineer - Semiconductor Design & Testing"
        ContactEmail = "careers@polymatech.in"
    },
    @{
        Name = "Trident Techlabs"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "ASIC/FPGA Design Services, EDA Tools Integration & Embedded Systems"
        Location = "Bengaluru (High Priority), New Delhi, Pune"
        CareerUrl = "https://www.tridenttechlabs.com/careers"
        FresherPath = "Junior FPGA / ASIC Engineer Trainee"
        ContactEmail = "careers@tridenttechlabs.com"
    },
    @{
        Name = "Continental Device India (CDIL)"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Pioneer Semiconductor Device Manufacturing, Discrete Silicon & Power Modules"
        Location = "New Delhi, Mohali, Bengaluru (High Priority)"
        CareerUrl = "https://www.cdil.com/careers"
        FresherPath = "Graduate Trainee Engineer - Semiconductor Device Engineering"
        ContactEmail = "careers@cdil.com"
    }
)

$combined = @()
$combined += $db

foreach ($item in $newIndianCompanies) {
    # Check if company already exists
    $found = $combined | Where-Object { $_.Name -eq $item.Name }
    if (-not $found) {
        $combined += [PSCustomObject]@{
            SNo = 0
            Name = $item.Name
            Tier = $item.Tier
            Domain = $item.Domain
            Location = $item.Location
            BaseUrl = $item.CareerUrl
            CareerUrl = $item.CareerUrl
            FresherPath = $item.FresherPath
            ContactEmail = $item.ContactEmail
        }
    }
}

# Re-index
$counter = 1
foreach ($c in $combined) {
    $c.SNo = $counter++
}

Write-Output "Total companies after adding new Indian semiconductor powerhouses: $($combined.Count)"
$combined | ConvertTo-Json -Depth 4 | Set-Content "$workspace\companies_db.json" -Encoding UTF8
$combined | Export-Csv -Path "$workspace\companies.csv" -NoTypeInformation -Encoding UTF8
Write-Output "Updated companies_db.json and companies.csv successfully!"
