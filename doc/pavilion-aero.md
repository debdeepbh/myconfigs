# Pavilion Aero

Ubuntu 22.04 livecd preview works out of the box. However, certain things needs to be done for the installation to boot without issues.
The issue was: after installing the fully functional live usb, the screen freezes on random reboots.

- Turn off Secure Boot in BIOS (so that the hardware components are accessible by the installed version)
- While installing, connect to wifi
- Select "Download updates while installing"
- Select "Install third party software and drivers"

## [Works so far] Installing kernel version 5.17.5 immediately after installation

(via recovery mode and an usb, or on random lucky reboots when the screen does not freeze. Occasionally, the screen does not freeze when an usb is plugged in, but that might be just superstition.) 

Steps:

- Download `amd64` builds from [Mainline PPA](https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.17.5/) (skip lowlatency)
- Copy to USB drive
- On grub menu use `Recovery mode`. The `Drop to root shell`
- Plug in usb and mount, navigate to kernel deb files
- `dpkg -i *.deb`
- Reboot


