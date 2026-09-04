# Lock screen for terminal
 
 Note: It is  important to have a password for the user before issuing the command. Type:
 vlock -c 
 to lock the current virtual terminal. 
 vlock -a
 locks all the virtual terminals belonging to the user.
 It doesn't work on X11 so in order to lock everything, Press ctrl+alt+F1/12 to move to one tty which is logged in, or log in. Then issue this command. Once done, it doesn't let you press ctrl+alt+f2/12 to move to another tty.
 
 To set up a terminal based screensaver, use cmatrix. It gives you a matrix style screensaver without any screen lock facility.
 
 In order to use two of these prgram together, type:
 
 cmatrix; vlock -a
 
 It works fine. For aesthetic purposes, one user recommended:
 
 cmatrix -a -b -u 5; vlock -a
 
# Lock screen from terminal:
 
 In GNOME use "gnome-screensaver-command -l"
 
 In general this also works: "xscreensaver-command -lock"
 
 You may need to install required packages: gnome-screensaver and xscreensaver
 
 
# Experiments on lock screen on suspend and lid close

Facts (for Xubuntu):
* xflock4 runs the default lock-screen program, which is slock if light-locker is not running.
  Otherwise, light-locker will run (xfce's own lock screen window)
* xfce4-power-manager and /etc/systemd/logind.conf interferes with the lid response. 
- By default, xfce4-power-manager inhibits logind-related events and takes over the buttons and lid events. If this is not the case, check if logind has precedence by issuing 
```
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/logind-handle-lid-switch
```
or
```
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/logind-handle-power-key
```
- See the capabilities of `xfce4-power-manager` with
```
xfce4-power-manager --dump
```

- To specify which one manages the button or lid events, see [link](https://docs.xfce.org/xfce/xfce4-power-manager/faq#how_can_i_make_logind_handle_button_events_instead_of_xfce4-power-manager) 

- Install `pm-utils` to enable suspend (and possible hibernate) option if it is missing


## To use logind for suspend-on-lid-close

- first check if logind can suspend properly using

```
sudo systemctl suspend
```

- check if pressing the power button can suspend properly by uncommenting 

```
HandlePowerKey=suspend
```

in the file `/etc/systemd/logind.conf` and restarting logind using

```
systemctl restart systemd-logind.service
```

- allow `logind` to handle lid-switch

```
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/logind-handle-lid-switch -n -t bool -s true
```

- Uncomment the lines in `/etc/systemd/logind.conf`:

```
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
```

Read more on the [options](https://www.freedesktop.org/software/systemd/man/logind.conf.html)
Note: docked means an external display is connected

- restart logind

```
systemctl restart systemd-logind.service
```


---

### suspend and lock screen with logind and systemctl

We follow this link:
https://wiki.archlinux.org/index.php/Slock#Lock_on_suspend

First, we set up lock screen service using slock  when sleep target is triggered.

'/etc/systemd/system/slock@.service'
------------------------------------------

[Unit]
Description=Lock X session using slock for user %i
Before=sleep.target

[Service]
User=%i
Environment=DISPLAY=:0
ExecStartPre=/usr/bin/xset dpms force suspend
ExecStart=/usr/bin/slock

[Install]
WantedBy=sleep.target

Next, Enable the slock@user.service systemd unit for it to take effect for the username user:
`sudo systemctl  enable slock@debdeep.service`
do start to see if the script works (without closing the lid) 
`sudo systemctl  start slock@debdeep.service`
(expected behavior: slock will run)

Then, we follow this link to set up the lid response:
https://askubuntu.com/questions/1009387/laptop-doesnt-suspend-properly-on-closing-lid

/etc/acpi/lid.sh
----------------

#!/bin/sh

grep -q closed /proc/acpi/button/lid/LID0/state
if [ $? = 0 ]
then
  nmcli radio wifi off
	# note the change
  systemctl suspend
else
  nmcli radio wifi on
fi

Then, add this script to 

```
/etc/acpi/events/lm_lid
---------------------
event=button/lid.*
action=/etc/acpi/lid.sh
```

Finally, set the permissions and restart the services

sudo chmod 755 /etc/acpi/lid.sh
sudo /etc/init.d/acpid restart

Make sure to set HandleLidSwitch=ignore in /etc/systemd/logind.conf 
Actually, I have only HandlePowerKey=suspend option uncommented. I guess HandleLidSwitch=ignore is not really necessary. Then restart the logind service using:
sudo service systemd-logind restart



# Fixing the bug of disappearing clients on suspend
Update to version 4.3 where one of the changes was to stop awesome from removing all the screens, which is what I think was happening.

First, enable the `source code` repository in `software-properties-gtk`.
Then, install the latest version of awesome from github using
```
sudo apt build-dep awesome
git clone https://github.com/awesomewm/awesome
cd awesome
make package -j5
sudo dpkg -i build/*.deb
```
After the restart, the session awesome might vanish from the login window. Add the following to /usr/share/xsessions/awesome.desktop
```
[Desktop Entry]
Encoding=UTF-8
Name=awesome
Comment=Highly configurable framework window manager
TryExec=awesome
Exec=awesome
Type=Application
```


# Script to suspend the display

```
#!/bin/bash
## To be used by suspend.sh
grep -q open /proc/acpi/button/lid/LID*/state
if [ $? = 1 ]
then
    sleep 1; su -c "DISPLAY=:0 xrandr --auto" debdeep;
fi
```
