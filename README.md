# Semiconductor Job Radar

A personal job-search assistant in PowerShell. It scans the careers pages of 200+ semiconductor and VLSI companies in India every day, looks for entry-level RTL design, design verification, FPGA and embedded firmware openings, and builds an HTML dashboard of new postings, with ready-to-send application emails.

## How it works

1. **Company database:** `build_master_db.ps1` and the `add_*_companies.ps1` scripts build `companies_db.json` / `companies.csv`. The companies are grouped into Tier 1 MNCs, Tier 2 VLSI service companies and Tier 3 startups, with Bengaluru and Hyderabad as priority hubs.
2. **Career-link probing:** `probe_career_links.ps1` and `probe_parallel.ps1` find and check each company's careers page in parallel.
3. **Daily scan:** `Daily_Job_Hunter.ps1` fetches each careers page and matches role keywords (RTL, DV, SystemVerilog, UVM, FPGA, firmware…). It compares results with the previous run's history to flag new postings.
4. **Dashboard:** it writes `Daily_Career_Report.html` with new and existing matches, HR contact buttons that open a pre-filled Gmail compose window, and copy-ready outreach templates.
5. **Scheduling:** `Setup_Daily_Schedule.bat` → `Register_Daily_Task.ps1` registers a Windows Task Scheduler job that runs at 09:00 every day and 2 minutes after sign-in. `run_check_now.bat` runs a scan on demand and opens the dashboard.

## Helper scripts

`check_candidates.ps1`, `check_new.ps1`, `inspect_new_results.ps1`, `list_companies.ps1`, `stats.ps1`: quick checks of the database and the latest results.

## Setup

```powershell
.\run_check_now.bat          # one scan + open dashboard
.\Setup_Daily_Schedule.bat   # schedule the daily scan
```

Before using it, edit the cover-letter text and contact line in `Daily_Job_Hunter.ps1`, and set `$resumeUrl` to a public link to your resume.

Generated files (`Daily_Career_Report.html`, `job_history.json`, `latest_results.json`) are created on the first run and are not committed.
