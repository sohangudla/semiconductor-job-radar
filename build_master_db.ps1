$workspace = "c:\Users\admin\Downloads\companies list"
$existingDli = Get-Content "$workspace\companies_db.json" -Raw | ConvertFrom-Json

$tier1MNCs = @(
    @{
        Name = "NVIDIA"
        Domain = "GPU Architecture, AI Accelerators & DPU"
        Location = "Hyderabad, Bengaluru, Pune"
        CareerUrl = "https://nvidia.wd5.myworkdayjobs.com/NVIDIAExternalCareerSite?locationCountry=bc33aa3152ec42d4995f4791a106ed09"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "University Recruiting / New College Graduate (NCG) & Hardware Internships"
        ContactEmail = ""
    },
    @{
        Name = "Qualcomm"
        Domain = "Snapdragon Mobile SoC, 5G Modem, DSP & Automotive"
        Location = "Hyderabad, Bengaluru, Chennai, Noida"
        CareerUrl = "https://qualcomm.wd5.myworkdayjobs.com/External?locationCountry=bc33aa3152ec42d4995f4791a106ed09"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Associate Engineer (RTL / DV / Hardware), Campus & Off-Campus in Hyderabad"
        ContactEmail = ""
    },
    @{
        Name = "AMD"
        Domain = "Ryzen/EPYC CPUs, Radeon GPUs, Xilinx FPGA & Adaptive SoC"
        Location = "Hyderabad, Bengaluru"
        CareerUrl = "https://careers.amd.com/careers-home/jobs?keywords=&locations=India"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Design Engineer 1, Co-op/Intern, FPGA & Verification roles (Hyderabad R&D Center)"
        ContactEmail = ""
    },
    @{
        Name = "Intel"
        Domain = "Core/Xeon Processors, ASIC, Pre-Silicon DV & Logic Design"
        Location = "Bengaluru, Hyderabad"
        CareerUrl = "https://jobs.intel.com/en/search-jobs/India/599/2/1269750/20/77/50/2"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Graduate Trainee, College Graduate (CG) - Logic Design & Pre-Silicon Verification"
        ContactEmail = ""
    },
    @{
        Name = "Texas Instruments (TI)"
        Domain = "Analog & Embedded Processing, Microcontrollers & PMIC"
        Location = "Bengaluru"
        CareerUrl = "https://careers.ti.com/search-jobs/?location=India"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Digital Design Engineer, Design Verification Engineer, Campus & Off-Campus Trainees"
        ContactEmail = ""
    },
    @{
        Name = "Broadcom"
        Domain = "Networking Switch ASICs (Tomahawk/Jericho), Wireless & Storage"
        Location = "Bengaluru, Hyderabad"
        CareerUrl = "https://broadcom.wd1.myworkdayjobs.com/External_Career"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "ASIC Verification Engineer 1, Hardware Internships"
        ContactEmail = ""
    },
    @{
        Name = "MediaTek"
        Domain = "Dimensity 5G/4G SoCs, Connectivity & Edge AI Processors"
        Location = "Bengaluru, Noida"
        CareerUrl = "https://careers.mediatek.com/"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Engineer - IC Design, Pre-Silicon Verification, Firmware"
        ContactEmail = ""
    },
    @{
        Name = "NXP Semiconductors"
        Domain = "Automotive Microcontrollers (S32), Secure Connectivity & RFID"
        Location = "Noida, Bengaluru, Hyderabad"
        CareerUrl = "https://nxp.wd3.myworkdayjobs.com/careers?locationCountry=bc33aa3152ec42d4995f4791a106ed09"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Graduate Trainee Engineer (GTE), Digital Verification Intern"
        ContactEmail = ""
    },
    @{
        Name = "Marvell Technology"
        Domain = "Data Infrastructure Silicon, Custom ASIC, OCTEON SoC & Storage"
        Location = "Pune, Bengaluru, Hyderabad"
        CareerUrl = "https://marvell.wd1.myworkdayjobs.com/MarvellCareers"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Engineer 1 - ASIC Verification / Digital Design (Hyderabad Knowledge City)"
        ContactEmail = ""
    },
    @{
        Name = "Microchip Technology"
        Domain = "PIC/AVR Microcontrollers, PolarFire FPGA & Mixed-Signal"
        Location = "Bengaluru, Chennai, Hyderabad"
        CareerUrl = "https://careers.microchip.com/"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Associate Engineer - Digital Design & Verification, Embedded C Firmware"
        ContactEmail = ""
    },
    @{
        Name = "Analog Devices (ADI)"
        Domain = "Precision Analog, High-Speed ADC/DAC, DSP & Mixed-Signal"
        Location = "Bengaluru, Hyderabad"
        CareerUrl = "https://analogdevices.wd1.myworkdayjobs.com/External"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Digital Design Engineer 1, Product Applications Engineer"
        ContactEmail = ""
    },
    @{
        Name = "STMicroelectronics"
        Domain = "STM32 Microcontrollers, MEMS Sensors & Power Silicon"
        Location = "Greater Noida, Bengaluru"
        CareerUrl = "https://stcareers.st.com/"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Junior Design Engineer, Embedded Firmware Trainee"
        ContactEmail = ""
    },
    @{
        Name = "Infineon Technologies"
        Domain = "Automotive Microcontrollers (AURIX), Power Semiconductors & IoT"
        Location = "Bengaluru"
        CareerUrl = "https://www.infineon.com/cms/en/careers/jobsearch/jobsearch/#!country=India"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Trainee Engineer - Verification / Digital Design"
        ContactEmail = ""
    },
    @{
        Name = "Micron Technology"
        Domain = "DRAM, NAND Flash, HBM3e Memory & Storage Controllers"
        Location = "Hyderabad, Bengaluru"
        CareerUrl = "https://micron.wd1.myworkdayjobs.com/external"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Associate Verification Engineer, Silicon Design Intern (Hyderabad Campus)"
        ContactEmail = ""
    },
    @{
        Name = "Western Digital / SanDisk"
        Domain = "SSD/Flash Controllers, Memory Interface ASICs & RISC-V Cores"
        Location = "Bengaluru"
        CareerUrl = "https://jobs.smartrecruiters.com/WesternDigital"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Hardware Engineer Trainee, ASIC Verification Engineer"
        ContactEmail = ""
    },
    @{
        Name = "Apple (Hardware Silicon Engineering)"
        Domain = "Apple Silicon (M/A Series SoCs), GPU, Neural Engine & Cellular"
        Location = "Hyderabad, Bengaluru"
        CareerUrl = "https://jobs.apple.com/en-in/search?location=india-INDC&team=hardware-HRDWR"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Silicon Validation / Design Verification Engineer (Hyderabad R&D)"
        ContactEmail = ""
    },
    @{
        Name = "Google (Silicon / Hardware)"
        Domain = "Google Tensor SoC, TPU Accelerators & Titan Security Chip"
        Location = "Bengaluru, Hyderabad"
        CareerUrl = "https://www.google.com/about/careers/applications/jobs/results/?location=India&q=Silicon"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Silicon Engineer Early Career / Campus Intern"
        ContactEmail = ""
    },
    @{
        Name = "Microsoft (Silicon Engineering)"
        Domain = "Maia AI Accelerators, Cobalt CPU & Azure Custom Silicon"
        Location = "Hyderabad, Bengaluru"
        CareerUrl = "https://jobs.careers.microsoft.com/global/en/search?lc=India&q=Silicon"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Silicon Hardware Engineer - Logic Design & Verification (Hyderabad IDC)"
        ContactEmail = ""
    },
    @{
        Name = "Cisco Systems (Silicon One / ASIC)"
        Domain = "Silicon One Routing/Switching ASICs & High-Speed SerDes"
        Location = "Bengaluru"
        CareerUrl = "https://jobs.cisco.com/jobs/SearchJobs/?21178=%5B16948%5D"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Hardware Engineer 1 - ASIC Design & Verification"
        ContactEmail = ""
    },
    @{
        Name = "Arm"
        Domain = "Cortex CPU Architecture, Mali GPU & CoreLink Interconnect IP"
        Location = "Bengaluru, Noida"
        CareerUrl = "https://careers.arm.com/search-jobs/India/33099/2/1269750/20/77/50/2"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Graduate Hardware Engineer - CPU/SoC Verification & RTL Design"
        ContactEmail = ""
    },
    @{
        Name = "Synopsys"
        Domain = "EDA Tools (VCS, Verdi), DesignWare Interface IP & Verification IPs"
        Location = "Hyderabad, Bengaluru, Noida"
        CareerUrl = "https://synopsys.wd1.myworkdayjobs.com/Synopsys_Careers?locationCountry=bc33aa3152ec42d4995f4791a106ed09"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "R&D Engineer 1 - Verification IP (VIP), Logic Synthesis (Hyderabad Office)"
        ContactEmail = ""
    },
    @{
        Name = "Cadence Design Systems"
        Domain = "EDA Tools (Xcelium, Innovus), Tensilica DSP & Verification IPs"
        Location = "Noida, Bengaluru, Hyderabad, Pune"
        CareerUrl = "https://cadence.wd1.myworkdayjobs.com/External_Careers?locationCountry=bc33aa3152ec42d4995f4791a106ed09"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Software/Design Engineer 1 - Verification & Emulation (Palladium)"
        ContactEmail = ""
    },
    @{
        Name = "Siemens EDA (Mentor Graphics)"
        Domain = "Questa Verification, Veloce Emulation & Tessent DFT"
        Location = "Noida, Bengaluru, Hyderabad"
        CareerUrl = "https://jobs.siemens.com/careers?location=India&keyword=EDA"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Associate Product Engineer - Functional Verification (Hyderabad)"
        ContactEmail = ""
    },
    @{
        Name = "Renesas Electronics"
        Domain = "Automotive Microcontrollers, Industrial IoT Silicon & Power"
        Location = "Bengaluru, Hyderabad, Noida"
        CareerUrl = "https://jobs.renesas.com/"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Graduate Trainee - Digital Design & Verification"
        ContactEmail = ""
    },
    @{
        Name = "Silicon Labs"
        Domain = "Ultra-Low-Power Wireless SoCs (Bluetooth, Zigbee, Wi-Fi)"
        Location = "Hyderabad"
        CareerUrl = "https://silabs.wd1.myworkdayjobs.com/Careers"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Associate Hardware Engineer - Low-Power Digital Design & DV (Hyderabad)"
        ContactEmail = ""
    },
    @{
        Name = "Cirrus Logic"
        Domain = "High-Precision Audio ASICs, Smart Amplifiers & Mixed-Signal"
        Location = "Bengaluru"
        CareerUrl = "https://www.cirrus.com/careers/"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Digital Design & Verification Engineer 1"
        ContactEmail = ""
    },
    @{
        Name = "Skyworks Solutions"
        Domain = "RF Front-End Modules, Analog Mixed-Signal & Wireless ICs"
        Location = "Bengaluru"
        CareerUrl = "https://careers.skyworksinc.com/"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Design Engineer Trainee - Digital/RF"
        ContactEmail = ""
    },
    @{
        Name = "onsemi (ON Semiconductor)"
        Domain = "Intelligent Power & Sensing Technologies, Silicon Carbide (SiC)"
        Location = "Bengaluru"
        CareerUrl = "https://onsemi.wd1.myworkdayjobs.com/en-US/onsemi_careers?locationCountry=bc33aa3152ec42d4995f4791a106ed09"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Design Verification Engineer Trainee"
        ContactEmail = ""
    },
    @{
        Name = "Rambus"
        Domain = "High-Speed Memory Controllers (DDR5, HBM, CXL) & Security IP"
        Location = "Bengaluru"
        CareerUrl = "https://www.rambus.com/careers/"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Associate Verification Engineer - Memory Interface IP"
        ContactEmail = ""
    },
    @{
        Name = "Juniper Networks (HPE)"
        Domain = "Custom Packet Forwarding ASICs & Networking Hardware"
        Location = "Bengaluru"
        CareerUrl = "https://careers.juniper.net/"
        Tier = "Tier 1: Global Product & EDA Giants"
        FresherPath = "Hardware Engineer 1 - ASIC Logic Design & Pre-Silicon DV"
        ContactEmail = ""
    }
)

$tier2Services = @(
    @{
        Name = "Tessolve Semiconductor"
        Domain = "Turnkey ASIC Design, Pre-Silicon DV, Test Engineering & PD"
        Location = "Bengaluru, Hyderabad, Coimbatore"
        CareerUrl = "https://tessolve.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "VLSI Graduate Trainee Engineer (Massive fresher recruiter in Hyderabad!)"
        ContactEmail = "careers@tessolve.com"
    },
    @{
        Name = "eInfochips (An Arrow Company)"
        Domain = "Full ASIC/SoC Design, UVM Verification & FPGA Prototyping"
        Location = "Ahmedabad, Bengaluru, Pune, Noida"
        CareerUrl = "https://www.einfochips.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "ASIC Design Verification Trainee (Frequent off-campus fresher drives)"
        ContactEmail = "careers@einfochips.com"
    },
    @{
        Name = "Sankalp Semiconductor (HCLTech)"
        Domain = "Analog Mixed Signal, Digital RTL, Verification & Physical Design"
        Location = "Hubli, Bengaluru, Kolkata"
        CareerUrl = "https://www.sankalpshemi.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Trainee Design Engineer (0-1 yrs)"
        ContactEmail = "careers@sankalpshemi.com"
    },
    @{
        Name = "MosChip Technologies"
        Domain = "Turnkey ASIC Design, DV, FPGA, Embedded Firmware & Physical Design"
        Location = "Hyderabad"
        CareerUrl = "https://moschip.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "MAST Academy & Graduate Engineer Trainee (Hyderabad Knowledge City)"
        ContactEmail = "contact@moschip.com"
    },
    @{
        Name = "L&T Semiconductor Technologies (LTSCT)"
        Domain = "Fabless Semiconductor Product & Design Services, Automotive ASIC"
        Location = "Bengaluru, Chennai, Hyderabad"
        CareerUrl = "https://www.ltts.com/careers"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "GET - VLSI / Semiconductor Practice"
        ContactEmail = "careers@ltts.com"
    },
    @{
        Name = "Tata Elxsi"
        Domain = "Semiconductor Design Services, Automotive SoC, FPGA & Embedded"
        Location = "Bengaluru, Hyderabad, Pune, Trivandrum"
        CareerUrl = "https://www.tataelxsi.com/careers"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Engineer Trainee - Semiconductor & Embedded VLSI"
        ContactEmail = "careers@tataelxsi.com"
    },
    @{
        Name = "Wipro VLSI (Wipro Engineering Edge)"
        Domain = "ASIC/SoC Pre-Silicon DV, SystemVerilog/UVM, RTL Synthesis & FPGA"
        Location = "Bengaluru, Hyderabad"
        CareerUrl = "https://careers.wipro.com/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Project Engineer - VLSI & Embedded Systems"
        ContactEmail = "talentacquisition@wipro.com"
    },
    @{
        Name = "HCLTech (Silicon & VLSI Engineering)"
        Domain = "Turnkey SoC Design, VIP Integration & Post-Silicon Validation"
        Location = "Noida, Bengaluru, Hyderabad, Chennai"
        CareerUrl = "https://www.hcltech.com/careers"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Graduate Engineer Trainee - Silicon Engineering Practice"
        ContactEmail = "recruitment@hcl.com"
    },
    @{
        Name = "Cyient"
        Domain = "Semiconductor Services, ASIC Design, Mixed-Signal & Verification"
        Location = "Hyderabad"
        CareerUrl = "https://www.cyient.com/careers"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Design Engineer Trainee - Semiconductor (Hyderabad HQ)"
        ContactEmail = "careers@cyient.com"
    },
    @{
        Name = "Capgemini Engineering (formerly Altran)"
        Domain = "Silicon & Physical Design, Pre-Silicon Verification, VIP & Embedded"
        Location = "Bengaluru, Hyderabad, Noida, Gurugram"
        CareerUrl = "https://www.capgemini.com/in-en/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Associate Consultant - Semiconductor & VLSI"
        ContactEmail = "recruitment.in@capgemini.com"
    },
    @{
        Name = "Infosys (Semiconductor Practice)"
        Domain = "ASIC Verification, IP Integration, FPGA Emulation & Firmware"
        Location = "Bengaluru, Hyderabad, Pune"
        CareerUrl = "https://www.infosys.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Systems Engineer - Semiconductor & Embedded Engineering"
        ContactEmail = "askus@infosys.com"
    },
    @{
        Name = "Tata Technologies"
        Domain = "Automotive Embedded, Connected Vehicle Silicon & Firmware"
        Location = "Pune, Bengaluru"
        CareerUrl = "https://www.tatatechnologies.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Graduate Trainee - Embedded Software & Hardware"
        ContactEmail = "careers@tatatechnologies.com"
    },
    @{
        Name = "KPIT Technologies"
        Domain = "Automotive Software & Semiconductor Middleware, AUTOSAR & MCU"
        Location = "Pune, Bengaluru"
        CareerUrl = "https://www.kpit.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Trainee Software / Hardware Engineer"
        ContactEmail = "careers@kpit.com"
    },
    @{
        Name = "Mirafra Technologies"
        Domain = "Pure-play VLSI Design & Verification Services, UVM Testbenches"
        Location = "Bengaluru, Hyderabad, Pune, Manipal"
        CareerUrl = "https://mirafra.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Associate Design Verification Engineer (Direct fresher recruiter!)"
        ContactEmail = "careers@mirafra.com"
    },
    @{
        Name = "Truechip Solutions"
        Domain = "Leading Verification IP (VIP) Specialist, PCIe, USB, AMBA VIPs"
        Location = "Noida, Bengaluru"
        CareerUrl = "https://www.truechip.net/careers"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Verification Trainee / Junior DV Engineer (Regular fresher drives for SV/UVM)"
        ContactEmail = "jobs@truechip.net"
    },
    @{
        Name = "Smart-DV Technologies"
        Domain = "Verification IPs, Assertions (SVA), Memory Models & RISC-V"
        Location = "Bengaluru"
        CareerUrl = "https://www.smart-dv.com/career.html"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Verification Engineer (0-6 Years, actively hiring freshers)"
        ContactEmail = "jobs@smart-dv.com"
    },
    @{
        Name = "Mistral Solutions"
        Domain = "Embedded Systems, FPGA Systems (Xilinx/Artix), Radar & Defense Hardware"
        Location = "Bengaluru, Hyderabad, Delhi"
        CareerUrl = "https://www.mistralsolutions.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Trainee Engineer - FPGA & Embedded Hardware"
        ContactEmail = "careers@mistralsolutions.com"
    },
    @{
        Name = "Ignitarium Technology Solutions"
        Domain = "AI Silicon, Edge SoC, Digital RTL & Formal Verification"
        Location = "Bengaluru, Kochi"
        CareerUrl = "https://ignitarium.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Associate Engineer - Digital & Verification"
        ContactEmail = "careers@ignitarium.com"
    },
    @{
        Name = "Vayavya Labs"
        Domain = "ESL Design, Device Driver, Hardware-Software Co-verification"
        Location = "Belagavi, Bengaluru, Pune"
        CareerUrl = "https://www.vayavyalabs.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Junior Engineer - Embedded & SoC Verification"
        ContactEmail = "careers@vayavyalabs.com"
    },
    @{
        Name = "Cerium Systems (Tech Mahindra)"
        Domain = "ASIC/FPGA Design, Pre-Silicon Verification, Physical Design"
        Location = "Bengaluru, Kochi, Vizag, Hyderabad"
        CareerUrl = "https://www.techmahindra.com/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Associate Software / Hardware Engineer - VLSI"
        ContactEmail = "careers@techmahindra.com"
    },
    @{
        Name = "Softnautics"
        Domain = "ASIC/FPGA Design Services, AI Vision Acceleration & Firmware"
        Location = "Pune, Ahmedabad"
        CareerUrl = "https://www.softnautics.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Trainee Engineer - FPGA & RTL Design"
        ContactEmail = "careers@softnautics.com"
    },
    @{
        Name = "PerfectVIPs"
        Domain = "Verification IPs, PCIe, AXI, OCP, Functional Verification"
        Location = "Bengaluru"
        CareerUrl = "https://perfectvips.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Verification Engineer Trainee"
        ContactEmail = "careers@perfectvips.com"
    },
    @{
        Name = "ACL Digital (ALTEN Group)"
        Domain = "Semiconductor Services, ASIC, FPGA & Embedded Software"
        Location = "Bengaluru, Ahmedabad"
        CareerUrl = "https://www.acldigital.com/careers"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Trainee - Semiconductor Design"
        ContactEmail = "careers@acldigital.com"
    },
    @{
        Name = "ASICzen Technologies"
        Domain = "ASIC Verification, VIP Development & UVM Testbenches"
        Location = "Bhubaneswar, Bengaluru"
        CareerUrl = "https://asiczen.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Junior Verification Engineer"
        ContactEmail = "hr@asiczen.com"
    },
    @{
        Name = "SignOff Semiconductors"
        Domain = "Physical Design, RTL to GDSII, Synthesis & STA"
        Location = "Bengaluru"
        CareerUrl = "https://signoffsemi.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Trainee - Physical Design & RTL"
        ContactEmail = "careers@signoffsemi.com"
    },
    @{
        Name = "Prodigy Technovations"
        Domain = "Protocol Analysis, eMMC, UFS, I3C, PCIe Protocol Exercisers (FPGA)"
        Location = "Bengaluru"
        CareerUrl = "https://prodigytechno.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "FPGA Design & Firmware Engineer (0-1 yrs)"
        ContactEmail = "careers@prodigytechno.com"
    },
    @{
        Name = "Faststream Technologies"
        Domain = "ASIC Verification, FPGA Emulation & Embedded IoT Systems"
        Location = "Bengaluru, Hyderabad"
        CareerUrl = "https://www.faststreamtech.com/careers/"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Junior ASIC / FPGA Engineer"
        ContactEmail = "info@faststreamtech.com"
    },
    @{
        Name = "Sevya Multimedia"
        Domain = "Multimedia SoC, VLSI Design & Verification, Embedded"
        Location = "Hyderabad"
        CareerUrl = "https://www.sevya.com/careers"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Entry-level VLSI Engineer (Hyderabad)"
        ContactEmail = "jobs@sevya.com"
    },
    @{
        Name = "Siliconally"
        Domain = "ASIC Design & Verification, SystemVerilog Consulting"
        Location = "Bengaluru"
        CareerUrl = "https://siliconally.com/careers"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Graduate Engineer - Verification"
        ContactEmail = "contact@siliconally.com"
    },
    @{
        Name = "LeapMetrics"
        Domain = "VLSI Design & Verification, Digital Electronics Services"
        Location = "Hyderabad"
        CareerUrl = "https://leapmetrics.in/careers"
        Tier = "Tier 2: Major VLSI Design & Verification Services"
        FresherPath = "Junior VLSI Engineer (Hyderabad)"
        ContactEmail = "careers@leapmetrics.in"
    }
)

# Merge all into unified list
$masterList = @()
$counter = 1

# 1. Add Tier 1
foreach ($m in $tier1MNCs) {
    $masterList += [PSCustomObject]@{
        SNo = $counter++
        Name = $m.Name
        Tier = $m.Tier
        Domain = $m.Domain
        Location = $m.Location
        BaseUrl = $m.CareerUrl
        CareerUrl = $m.CareerUrl
        FresherPath = $m.FresherPath
        ContactEmail = $m.ContactEmail
    }
}

# 2. Add Tier 2
foreach ($s in $tier2Services) {
    $masterList += [PSCustomObject]@{
        SNo = $counter++
        Name = $s.Name
        Tier = $s.Tier
        Domain = $s.Domain
        Location = $s.Location
        BaseUrl = $s.CareerUrl
        CareerUrl = $s.CareerUrl
        FresherPath = $s.FresherPath
        ContactEmail = $s.ContactEmail
    }
}

# 3. Add Tier 3 (102 DLI Startups)
foreach ($d in $existingDli) {
    $fPath = if ($d.ContactEmail) { "Direct Email Application to HR / Resume Drop" } else { "Company Career Portal Application" }
    if ($d.Name -eq "Mindgrove Technologies") { $fPath = "Zoho Recruit Portal / Campus Referral (CGPA > 7.5)" }
    elseif ($d.Name -eq "InCore Semiconductors") { $fPath = "Zoho Recruit Portal / Direct Email to HR" }
    elseif ($d.Name -eq "Vicharak") { $fPath = "Direct Email / Web Application for FPGA & Digital Trainee" }
    elseif ($d.Name -eq "Netrasemi") { $fPath = "ASIC DV & Embedded Internship (Convertible to PPO)" }
    elseif ($d.Name -eq "Terminus Circuits") { $fPath = "Fresher & Trainee (0-2 yrs) Email Application" }
    elseif ($d.Name -eq "Signitude") { $fPath = "Recent College Graduate Mentorship Program" }

    $masterList += [PSCustomObject]@{
        SNo = $counter++
        Name = $d.Name
        Tier = "Tier 3: Startups & DLI Scheme Ecosystem"
        Domain = $d.Domain
        Location = $d.Location
        BaseUrl = $d.BaseUrl
        CareerUrl = $d.CareerUrl
        FresherPath = $fPath
        ContactEmail = $d.ContactEmail
    }
}

Write-Output "Total master companies count: $($masterList.Count)"
$masterList | ConvertTo-Json -Depth 4 | Set-Content "$workspace\companies_db.json" -Encoding UTF8
$masterList | Export-Csv -Path "$workspace\companies.csv" -NoTypeInformation -Encoding UTF8

Write-Output "Successfully updated companies_db.json and companies.csv with $($masterList.Count) companies across 3 Tiers!"