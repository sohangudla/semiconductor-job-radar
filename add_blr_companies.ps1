$workspace = "c:\Users\admin\Downloads\companies list"
$db = Get-Content "$workspace\companies_db.json" -Raw | ConvertFrom-Json

$newBlrCompanies = @(
    @{
        Name = "SiFive"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "RISC-V Processor Cores, Core Verification & SoC Architecture"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://boards.greenhouse.io/sifive"
        FresherPath = "Associate CPU Verification Engineer / RTL Design Intern (Bengaluru R&D)"
        ContactEmail = "careers@sifive.com"
    },
    @{
        Name = "Lattice Semiconductor"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "Low-Power FPGA (iCE40, Certus-NX), FPGA Tools & Digital Design"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.latticesemi.com/about/careers"
        FresherPath = "Junior FPGA Applications / Digital Verification Engineer"
        ContactEmail = ""
    },
    @{
        Name = "Tenstorrent"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "RISC-V High-Performance AI Compute & Chiplet Architecture"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://boards.greenhouse.io/tenstorrent"
        FresherPath = "Hardware Design Engineer 1 / Silicon Verification Intern (Bengaluru Center)"
        ContactEmail = ""
    },
    @{
        Name = "Achronix Semiconductor"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "Speedster7t High-End FPGAs & Speedcore eFPGA IP, PCIe Gen5"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.achronix.com/careers"
        FresherPath = "FPGA Verification & Emulation Engineer Trainee"
        ContactEmail = "careers@achronix.com"
    },
    @{
        Name = "EdgeQ"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "5G Baseband & AI Processor on a Single RISC-V SoC"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://edgeq.io/careers/"
        FresherPath = "ASIC Verification Engineer / RTL Trainee (Bengaluru R&D)"
        ContactEmail = "careers@edgeq.io"
    },
    @{
        Name = "Alphawave Semi"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "High-Speed Connectivity IP (112G/224G SerDes, PCIe, CXL Chiplets)"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://awavesemi.com/careers/"
        FresherPath = "Silicon Verification Engineer 1 / Pre-Silicon DV Trainee"
        ContactEmail = "careers@awavesemi.com"
    },
    @{
        Name = "MaxLinear"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "Broadband, RF, Mixed-Signal & Ethernet PHY/Switch ASICs"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.maxlinear.com/about/careers"
        FresherPath = "Digital IC Design & Verification Engineer (Bengaluru)"
        ContactEmail = ""
    },
    @{
        Name = "Synaptics"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "Edge AI Silicon, Display Driver ICs (DDIC) & Wireless IoT SoCs"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.synaptics.com/careers"
        FresherPath = "Associate Digital Design Engineer - SoC DV"
        ContactEmail = ""
    },
    @{
        Name = "Applied Materials"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "Semiconductor Equipment, Nanotechnology & Hardware Silicon Systems"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.appliedmaterials.com/us/en/careers.html"
        FresherPath = "College Graduate Trainee / Hardware Systems Engineer (Whitefield)"
        ContactEmail = ""
    },
    @{
        Name = "Ampere Computing"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "Cloud Native ARM Server Microprocessors (Ampere Altra / One)"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://amperecomputing.com/careers"
        FresherPath = "Silicon Verification Engineer / Logic Design Trainee"
        ContactEmail = ""
    },
    @{
        Name = "Ceva (CEVA DSP)"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "DSP Cores, Wireless IP (Wi-Fi, Bluetooth, 5G), NeuPro Edge AI"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.ceva-dsp.com/careers/"
        FresherPath = "Core Verification Engineer Trainee / ASIC Design"
        ContactEmail = "jobs-india@ceva-dsp.com"
    },
    @{
        Name = "Allegro MicroSystems"
        Tier = "Tier 1: Global Product & EDA Giants"
        Domain = "Magnetic Sensor ICs, Power ICs & Automotive Microelectronics"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://www.allegromicro.com/en/about-allegro/careers"
        FresherPath = "Digital IC Verification Engineer Trainee"
        ContactEmail = ""
    },
    @{
        Name = "Invecas"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        Domain = "ASIC Design Solutions, Advanced Packaging & High-Speed Interface IP"
        Location = "Bengaluru (High Priority), Hyderabad"
        CareerUrl = "https://invecas.com/careers/"
        FresherPath = "Junior ASIC Design & DV Engineer"
        ContactEmail = "careers@invecas.com"
    },
    @{
        Name = "DreamBig Semiconductor"
        Tier = "Tier 3: Startups & DLI Scheme Ecosystem"
        Domain = "Chiplet Architecture, SmartNIC & DPU Accelerators"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://dreambigsemi.com/careers/"
        FresherPath = "Hardware & Verification Engineer Trainee"
        ContactEmail = "careers@dreambigsemi.com"
    },
    @{
        Name = "Untether AI"
        Tier = "Tier 3: Startups & DLI Scheme Ecosystem"
        Domain = "At-Memory Compute Architecture for Neural Networks & Edge AI"
        Location = "Bengaluru (High Priority)"
        CareerUrl = "https://untether.ai/careers/"
        FresherPath = "Silicon Design & Verification Engineer 1"
        ContactEmail = "careers@untether.ai"
    }
)

# Update existing companies to tag Bengaluru as High Priority
foreach ($c in $db) {
    if ($c.Location -match "(Bengaluru|Bangalore|Blr)" -and -not ($c.Location -like "*(High Priority)*")) {
        $c.Location = $c.Location.Replace("Bengaluru", "Bengaluru (High Priority)").Replace("Bangalore", "Bengaluru (High Priority)")
    }
}

# Add the new ones
$combined = @()
$combined += $db
foreach ($n in $newBlrCompanies) {
    $combined += [PSCustomObject]@{
        SNo = 0 # Will reindex
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

# Re-index SNo
$counter = 1
foreach ($c in $combined) {
    $c.SNo = $counter++
}

Write-Output "Total companies after adding Bengaluru powerhouses: $($combined.Count)"
$combined | ConvertTo-Json -Depth 4 | Set-Content "$workspace\companies_db.json" -Encoding UTF8
$combined | Export-Csv -Path "$workspace\companies.csv" -NoTypeInformation -Encoding UTF8
Write-Output "companies_db.json and companies.csv updated successfully!"