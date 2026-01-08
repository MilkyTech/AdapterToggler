#Requires AutoHotkey v2.0
#SingleInstance Force

A_IconTip := "AdapterToggler"
A_TrayMenu.Delete()
A_TrayMenu.Add("Toggle Adapter", (*) => ToggleAdapter())
A_TrayMenu.Add()
A_TrayMenu.Add("Exit", (*) => ExitApp())

OnMessage(0x404, TrayClickHandler)

TrayClickHandler(wParam, lParam, *) {
    ; 0x202 = WM_LBUTTONUP (left button released)
    if (lParam = 0x202) {
        ToggleAdapter()
    }
}

DetectActiveAdapterAndSetIcon() {
    ethernetConnected := false
    ethernetDisconnected := false
    wifiConnected := false
    wifiDisconnected := false

    RunWait('cmd.exe /c netsh interface show interface > interfaces.txt', , "Hide")
    interfaces := FileRead("interfaces.txt")

    ; Define adapter status
    Loop Parse, interfaces, "`n", "`r"
    {
        line := A_LoopField
        if InStr(line, "Dedicated") {
            if InStr(line, "Ethernet") && InStr(line, "Enabled") && RegExMatch(line, "\bConnected\b") {
                ethernetConnected := true
            } else if InStr(line, "Ethernet") && InStr(line, "Enabled") && RegExMatch(line, "\bDisconnected\b") {
                ethernetDisconnected := true
            } else if InStr(line, "Wi-Fi") && InStr(line, "Enabled") && RegExMatch(line, "\bConnected\b") {
                wifiConnected := true
            } else if InStr(line, "Wi-Fi") && InStr(line, "Enabled") && RegExMatch(line, "\bDisconnected\b") {
                wifiDisconnected := true
            }
        }
    }

    ; Set the appropriate icon based on adapter status
    if ethernetConnected && !ethernetDisconnected && !wifiConnected && !wifiDisconnected {
        TraySetIcon("ethernet.ico", , true)
		A_IconTip := "Ethernet Connected"
    } else if ethernetDisconnected && !ethernetConnected && !wifiConnected && !wifiDisconnected {
        TraySetIcon("ethernetnoconnect.ico", , true)
		A_IconTip := "Ethernet Disconnected"
    } else if wifiConnected && !wifiDisconnected && !ethernetDisconnected && !ethernetConnected {
        TraySetIcon("wifi.ico", , true)
		A_IconTip := "Wi-Fi Connected"
    } else if wifiDisconnected && !wifiConnected && !ethernetDisconnected && !ethernetConnected {
        TraySetIcon("wifinoconnect.ico", , true)
		A_IconTip := "Wi-Fi Disconnected"
    } else if (wifiDisconnected || wifiConnected) && (ethernetDisconnected || ethernetConnected) {
        TraySetIcon("caution.ico", , true)
		A_IconTip := "Both Adapters Enabled"
    } else {
        TraySetIcon("neither.ico", , true)
		A_IconTip := "Both Adapters Disabled"
    }
}

DetectActiveAdapterAndSetIcon()

SetTimer(CheckNetworkStatus, 15000)  ; Check every 15 seconds

CheckNetworkStatus() {
    isProcessExist := ProcessExist("cod.exe")  ; Edit this exe for whatever app you want to slow the timer
    if !isProcessExist {
        DetectActiveAdapterAndSetIcon()
    } else {
        SetTimer(CheckNetworkStatus, 300000)  ; Check every 5 minutes when game is running
    }
}

^!n::ToggleAdapter()

PlaySilentNotification() {
    RunWait 'SoundVolumeView.exe /Mute "System Sounds"'
    SoundPlay("C:\Windows\Media\Windows Proximity Notification.wav", 1)
    RunWait 'SoundVolumeView.exe /Unmute "System Sounds"'
}

ToggleAdapter() {
    ethernetConnected := false
    ethernetDisconnected := false
    wifiConnected := false
    wifiDisconnected := false
    ethernet := "Ethernet"
    wifi := "Wi-Fi"

    RunWait('cmd.exe /c netsh interface show interface > interfaces.txt', , "Hide")
    interfaces := FileRead("interfaces.txt")

    ; Define adapter status
    Loop Parse, interfaces, "`n", "`r"
    {
        line := A_LoopField
        if InStr(line, "Dedicated") {
            if InStr(line, "Ethernet") && InStr(line, "Enabled") && RegExMatch(line, "\bConnected\b") {
                ethernetConnected := true
            } else if InStr(line, "Ethernet") && InStr(line, "Enabled") && RegExMatch(line, "\bDisconnected\b") {
                ethernetDisconnected := true
            } else if InStr(line, "Wi-Fi") && InStr(line, "Enabled") && RegExMatch(line, "\bConnected\b") {
                wifiConnected := true
            } else if InStr(line, "Wi-Fi") && InStr(line, "Enabled") && RegExMatch(line, "\bDisconnected\b") {
                wifiDisconnected := true
            }
        }
    }

    ; Toggle adapter based on adapter status
    if (ethernetConnected || ethernetDisconnected) && (!wifiConnected && !wifiDisconnected) {
        RunWait('netsh interface set interface name="' wifi '" admin=enable', , "Hide")
        Sleep 1000
        RunWait('netsh interface set interface name="' ethernet '" admin=disable', , "Hide")
        TrayTip("Adapter Toggler", "Switched to Wi-Fi.")
        TraySetIcon("wifi.ico", , true)
        PlaySilentNotification()
		A_IconTip := "Wi-Fi Enabled"
    } else if (wifiConnected || wifiDisconnected) && (!ethernetConnected && !ethernetDisconnected) {
        RunWait('netsh interface set interface name="' ethernet '" admin=enable', , "Hide")
        Sleep 1000
        RunWait('netsh interface set interface name="' wifi '" admin=disable', , "Hide")
        TrayTip("Adapter Toggler", "Switched to Ethernet.")
        TraySetIcon("ethernet.ico", , true)
        PlaySilentNotification()
		A_IconTip := "Ethernet Enabled"
    } else if (wifiDisconnected || wifiConnected) && (ethernetConnected || ethernetDisconnected) {
        RunWait('netsh interface set interface name="' wifi '" admin=disable', , "Hide")
        TrayTip("Adapter Toggler", "Wi-Fi disabled. Ethernet is active.")
        TraySetIcon("ethernet.ico", , true)
        PlaySilentNotification()
		A_IconTip := "Ethernet Enabled"
    } else {
        RunWait('netsh interface set interface name="' ethernet '" admin=enable', , "Hide")
        Sleep 1000
        RunWait('netsh interface set interface name="' wifi '" admin=disable', , "Hide")
        TrayTip("Adapter Toggler", "Wi-Fi disabled. Ethernet is active.")
        TraySetIcon("ethernet.ico", , true)
        PlaySilentNotification()
		A_IconTip := "Ethernet Enabled"
    }
}