# Alienware x15-r1

## Todo
[ ] [optional] Keyboard LED control
[x] [script does that, although flashy] redshift along with brightness
[x] [trivial] audio tick sound
[x] brightness control with redshift
[-] suspend on lid close
[x] lock screen on suspend
[x] ethernet adapter
[x] [nvidia-settings takes care of it] Bumblebee for Optimus (hybrid graphics)

## Fresh windows 10 install

**Conclusion:** Creating live usb via linux produces error that `Drivers are missing`. The only way out so far is to use a Windows computer to download `Windows media creating tool` (link only shows up in the browser visited from windows computer) and creating a `usb tool for another computer`. This tool has also an option to create an iso that can be `dd`ed to an usb later (not tested yet).

- Download windows 10 iso from microsoft
- To copy more than 4GB iso, we need exFAT (not FAT32) formatted disk. Install using
```
sudo apt install exfat-utils
```
- With ubuntu software `disks`, format the usb drive to `Compatible with all systems (dos)`. Add partition `Other` -> `exfat`.
- Mount the windows 10 iso and copy files into the newly created exfat partition within the usb drive.
- Unmount and wait until the busy symbol goes away.
- Before booting set to ACHI mode in bios (not tested)
- Booting with F12 and clicking on `Install` produces error `Driver not found`

## Dual-boot with windows: 
[link](https://askubuntu.com/questions/1257533/install-ubuntu-on-alienware-m15-r3)

- In the BIOS, turn off secure boot and set to ACHI
- Delete safeboot in windows: `bcdedit /set {current} safeboot minimal`
- Restart windows (automatically in safe mode) and selete safeboot: `bcdedit /deletevalue {current} safeboot`
- Restart and shrink partition
- Intall Ubuntu from usb

## Hardware drivers

- Ubuntu 20.04 does not work with wifi, touchpad
- Ubuntu (xubuntu) 21.10 (beta) comes with linux kernel 5.13.0, wifi works, but not touchpad
- Disable `secure boot` in BIOS for new kernels to load at restart (otherwise `initramfs` mismatch error will be thrown)
- Linux kernel 5.14.0 (beta): both wifi and touchpad work, 
- Brightness can be controlled using `xrandr` (buttons don't work): use the graphic device in use as a target brighness device. To make the changes made by `xrandr` to stay, stop redshift, adjust brightness, and the restart redshift.
- Turn off flashy leds in windows

### nvidia driver needs to be re-installed in the following way
- Go to `additional drivers` and select some other option than `properietary 370`
- It will install the other option and will fail to apply.
- Then revert back to `370` driver and apply again
- When done, restart, check if it is set at `370` and run `nvidia-smb` to see if it works 
- use `inxi -G` to see all available graphic devices and `glxinfo|egrep "OpenGL vendor|OpenGL renderer"` to see the currently active device

**Note:** After updating the kernel, you need to reinstall the nvidia driver (to compile it aginst the new kernel) by going to `Additional driver`, clicking on another driver that is not in use, applying it (it fails, so restart at time point), clicking on the desired one, and applying it again. Check the driver update is successful by issuing `nvidia-smi`

## Ethernet adapter

Mainly followed [this](https://ubuntu.com/server/docs/network-configuration) guide.

- Turn off Thunderbolt security in BIOS

- Check if the device is recognised when attached using `sudo dmesg`. Found a line like

```
[ ... ] cdc_ncm 4-2:2.0 wwx0c3796485dda: renamed from wwan0
```

This means a wired device is created and is renamed to wwx0c3796485dda. However, `ifconfig` shows no such device.

- See that the hardware is present using `sudo lshw -class network` or `ip a` but is is `DISABLED`. This means the device is not managed.

- (Not necessary if setting up the netplan later) Turn the device up using 

```
sudo ifconfig wwx0c3796485dda up
```
Now `ifconfig` shows the device.

- To make the Ethernet device ask for ip address, force it to run dhcp by creating a netplan in the file `/etc/netplan/99_config.yaml`

```
network:
  version: 2
  renderer: networkd
  ethernets:
    wwx0c3796485dda:
      dhcp4: true
```

and applying the netplan using

```
sudo netplan apply
```

- Now `ifconfig` shows it has the ip address and internet works.

- It is better to fix the logical name permanently by associating it with the Mac address in `/etc/netplan/99_config.yaml` but I don't do it here.

## Lid switch handling

By default:
- `sudo systemctl suspend` works as intended
- Lock screen only (no suspend) on lid close works as intended (both via logind and xfce4-power-manager),
- Suspend on lid close is *problematic* because the screen does not come back on after lid is opened. Basically the display `eDP-1` (in my case) is connected but disabled, which is not enabled by default.
So, ssh-ing into the computer, and issuing 
```
export DISPLAY=:0
xrandr --auto
```
resumes the screen.

Moreover, when the screen is frozen, `CTRL+ALT+F1` works for login. It is possible to issue `sudo lightdm restart` and log back in to tty7.


### Manually run `xrandr --auto` on lid open event: `sleep 1` is important

- Specify a script to run on any lid event in  `/etc/acpi/events/lm_lid`
```
event=button/lid.*
action=/etc/acpi/lid.sh
```

- Write the script `/etc/acpi/lid.sh` (which runs as root) to call `xrandr` as a user after waiting for a few seconds (this is crucial) 
```
grep -q open /proc/acpi/button/lid/LID*/state
if [ $? = 1 ]
then
    sleep 1; su -c "DISPLAY=:0 xrandr --auto" debdeep;
fi
```

- Make the script executable as root
```
sudo chmod a+x /etc/acpi/lid.sh
```

- Restart acpi service
```
systemctl restart acpid.service
```


### Other settings that go with this setup:

- Turn off the lid-switch related decisions by logind
```
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/logind-handle-lid-switch -n -t bool -s false
```

- Comment out all lines in `/etc/systemd/logind.conf`, in particular, the lines with `LidSwitch`

- Allow `xfce4-power-manager` to launch at startup

- Set the following in the settings:
	- `General > Bottons`: `Do nothing` for all except `When power botton is pressed: Suspend`

	- `System > On Battery`: `When inactive for (slider): Never` and `When laptop lid is closed: Lock screen`
	- `System > Plugged In`: Same as `On Battery`
	- `System > Security`: `Lock screen when system is going to sleep`

	- `Display > On Battery`: `Put to sleep after: Never`, and `Switch off after: Never`
	- `Display > Plugged in`: Same as on battery

## Crackling and popping sound on headphone when idle
Turn off power saving feature using
```
pactl unload-module module-suspend-on-idle
```

To make the change permanent, comment out a line in a file
```
sudo sed -i 's/load-module module-suspend-on-idle/#load-module module-suspend-on-idle/g' /etc/pulse/default.pa
```

