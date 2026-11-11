$workspace = "c:\Users\admin\Downloads\companies list"
$dbPath = "$workspace\companies_db.json"
$csvPath = "$workspace\companies.csv"

$db = Get-Content $dbPath -Raw | ConvertFrom-Json

$newCompanies = @(
    @{
        Name = "Prodapt (Silicon & Semiconductor Services)"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Turnkey ASIC Design, SystemVerilog/UVM Verification, Analog Layout & Physical Design"
        Location = "Bengaluru (High Priority), Chennai"
        CareerUrl = "https://www.prodapt.com/careers/"
        FresherPath = "Graduate Engineer Trainee (GET) - Silicon Verification & Analog Layout"
        ContactEmail = "careers@prodapt.com"
    },
    @{
        Name = "UST (Semiconductor & VLSI Engineering)"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Pre-Silicon Verification (SV/UVM), Emulation, FPGA & Post-Silicon Validation (ex-SeviTech)"
        Location = "Bengaluru (High Priority), Hyderabad (Base City)"
        CareerUrl = "https://www.ust.com/en/careers"
        FresherPath = "Associate VLSI Design & Verification Engineer / Silicon Validation Trainee"
        ContactEmail = "careers@ust.com"
    },
    @{
        Name = "L&T Technology Services (LTTS - Semiconductor Practice)"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "RTL Design, SystemVerilog/UVM Testbench, FPGA Prototyping & Physical Design"
        Location = "Bengaluru (High Priority), Hyderabad (Base City), Mysore"
        CareerUrl = "https://www.ltts.com/careers"
        FresherPath = "Junior VLSI Design & Verification Engineer / Graduate Trainee"
        ContactEmail = "careers@ltts.com"
    },
    @{
        Name = "VVDN Technologies"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "FPGA Architecture (Xilinx Vivado Artix-7/Zynq), RTL Design, Board Bring-up & Embedded Firmware"
        Location = "Bengaluru (High Priority), Kochi, Gurugram, Chennai"
        CareerUrl = "https://www.vvdntech.com/careers"
        FresherPath = "Junior FPGA Design Engineer / Embedded Hardware Trainee"
        ContactEmail = "careers@vvdntech.com"
    },
    @{
        Name = "Sasken Technologies"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Silicon Platform Engineering, Modem/DSP Validation, Bare-Metal Drivers & System Testing"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://careers.sasken.com/"
        FresherPath = "Associate Software/Hardware Engineer - Silicon Platforms & Embedded Systems"
        ContactEmail = "careers@sasken.com"
    },
    @{
        Name = "Cientra Tech Solution"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "ASIC/SoC Design, SystemVerilog/UVM Verification, FPGA Emulation & Analog Custom Layout"
        Location = "Bengaluru (High Priority), Noida"
        CareerUrl = "https://www.cientra.com/careers"
        FresherPath = "Trainee Verification Engineer / Junior ASIC RTL Designer"
        ContactEmail = "careers@cientra.com"
    },
    @{
        Name = "QpiAI (QpiSemi - Silicon & AI/Quantum Processors)"
        Tier = "Tier 3: Startups & DLI Scheme Ecosystem"
        Domain = "Indigenous AI Accelerators, RISC-V Custom Processors, Cryogenic Silicon & Quantum Chip Design"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://qpiai.tech/careers"
        FresherPath = "Silicon Architecture Intern / Junior VLSI Design Engineer"
        ContactEmail = "careers@qpiai.tech"
    },
    @{
        Name = "Aheesa Digital Innovations"
        Tier = "Tier 3: Startups & DLI Scheme Ecosystem"
        Domain = "MeitY DLI Approved, VEGA RISC-V Processor-based GPON ONT & Network Silicon SoCs"
        Location = "Bengaluru (High Priority), Chennai"
        CareerUrl = "https://www.aheesa.com/careers"
        FresherPath = "RISC-V SoC Architecture & Verification Trainee"
        ContactEmail = "careers@aheesa.com"
    },
    @{
        Name = "DV2JS Innovation"
        Tier = "Tier 3: Startups & DLI Scheme Ecosystem"
        Domain = "MeitY DLI Approved, Low-Light CMOS Image Sensor ASICs & Digital Readout ICs"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://dv2js.com/"
        FresherPath = "Junior Digital IC Design & Verification Trainee"
        ContactEmail = "contact@dv2js.com"
    },
    @{
        Name = "Suchi Semicon"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "India's Pioneer Commercial OSAT, Advanced IC Packaging & Automated Test Equipment (ATE)"
        Location = "Surat, Gujarat"
        CareerUrl = "https://suchisemicon.com/"
        FresherPath = "Graduate Trainee - Semiconductor Packaging & Test Engineering"
        ContactEmail = "info@suchisemicon.com"
    },
    @{
        Name = "Happiest Minds Technologies (Product Engineering / VLSI)"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "ASIC/SoC Verification (UVM), FPGA Prototyping, Emulation & Embedded Firmware"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://jobs.happiestminds.com/"
        FresherPath = "Trainee Engineer - ASIC Verification & FPGA Prototyping"
        ContactEmail = "careers@happiestminds.com"
    },
    @{
        Name = "Mindteck"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Semiconductor Equipment Software, ATE Test Automation & Embedded Microcontroller Firmware"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.mindteck.com/careers/"
        FresherPath = "Associate Software/Hardware Engineer - Semiconductor Equipment & Embedded"
        ContactEmail = "info@mindteck.com"
    },
    @{
        Name = "RRP Electronics"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "Semiconductor OSAT & ATMP Packaging Facility, Silicon Module Assembly & Quality Testing"
        Location = "Navi Mumbai, Maharashtra"
        CareerUrl = "https://rrpelectronics.com/"
        FresherPath = "Semiconductor Quality & Packaging Test Trainee"
        ContactEmail = "careers@rrpelectronics.com"
    },
    @{
        Name = "Sankhya Technologies"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "SystemC ESL Synthesis, Pre-Silicon Virtual Platforms, RISC-V Processor Co-Simulation"
        Location = "Chennai, Bengaluru (High Priority)"
        CareerUrl = "https://www.sankhya.com/"
        FresherPath = "Project Trainee - EDA Tools, SystemC & RISC-V Simulation"
        ContactEmail = "careers@sankhya.com"
    }
)

$combined = @()
$combined += $db

foreach ($item in $newCompanies) {
    $existing = $combined | Where-Object { $_.Name.ToLower().Trim() -eq $item.Name.ToLower().Trim() }
    if (-not $existing) {
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
        Write-Output "Added: $($item.Name)"
    } else {
        Write-Output "Already exists: $($item.Name)"
    }
}

# Re-number SNo sequentially
$snoCounter = 1
foreach ($c in $combined) {
    $c.SNo = $snoCounter++
}

Write-Output "Total companies after batch addition: $($combined.Count)"

$combined | ConvertTo-Json -Depth 4 | Set-Content $dbPath -Encoding UTF8
$combined | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

Write-Output "Database updated successfully at $dbPath and $csvPath!"
