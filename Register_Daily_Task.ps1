# Registers a daily scheduled task in Windows to run Daily_Job_Hunter.ps1 every day at 9:00 AM
$taskName = "Semiconductor_Job_Radar_Sohan"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $scriptDir) { $scriptDir = "c:\Users\admin\Downloads\companies list" }

$scriptPath = Join-Path $scriptDir "Daily_Job_Hunter.ps1"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Configuring Windows Task Scheduler for Daily Career Checks " -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Task Name : $taskName"
Write-Host "Schedule  : Daily at 09:00 AM + 2 minutes after sign-in"
Write-Host "Script    : $scriptPath"

try {
    # Unregister if exists
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue

    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -Daily -At "09:00"
    # Also run 2 minutes after sign-in, so a laptop that was off at 09:00 still gets a fresh scan
    $logonTrigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
    $logonTrigger.Delay = "PT2M"
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

    $registered = Register-ScheduledTask -TaskName $taskName -Action $action -Trigger @($trigger, $logonTrigger) -Settings $settings
    
    Write-Host "`nTask successfully scheduled and is Ready!" -ForegroundColor Green
    Write-Host "It will run automatically every morning at 09:00 AM and each time you sign in." -ForegroundColor Green
    Write-Host "It will update 'Daily_Career_Report.html' and alert you of new semiconductor openings." -ForegroundColor Green
} catch {
    Write-Error "Failed to register scheduled task: $_"
}

Write-Host "============================================================" -ForegroundColor Cyan
