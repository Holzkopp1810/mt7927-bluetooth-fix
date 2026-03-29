# MT7927 / MT6639 Bluetooth Fix (Linux)

Working fix for MediaTek MT7927 (MT6639) Bluetooth on Linux.

---

## 🚀 Quick Fix

If your Bluetooth is broken (no `hci0`):

```bash
git clone https://github.com/YOURNAME/mt7927-bluetooth-fix
cd mt7927-bluetooth-fix
bash fix_bt_mt7927.sh
```

✔ This will:

* copy firmware
* reload Bluetooth modules
* restart Bluetooth service

---

## 🧪 Tested on

* ASUS ROG STRIX X870E-E GAMING WIFI
* Garuda Linux (Arch-based)
* Kernel 6.19 (zen)
* USB ID: 0489:e13a

---

## ❌ Problem

* No Bluetooth controller (`hci0` missing)
* `bluetoothctl list` shows nothing
* Device visible in `lsusb` but unusable
* Errors like:

  * `Failed to load firmware (-2)`
  * `setting interface failed (22)`

---

## 🧠 Cause

* Missing/incorrect firmware for MT6639
* Linux kernel does not yet ship correct firmware
* Driver support incomplete → requires workaround

---

## 🛠 Setup Instructions

### 1. Get firmware from Windows

Path:

```
C:\Windows\System32\DriverStore\FileRepository\
```

Find folder like:

```
mtkbtfilter.inf_amd64_xxxxx
```

Inside:

```
mtkbt.dat
```

---

### 2. Extract firmware

Use extraction script:

```bash
python extract_firmware.py mtkbt.dat BT_RAM_CODE_MT6639_2_1_hdr.bin
```

---

### 3. Place firmware

```bash
sudo mkdir -p /lib/firmware/mediatek/mt6639
sudo cp BT_RAM_CODE_MT6639_2_1_hdr.bin /lib/firmware/mediatek/mt6639/
sudo cp BT_RAM_CODE_MT6639_2_1_hdr.bin /lib/firmware/mediatek/
```

---

### 4. Install patched driver (DKMS)

```bash
yay -S mt7927-dkms
```

---

### 5. Enable module options + restart

```bash
echo 'options btusb enable_autosuspend=0' | sudo tee /etc/modprobe.d/btusb.conf
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo modprobe -r btusb btmtk
sudo modprobe btusb
```

---

### 6. Test

```bash
bluetoothctl list
```

✔ `hci0` should appear

---

## ⚠️ Important

* This is a workaround, not a proper upstream fix
* Requires patched btusb/btmtk driver (DKMS)
* Firmware is taken from Windows driver
* May break after kernel updates

---

## 🔁 Recovery Script

If Bluetooth disappears after reboot:

```bash
bash fix_bt_mt7927.sh
```

---

## 📌 Notes

* Without patched driver, this usually does NOT work
* Linux firmware packages do not include correct MT6639 firmware yet
* Windows driver contains required firmware
* Known issue: MT7927 / MT6639 not fully supported in current kernels
* Behavior may vary between kernel versions
* This repo documents a working workaround

---

## 🎯 Goal

Help others avoid hours of debugging firmware + driver issues.

---

## 👤 Author

Holzkopp1810
