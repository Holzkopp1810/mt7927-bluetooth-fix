#!/bin/bash
# fix_bt_generic.sh
# Recovery for MT7927 / MT6639 Bluetooth on any Linux system
# User: adjust the path to BT_RAM_CODE_MT6639_2_1_hdr.bin

# --- TO ADJUST ---
FIRMWARE="PATH_TO_FIRMWARE/BT_RAM_CODE_MT6639_2_1_hdr.bin"
# -------------------

if [ ! -f "$FIRMWARE" ]; then
    echo "Firmware not found: $FIRMWARE"
    echo "Please place BT_RAM_CODE_MT6639_2_1_hdr.bin in the specified path."
    exit 1
fi

# Copy firmware
sudo mkdir -p /lib/firmware/mediatek/mt6639
sudo cp "$FIRMWARE" /lib/firmware/mediatek/mt6639/
sudo cp "$FIRMWARE" /lib/firmware/mediatek/

# Set module options
echo 'options btusb enable_autosuspend=0' | sudo tee /etc/modprobe.d/btusb.conf > /dev/null

# Enable Bluetooth service
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Reload modules
sudo modprobe -r btusb btmtk
sudo modprobe btusb

# Check status
echo "Bluetooth controllers:"
bluetoothctl list
echo "Done! Run this script again after reboot if hci0 does not appear."
