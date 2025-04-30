# AdapterToggler

Quick and clean Ethernet ↔ Wi-Fi switching with custom sounds and smart tray icons, built with AutoHotkey v2.

## Features
- **Hotkey** toggling between Ethernet and Wi-Fi
- **Sys Tray Right Click** toggling between Ethernet and Wi-Fi
- **Custom tray icons** for different network statuses:
  - Ethernet connected
  - Ethernet disconnected
  - Wi-Fi connected
  - Wi-Fi disconnected
  - Both adapters enabled (warning)
  - Both adapters disabled
- **Unique** notification sound
- **Automatically** detects active adapter every 15 seconds (or 5 minutes if a game is running)

## Requirements
- [AutoHotkey v2.0](https://www.autohotkey.com/)
- Windows
- SoundVolumeView by NirSoft (optional, for muting system sounds during notification)
You can download SoundVolumeView from [NirSoft](https://www.nirsoft.net/utils/sound_volume_view.html)

**Important:**
If you want to install SoundVolumeView into C:\Program Files\ or any other location, make sure to add its folder path to your System Environment Variables.
Otherwise, the script won't find SoundVolumeView.exe when muting/unmuting system sounds during the notification.
*(Or just toss the SoundVolumeView.exe in the same folder as the script if you want to keep it easy.)*

## Installation
1. Install AutoHotkey v2 if you haven't already (optionally Ahk2Exe compiler)
2. Place the script `.ahk` file, the following `.ico` files in the same folder:
   - `ethernet.ico`
   - `ethernetnoconnect.ico`
   - `wifi.ico`
   - `wifinoconnect.ico`
   - `caution.ico`
   - `neither.ico`
3. Make sure SoundVolumeView is accessible (see above).
4. Use the system tray right-click menu or press **Ctrl + Alt + N** to toggle adapters.

## Notes
- The script uses `netsh` commands, which may require administrator privileges depending on your system settings.
- The script creates `interfaces.txt` file to read network statuses which is overwritten with each status check.
- This script expects your adapters to be named exactly Ethernet and Wi-Fi.
If your adapters have custom names, just edit the script accordingly based on the names reported in the interfaces.txt file .
- The script slows the status check timer while cod.exe (Call of Duty) is running.  Edit for whichever app you would like to slow the timer for.

## Support
- If you encounter any issues or have suggestions for improvements, please open an issue. We appreciate your feedback and are always looking to improve the tool.

Enjoy and customize to your liking!
