#!/bin/bash
set -e

FIRMWARE="/home/arch/btusb-mt7927-dkms/src/BT_RAM_CODE_MT6639_2_1_hdr.bin"

if [ ! -f "$FIRMWARE" ]; then
    echo "Firmware not found: $FIRMWARE"
    exit 1
fi

echo "==> Copying firmware"
sudo mkdir -p /lib/firmware/mediatek/mt6639
sudo cp -f "$FIRMWARE" /lib/firmware/mediatek/mt6639/
sudo cp -f "$FIRMWARE" /lib/firmware/mediatek/

echo "==> Setting btusb options"
echo 'options btusb enable_autosuspend=0' | sudo tee /etc/modprobe.d/btusb.conf > /dev/null

echo "==> Stopping Bluetooth service"
sudo systemctl stop bluetooth || true

echo "==> Unloading modules"
sudo modprobe -r btusb btmtk bluetooth || true

echo "==> Reloading modules"
sudo modprobe bluetooth
sudo modprobe btmtk
sudo modprobe btusb

echo "==> Starting Bluetooth service"
sudo systemctl start bluetooth

echo "==> Bluetooth status"
bluetoothctl list || true

echo "==> Kernel log"
sudo dmesg | tail -n 20
