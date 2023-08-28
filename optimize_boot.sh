#!/bin/sh
#This script reduces boot times from 6s+ to less than 2s on the RPi4B
#Wi-Fi and network settings will NOT be touched!
#Only script after having setup up your stuff!

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or using sudo" 
    exit 1
fi

echo '
[all]
initial_turbo=30
disable_splash=1
dtoverlay=disable-bt
boot_delay=0
dtparam=audio=off
' >> /boot/config.txt

sed -i '1s/$/ isolcpus=3 loglevel=3 quiet logo.nologo consoleblank=0 fastboot/' /boot/cmdline.txt

systemctl disable triggerhappy
systemctl disable systemd-timesyncd
systemctl disable polkit
systemctl disable ModemManager
systemctl disable avahi-daemon
systemctl disable dphys-swapfile
systemctl disable keyboard-setup
systemctl disable apt-daily
systemctl disable raspi-config
timedatectl set-ntp false
apt-get remove bluez bluez-firmware pi-bluetooth pigpio
journalctl --vacuum-size=1G --vacuum-time=3d --vacuum-files=5
