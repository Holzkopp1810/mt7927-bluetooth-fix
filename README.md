# MT7927 / MT6639 Bluetooth Fix (Linux)

Working fix for MediaTek MT7927 (MT6639) Bluetooth on Linux.

Tested on:
- ASUS ROG STRIX X870E-E GAMING WIFI
- Garuda Linux (Arch-based)
- USB ID: 0489:e13a

Problem:
- No Bluetooth controller (no hci0)
- `bluetoothctl` shows nothing
- Device visible in `lsusb` but not usable
- Errors like: Failed to load firmware (-2), setting interface failed (22)

Cause:
- Firmware + driver issue, not a configuration problem.

Setup Instructions:

1. Get firmware from Windows
- Path: C:\Windows\System32\DriverStore\FileRepository\
- Find folder: mtkbth.inf_amd64_XXXXX
- Inside: mtkbt.dat
- If you don’t have Windows: download your motherboard’s Bluetooth driver from ASUS website, extract zip/exe, find mtkbt.dat inside

2. Extract firmware
- Use a script to extract the firmware from mtkbt.dat
- Example: https://gist.github.com/max-prtsr/2e19d74e421b60fbad30b6932772e76e
- Run:
python extract_firmware.py mtkbt.dat BT_RAM_CODE_MT6639_2_1_hdr.bin

3. Install firmware
sudo mkdir -p /lib/firmware/mediatek/mt6639
sudo cp BT_RAM_CODE_MT6639_2_1_hdr.bin /lib/firmware/mediatek/mt6639/
sudo cp BT_RAM_CODE_MT6639_2_1_hdr.bin /lib/firmware/mediatek/

4. Install patched driver
yay -S mediatek-mt7927-dkms

5. Set module options & enable service
echo 'options btusb enable_autosuspend=0' | sudo tee /etc/modprobe.d/btusb.conf
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo modprobe -r btusb btmtk
sudo modprobe btusb

6. Test
bluetoothctl list
- hci0 should appear

Notes:
- Without the patched driver, this usually does NOT work
- Linux firmware packages do not include correct MT6639 firmware yet
- Windows driver contains required firmware
- Known issue: MT7927 / MT6639 Bluetooth is not fully supported in current Linux kernels
- Current behavior may vary after reboot; hci0 may disappear in some kernel/module versions
- Optional: Use the included fix_bt.sh script to restore hci0 if it disappears
- This repository is intended as documentation / preparation, not a guaranteed permanent fix
- Goal: save others time trying to figure out firmware and driver setup
