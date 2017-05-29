<#
    Set these variables first
        $IP = "134.213.29.116"
        $Username = "CORP\Freddie"
        $Password = "hunter2"

    Compiles Scriptrunner.ahk and invokes it with the above variables passed for the connection

#>
while (Get-Process Scriptrunner -ErrorAction Ignore) {
    Get-Process Scriptrunner | Stop-Process -Force -ErrorAction Ignore
    Start-Sleep 0.2
}
if (Test-Path "$PSScriptRoot\Scriptrunner.exe") {Remove-Item "$PSScriptRoot\Scriptrunner.exe" -Force}
& 'C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe' /in "$PSScriptRoot\Scriptrunner.ahk" /out "$PSScriptRoot\Scriptrunner.exe"
Start-Sleep 1
& "$PSScriptRoot\Scriptrunner.exe" $IP $Username $Password
