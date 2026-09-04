# Setting up raspberry pi zero w

Ethernet over usb:
Follow the popular guide to add two lines related to modules in the first (boot) partition:
1: open up the boot partition on the micro sd with finder and in the file config.txt add dtoverlay=dwc2 to a line on the bottom and save it.
2: Create a new file called ssh using textedit and save it onto the boot partition. Use 'get info' to remove the extension on the file, and it should appear as an EXEC file. You can now eject the card and boot it on your RPi
3: Finally, open up the cmdline.txt. replace all text with this:

dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait modules-load=dwc2,g_ether quiet init=/usr/lib/raspi-config/init_resize.sh 

Edit /etc/network/interfaces to add usb0 related info:
allow-hotplug usb0
iface usb0 inet dhcp 

Plug in a *good* usb cable to the usb port, not the power in and then set up the retrying nm-applet attempt to connect to the wired network and fail repeatedly. At this point, you can connect to the pi using ssh pi@raspberrypi.local
If the repeated attemp to connect and fail message from nm-applet is bothersome, run dhcpcd enp7e0u1i7 (or whatever is the hardware name from ifconfig) on your laptop. Note: dhcpcd in not installed by default so install it using sudo apt-get install dhcpcd5

For wifi:
Use wpa_passphrase <ssid_name>  to get the config file. Add it to /etc/wpa_supplicant/wpa_supplicant.conf
Next, add the following to /etc/network/interfaces
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

You can set up multiple networks in the wpa_supplicant.conf file and the first available one will be used (I think. Or, maybe wrt signal strength? However, it is working according to order of appearance)

# Running script for motion

To call scripts from motion via `on_picture_save` or `on_event_end`, we need to make sure that the script is accessible by the user _motion_. The software motion creates a user called motion.

To make files and directories owned by (and hence accessible by) the user motion and the group motion, we need to issue
```
chown -R motion:motion dir_within_anoter_user
```

Note that, motion cannot even write to a location that is owned by another user even when we run motion as super user (via `sudo systemctl motion start`).

# MotionEye on usual Ubuntu

```
sudo docker create -v $HOME/Pictures:/pics -t -p 8765:8765 -p 8081:8081 --shm-size=4096m --name motioneye --privileged=true -e TZ=Asia/Colombo --restart="always" ccrisan/motioneye:master-amd64
```
This starts docker with an additional mount point where `$HOME/Pictures` exists.

- run
```
sudo docker start motioneye
```

- Set admin password
- Turn on `Movies` or `Still images`
- `File Storage`: select the storage device with appropriate size. In Root directory, `/` means `/pics` (set while creating the docker)
- Apply to take effect

- See the installed docker images with 
```
sudo docker images -a
```

- Uninstall an image with

```
sudo docker image rm ID
```

# MotionEye on raspberry pi
- Convert the image file `.img.xz` file into `.img` using `unxz`.
```
unxz motioneye.....img.xz
```
- Copy to sd card
```
sudo dd if=motioneye....img of=/dev/sdb bs=4M
```
- Set the wifi information in the 30MB partition that contains `boot.ini` files etc by creating `wpa_supplicant.conf` file with
```
country=US
update_config=1
ctrl_interface=/var/run/wpa_supplicant

network={
    scan_ssid=1
    ssid="MyWiFiSSID"
    psk="password"
}
```
* Let it boot and log in using `user:admin` `pass:<blank>` to the web interface and set an new passwd

- Port forwarding to raspberry pi with internal port:
	- Web interface: 80
	- Camera stream: 8081 

- Improvement settings:
	- Delete local files everyday

- Set up google photos
[instruction](https://github.com/ccrisan/motioneye/issues/1607#issuecomment-656123443)
	- Click `Enable API`
	- create  project
	- specify product name
	- Select Oauth type `Desktop App`
	- save the keys
	- Enable `Enable debug` in `Expert settings` in web interface of motioneye (now ssh connection can write into the filesystem)
	- Retrieve a file from the motioneye server via ssh from 
	```
	scp admin@192.168.0.133:/usr/lib/python2.7/site-packages/motioneye/uploadservices.pyc ./
	```
	- Make a backup copy 
	```
	scp admin@192.168.0.133:/usr/lib/python2.7/site-packages/motioneye/uploadservices.pyc{,.bak}
	```
	- Replace the string `"349038943026-m16svdadjrqc0c449u4qv71v1m1niu5o.apps.googleusercontent.com"` with your client ID
	- Replace the string `"jjqbWmICpA0GvbhsJB3okX7s"` with your client secret
	- Save the file
	- copy it back to the server
	```
	scp uploadservices.pyc admin@192.168.0.133:/usr/lib/python2.7/site-packages/motioneye/uploadservices.pyc
	```


