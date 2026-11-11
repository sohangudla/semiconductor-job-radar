$workspace = "c:\Users\admin\Downloads\companies list"
$db = Get-Content "$workspace\companies_db.json" -Raw | ConvertFrom-Json

$newIndianCompanies = @(
    @{
        Name = "SmartSoC Solutions"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Turnkey SoC Design, RTL Synthesis, UVM Verification & FPGA Emulation"
        Location = "Bengaluru (High Priority), Hyderabad"
        CareerUrl = "https://smartsocs.com/careers/"
        FresherPath = "Design Verification (DV) Trainee / Associate VLSI Engineer"
        ContactEmail = "careers@smartsocs.com"
    },
    @{
        Name = "Aura Semiconductor"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "High-Performance Clocking, Timing ICs, RF & Mixed-Signal Silicon"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://aurasemi.com/careers/"
        FresherPath = "Digital IC Verification Engineer / Mixed-Signal Design Trainee"
        ContactEmail = "careers@aurasemi.com"
    },
    @{
        Name = "CoreEL Technologies"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "RTL Design, FPGA Systems (Xilinx Artix/Kintex), Defense & Radar SoC"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://coreel.com/careers/"
        FresherPath = "Trainee Engineer - FPGA Implementation & SystemVerilog DV"
        ContactEmail = "careers@coreel.com"
    },
    @{
        Name = "Whizchip Design Technologies"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "ASIC Design, Functional Verification (SV/UVM), Physical Design"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.whizchip.com/careers"
        FresherPath = "Junior Verification Engineer / VLSI Trainee"
        ContactEmail = "careers@whizchip.com"
    },
    @{
        Name = "CircuitSutra Technologies"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "ESL, SystemC Virtual Platforms, RTL-to-Software Co-Verification & SoC"
        Location = "Bengaluru (High Priority), Noida"
        CareerUrl = "https://www.circuitsutra.com/careers"
        FresherPath = "Trainee Engineer - ESL & Pre-Silicon SoC Verification"
        ContactEmail = "careers@circuitsutra.com"
    },
    @{
        Name = "Tata Electronics (TSAT / Tata Semi)"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "Semiconductor Fab, Advanced Packaging (ATMP/OSAT) & Silicon Design"
        Location = "Bengaluru (High Priority), Hosur, Dholera"
        CareerUrl = "https://www.tataelectronics.com/careers"
        FresherPath = "Graduate Engineer Trainee (GET) - Semiconductor Engineering"
        ContactEmail = "careers@tataelectronics.com"
    },
    @{
        Name = "AGNIT Semiconductors"
        Tier = "Tier 3: Startups & DLI Scheme Ecosystem"
        Domain = "GaN (Gallium Nitride) Power & High-Frequency RF Semiconductor Devices"
        Location = "Bengaluru (High Priority - IISc Campus)"
        CareerUrl = "https://agnitsemi.com/"
        FresherPath = "Semiconductor Device & Hardware Design Trainee"
        ContactEmail = "contact@agnitsemi.com"
    },
    @{
        Name = "Quest Global (Semiconductor Practice)"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Turnkey ASIC Design, Pre-Silicon Verification, FPGA & Embedded Systems"
        Location = "Bengaluru (High Priority), Hyderabad, Trivandrum"
        CareerUrl = "https://www.quest-global.com/careers/"
        FresherPath = "Associate Engineer - VLSI & Embedded Practice"
        ContactEmail = "careers@quest-global.com"
    },
    @{
        Name = "Silicon Interfaces"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Verification IP (VIP), SystemVerilog/UVM, USB/PCIe/Ethernet Controllers"
        Location = "Mumbai, Bengaluru (High Priority)"
        CareerUrl = "https://www.siliconinterfaces.com/careers.html"
        FresherPath = "Junior Verification IP Design Engineer"
        ContactEmail = "jobs@siliconinterfaces.com"
    },
    @{
        Name = "Steradian Semiconductors (Renesas)"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "4D Millimeter-Wave Imaging Radar Transceivers & Automotive SoCs"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.renesas.com/careers"
        FresherPath = "Radar Digital Design & Verification Trainee"
        ContactEmail = "careers@steradiansemi.com"
    },
    @{
        Name = "C-DAC (VEGA Processor / Hardware Design)"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Indigenous RISC-V Processors (VEGA 64-bit), SoC IP & High-Performance ASIC"
        Location = "Bengaluru (High Priority), Hyderabad, Pune"
        CareerUrl = "https://cdac.in/index.aspx?id=career"
        FresherPath = "Project Engineer - RISC-V SoC Architecture & Digital Verification"
        ContactEmail = "recruitment@cdac.in"
    },
    @{
        Name = "Kaynes Semicon"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "OSAT, Silicon Packaging, Testing & Multi-Chip Modules"
        Location = "Bengaluru (High Priority), Sanand, Mysore"
        CareerUrl = "https://www.kaynestechnology.net/careers/"
        FresherPath = "Graduate Trainee - Semiconductor Packaging & Test"
        ContactEmail = "careers@kaynestechnology.net"
    },
    @{
        Name = "Sahasra Semiconductors"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Memory IC Packaging, MicroSD/NAND Assembly & Semiconductor Hardware"
        Location = "Noida, Bhiwadi"
        CareerUrl = "https://sahasrasemi.com/careers/"
        FresherPath = "Trainee Engineer - Silicon Packaging & Testing"
        ContactEmail = "careers@sahasrasemi.com"
    },
    @{
        Name = "SCL (Semi-Conductor Laboratory)"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "180nm CMOS Wafer Fab, Space-Grade ASICs & Microelectronics"
        Location = "Mohali, Bengaluru (High Priority)"
        CareerUrl = "https://www.scl.gov.in/careers.html"
        FresherPath = "Scientist/Engineer 'SC' - VLSI Design & Verification"
        ContactEmail = "recruitment@scl.gov.in"
    },
    @{
        Name = "Chiptest Engineering"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Automated Test Equipment (ATE), DFT, Pre/Post-Silicon Validation"
        Location = "Chennai, Bengaluru (High Priority)"
        CareerUrl = "https://chiptest.in/careers/"
        FresherPath = "VLSI Test & Validation Trainee"
        ContactEmail = "careers@chiptest.in"
    }
)

$combined = @()
$combined += $db
foreach ($n in $newIndianCompanies) {
    # Check if name already exists
    $found = $db | Where-Object { $_.Name.ToLower().Trim() -eq $n.Name.ToLower().Trim() }
    if (-not $found) {
        $combined += [PSCustomObject]@{
            SNo = 0
            Name = $n.Name
            Tier = $n.Tier
            Domain = $n.Domain
            Location = $n.Location
            BaseUrl = $n.CareerUrl
            CareerUrl = $n.CareerUrl
            FresherPath = $n.FresherPath
            ContactEmail = $n.ContactEmail
        }
    }
}

# Re-index
$counter = 1
foreach ($c in $combined) {
    $c.SNo = $counter++
}

Write-Output "Total companies after adding 15 new Indian companies: $($combined.Count)"
$combined | ConvertTo-Json -Depth 4 | Set-Content "$workspace\companies_db.json" -Encoding UTF8
$combined | Export-Csv -Path "$workspace\companies.csv" -NoTypeInformation -Encoding UTF8
Write-Output "companies_db.json and companies.csv updated successfully!"