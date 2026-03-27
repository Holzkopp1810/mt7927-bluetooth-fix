# MT7927 / MT6639 Bluetooth Fix (Linux)

Working fix for MediaTek MT7927 (MT6639) Bluetooth not working on Linux.

Tested on:
- ASUS ROG STRIX X870E-E GAMING WIFI
- Garuda Linux (Arch-based)
- USB ID: 0489:e13a

Problem:
- No Bluetooth controller (no hci0)
- bluetoothctl shows nothing
- Device visible in lsusb but not usable
- Errors like:
  Failed to load firmware (-2)
  setting interface failed (22)

Cause:
This is a firmware + driver issue, not a configuration problem.

Fix:

1. Get firmware from Windows

Path:
C:\Windows\System32\DriverStore\FileRepository\

Find:
mtkbtfilter.inf_amd64_XXXXX

Inside:
mtkbt.dat

If you don’t have Windows:
→ download your motherboard’s Bluetooth driver from ASUS website
→ extract it (zip/exe) and find mtkbt.dat inside

2. Extract firmware

You need a script to extract the firmware from mtkbt.dat.

Example (one of many):
https://gist.github.com/max-prtsr/2e19d74e421b60fbad30b6932772e76e

Run:

python extract_firmware.py mtkbt.dat BT_RAM_CODE_MT6639_2_1_hdr.bin

3. Install firmware

sudo mkdir -p /lib/firmware/mediatek/mt6639
sudo cp BT_RAM_CODE_MT6639_2_1_hdr.bin /lib/firmware/mediatek/mt6639/
sudo cp BT_RAM_CODE_MT6639_2_1_hdr.bin /lib/firmware/mediatek/

4. Install patched driver

yay -S mediatek-mt7927-dkms

5. Reboot

reboot

Result:

bluetoothctl list
→ hci0 should appear

Notes:
- Without patched driver this usually does NOT work
- Linux firmware package does not include correct MT6639 firmware (yet)
- Windows driver contains required firmware

Final:
This took way too long to figure out, posting here to save others time.
