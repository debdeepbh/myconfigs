# All about wifi
 
 Theory (vague):
 
 The wlan card is: wlp6s0
 The program "netctl-auto" automates the connecting process.
 "wifi-menu" creates a profile and keeps it in /etc/netctl.
 "netctl-auto start/enable <profile>" attaches the profile to netctl and finally,
 "netctl-auto start/enable netctl-auto@wlp6s0.service" forces wlp6s0 to connect to the internet using the <profile>.
 
 This clears up several jobs:
 
 * Setting up wifi for the first time:
``` 
 ifconfig wlp6s0 up
 to bring the wlan to life, if it was down.
```
 
 `wifi-menu`
 to create a profile.
``` 
 dhcpcd wlp6s0
```
 to get ip through dhcp.
```
 systemctl enable dhcpcd.service
```
 to make it work over reboots.
 
```
 systemctl start netctl-auto@wlp6s0
```
 to let netctl-auto handle the automatic connection
```
 systemctl enable netctl-auto@wlp6s0
```
 to make it work over reboots.
```
 netctl-auto enable <profile>
```
 to make the profile work over reboots.
 
 
 * Deleting a profile, while it is already enabled:
 
 The first step is to tell netctl-auto to stop using the profile.
 
```
 netctl-auto disable <profile>
```
 should do that. But unfortunately, it still uses the profile somehow. You can verify it by issuing "systemctl restart netctl-auto@wlp6s0" and see that it is again connecting to the same profile. THe solution is to delete the profile.
 
```
 rm /etc/netctl/<profile>
 netctl-auto disable <profile>
 systemctl restart netctl-auto@wlp6s0
```
 
 and "ifconfig" to verify that the wlp6s0 is free.
 
 Note that: there is no such method to stop the profile using a single netctl-auto command.
 
 * Setting up a new profile:
 
 To set up the profile, issue
 wifi-menu
 
 If you get error (maybe through journalctl -xn) that "the interface is already up", it means that the profile still exists somehow. Follow the previous steps of "Deleting a profile".
 
 After wifi-menu finishes creating the profile, if "systemctl enable/start netctl-auto@wlp6s0" is already issued, you should be able to connect. 
 Otherwise, issue
```
 systemctl start netctl-auto@wlp6s0
 systemctl enable netctl-auto@wlp6s0
```
 
 Optionally, use
 netctl-auto enable <profile>
 to make it an automatic profile.
 
 * Switching to a new profile:
 
 Use wifi-menu to create a new profile and use
 netctl-auto switch-to <profile>
 
 * Reconnecting to a profile:
 
 #start the netctl-auto service to activate an already enabled profile through "netctl-auto enable <profile>" command:
 
 systemctl restart netctl-auto@wlp6s0.service
 
 If the profile you are trying to connect to is not already enable, you can always connect to it by "wifi-menu". To enable dhcp service, make sure "dhcpcd wlp6s0" is already issued, or enabled (stays over reboots) using 
 systemctl enable dhcpcd.service
 
 
 A possible solution to slow wifi: Sometimes, page loads very fast just after the wifi is connected, then after a few seconds, it seems to get stuck.
 Tried the following and probably worked: blacklist the module b43:
 
 Create the file /etc/modprobe.d/blacklist.conf add add this in it:
 
 # Blocking the b43
 blacklist b43
 
 And reboot. So the module will not load by default. You can check this by:
 lsmod | grep b43
 
 So, here, we wish to use the module brcmsmac, and the dependent module bcma. Some online forum says that the this module is slower and wl module should be used even though it is very unstable and only found in AUR.
 
 Also, to stop the console beep, this might help:
 # Do not load the 'pcspkr' module on boot.
 blacklist pcspkr
 (The drawback is that if you want the beep sometimes, you will have to manually modprobe or insmod the module)
 
# Creating an access point in your system
 
 Link: https://bbs.archlinux.org/viewtopic.php?id=162895
 Download the create_ap directory from git or otherwise
 Not NAT or bridge needed. The script has options to set them or not.
 There are important dependencies. Check README or the create_ap file to find out.
 
 Running:
 
 systemctl disable netctl-auto@wlp6s0.service
 # So that is does not conflict with our .myscr file "wifi", where we enabled it)
 systemctl stop netctl-auto@wlp6s0.service
 # so that already running service stops as well, disabling it alone is hence not enough
 ifconfig wlp6s0 up
 # To bring the interface up (important)
 # Then enter the directory and see help to set up aps
 # For example, the share your LAN's internet through wifi access poing called "koboglo" with passphrase "lenovo1234"
 ./create_ap wlp6s0 eth0 koboglo lenovo1234
 
 
# Creating an access point in your system
 
 Link: https://bbs.archlinux.org/viewtopic.php?id=162895
 Download the create_ap directory from git or otherwise
 Not NAT or bridge needed. The script has options to set them or not.
 There are important dependencies. Check README or the create_ap file to find out.
 
 Running:
 
```
 systemctl disable netctl-auto@wlp6s0.service
 # So that is does not conflict with our .myscr file "wifi", where we enabled it)
 systemctl stop netctl-auto@wlp6s0.service
 # so that already running service stops as well, disabling it alone is hence not enough
 ifconfig wlp6s0 up
 # To bring the interface up (important)
 # Then enter the directory and see help to set up aps
 # For example, the share your LAN's internet through wifi access poing called "koboglo" with passphrase "lenovo1234"
 ./create_ap wlp6s0 eth0 koboglo lenovo1234
 
```
 
# Reconnect wifi and reload firefox's latest tab 
 
```
 # Reconnect wifi
 wifi
 
 # Sending Firefox the reload command, CTRL+R
 xdotool search --desktop 3 --class "Firefox" key --clearmodifiers "CTRL+R"
 # Here, --desktop 3 is necessary without which xdotools was unable to activate
 # The Number 3 is because firefox is located in the 4th taglist in awesome window manager. The count goes from 0,1,2,3,4,.. etc
 # You can find the desktop number using: xprop | grep WM_DESKTOP
 # and then clicking on the window with mouse
 
 # Activating the firefox window
 xdotool search --desktop 3 --class "Firefox" windowactivate                                       ```                 
 
# Turn off screen blackening/scrensaver:
 
 Turn off:
 
 xset s off
 
 To see the screensaver options:
 
 xset q
 
 To change screen timeout time to 1 hour:
 
 xset s 3600 3600
 

 
# Calculate the size of a directory including its subdirectories
The linux command `du` (see `man du`) estimates file space usage. To see the the total size of the directory `directory` along with all its subdirectories, do

 `du -sh direcory/`

 Here, the `-s` parameter shows the total sum of all the files and subdirectories and `-h` shows the result in a human readable format.

 To show the size of all directory and subdirectory in the current location in ascending order, use
 
```
du -sh ./* | sort -h
```

 Here, `sort -h` sorts in the human-readable format.

 This method does not show you the hidden files or directories. So, here is one trick to do exactly that:

```
du -sch .[!.]* * | sort -h
```

The parameter `-c` produces a grand total. The shell pattern following the parameters make sure we are searching for all files including the ones that start with a dot. Whatever. There is a program specifically made for disk analyzing and cleanup purposes and it is awesome. It's called [ncdu](https://dev.yorhel.nl/ncdu).
 Just install it and run `ncdu` and feel the wind.
 
# Print Screen in linux using imagemagick
 
```
import filename.png
```
 
 gives you a mouse pointer to click on the desired window to take a picture to filename.png.
 
 To take the full screen shot,
 
```
import -window root filename.png
```
 
 Numbering files so that they do not get overwritten (provided you take not more than one picture every second):
 
```
import -verbose -window root capture-$(date +%d-%h-%Y-%H-%M-%S).png
```
 
 In this case,
 
```
sleep 5; import -window root file.png;
```
 
 will be more effective.
 
 Does not work: Taking a screenshot of screen 0 (of DISPLAY 0)through some shell: If you log in through ssh and want to capture a screenshot at that moment, issue:
 
```
import -window root -display :0.0 -screen capture-$(date +%d-%h-%Y-%H-%M-%S).png
```
 
 
# Set up the correct time zone to avoid wrong date/time in Gmail/gtalk
 
timedatectl set-timezone Asia/Kolkata

For US, we can do
```
timedatectl set-timezone US/Eastern
```
Or, 
```
timedatectl set-timezone US/Central
```
(Note that these timezones are not available via autocomplete or listed in `timedatectl list-timezones`.)

You can check if the change is applied using

```
timedatectl status
```


 
* To see the current time date info,
 timedatectl status
 
 Doesn't work:To avoid the jumbled time over reboots between different OS like windows, force linux to use RTC time instead of it's usual UTC.
 timedatectl set-local-rtc 1
 
 Useful for now: Time synchronisation with a time server:
 timedatectl set-ntp true
 to activate this synchronisation, and to see if it is active:
 timedatectl status
 
 systemctl status chronyd.service
 should show the running daemon, but in this case, it is not working. Maybe you have to set it up. It launches a service which you can see by 
 systemctl status systemd-timesyncd.service  -l
 The Config file which has to be modified for this to work is:/etc/systemd/timesyncd.conf
 
 Final (standalone working solution):
 
 (a) Install ntp
 (b) Edit the config file: /etc/ntp.conf
 (c) Set up the right servers: By default it uses the arch severs and they should be enough. But for faster and/or more accurate syncing, we can use the indian servers which are up. The list can be found on: http://www.pool.ntp.org/
 
 For the time being, these are working:
 
 # indian and asian servers
 server 1.in.pool.ntp.org
 server 0.asia.pool.ntp.org
 server 2.asia.pool.ntp.org
 
 (d) Running the programme: A daemon is generally ran in the background so that the time can be synced all the time. But in our case, we only need to run it once whenever we need, without needing to write the daemon in the background. So, we run:
 
 ntpd -qg
 
 Here, -q is for one-time run. The -g parameter is very important since it allows ntp to sync time even when the time difference is significantly high.

 I guess it uses timezone info which should be preconfigured at your timedatectl. 

 (e) This process changes the system time only and NOT the hardware clock. That is why it does not persist over reboots. To keep this time, issue

 hwclock --systohc

 This actually sets the hw clock to be the local time. If you want to set UTC to be the hardware clock then use --utc along with --systohc.

 
 
# Show percentage bar while copying using cp
 (has to be a better way though)
 
 #!/bin/sh
 #
 # cpbar -- era 2008-05-21 for unix.com
 #
 # Depends:
 #  stat
 #  cp
 #  awk
 
 syntax () {
     echo "Syntax: $0 srcfile destfile" >&2
     echo " " "$@" >&2
     exit 1
 }
 
 test -r "$1" || syntax "File '$1' not found"
 test -d "$2" && syntax "Must name destination file ('$2' is a directory)"
 
 size=`stat -c %s "$1"`
 
 cp "$1" "$2" &
 cppid=$!
 
 trap 'echo; kill $cppid; rm -f "$2"; exit 127' 1 2 3 5 15
 
 while true; do
     nsize=`stat -c %s "$2"`
     awk -v f1="$1" -v f2="$2" -v size=$size -v nsize=$nsize '
 	BEGIN { printf "Copying %s to %s: %4.2f%%\r", f1, f2, 100*nsize/size }'
     case $nsize in $size) break ;; esac
     sleep 1
 done
 
 echo
 
 wait $cppid
 
 ###END
 
 
# Setting up static ip
 
 To set the ip and the netmask (subnet mask) (broadcast address will be set automatically, is it needed to change ever)
 
 ifconfig enp7s0 10.208.22.26 netmask 255.255.255.0 up
 
 Set the default gateway:
 ip route add default via 10.208.22.1
 
 Setting up dns:
 Edit the file: resolv.conf (beware: not resole.conf)
 Add the 
 nameserver 10.16.25.15
 
 
# To see the default programme for a certain filetype, we need xdg-mime.
 Note: now we can solve opening files through firefox download window.
 
 To get mime type of photo.jpg:
 
 $ xdg-mime query filetype photo.jpg
 
 photo.jpg
     image/jpeg
 
 Get default application
 
 To get default .desktop file starter for image/jpeg mime type:
 
 $ xdg-mime query default image/jpeg
 
 gpicview.desktop;
 
 Set the default file-browser
 
 To make Thunar the default file browser, i.e. the default application for opening folders:
 
 $ xdg-mime default Thunar.desktop inode/directory
 
 Set the default PDF viewer
 
 To use xpdf as the default PDF viewer:
 
 (wont work, read further)
 $ xdg-mime default xpdf.desktop application/pdf
 
 
 For a root user like myself, the above command won't work since I am not in one of those normal user scenario, so we will have to change the file
 /usr/share/applications/mimeinfo.cache
 and put the desired programme name.desktop as the first choice.
 Save the file and issue the xdg-mime query kind of command to check whether it worked or not. Worked for me.
 
 Example:
 Making ranger the default file manager:
 
 a. Target filetype is directory. We need the mime-type.
 
 file --mine-type -b random_directory
 
 We get the output: inode/directory. So, this is our target mime-type.
 
 b. Create a .desktop file for ranger. Save the following content in a file called ranger.desktop.
 
 [Desktop Entry]
 Name=Ranger
 Exec=ranger
 Terminal=true
 Type=Application
 MimeType=inode/directory;
 
 c. Install this .desktop file using:
 
 desktop-file-install ranger.desktop
 
 d. Check that this is installed in this location: /usr/share/applications/
 
 e. Now, make it the default application using (from any location):
 
 xdg-mime default ranger.desktop inode/directory
 
 f. Check that it is working using:
 xdg-open random_directory
 
 Note: There is an alternative to the step e. You can edit this file /usr/share/applications/mimeinfo.cache and manually type
 inode/directory=ranger.desktop;
 Or, you can engage many applications for one mime-type like this:
 inode/directory=ranger.desktop;thunar.desktop;nautilus.desktop;
 But the .desktop file which comes first becomes the default one.
 Note: Step e actually modifies  the file ~/.local/share/applications/mimeapps.list which is local (user-specific). Editing the actual /usr/share/applications/mimeinfo.cache actually applies to system-wide, but gets reverted on system update.
 
# Make the volume control for mplayer ( the keys 0 and 9) work, or make them independent of the system volume control:
 
 Create the file ~/.mplayer/config
 and add this line to it:
 softvol=1
 
 
# Reducing your screen brightness and add red colour at night so that you can fall asleep better, or not get blinded by electronic devices (like twilight in Android)
 
 Run it from command line or with systemctl.
 Set the latitude and longitude of your location in the config file:
```
 ~/.config/redshift.conf
```
 Set the screen to be 0, and other things. Set the colour temperature also.
 
 
# Managing tasks task warrior
 
 Install. It's called just task. pacman -S task
 Then run it. You'll be prompted to create the config file. Say yes.
 Modify the .taskrc file to use the light-256 theme, that works best with white terminal background. If you ever consider shifting to darker terminal, maybe explore the other themes, recommended: dark-256, obviously.
 
 git add the files .taskrc, and the directory .task so that you can have them forever.
 
 Basic commands: 
 Create a task: task add "Name of the task"
 List the tasks: task
 Mark a task done: task ID done (IDs are 1, 2 3, ... etc)
 Delete a task (including one that is done): task ID delete
 Modify a task name: task ID modify "new and modified task description"
 Add comments to already-existing task description (annotate): task ID annotate "and another thing"
 Add more info to a task: task ID modify project:projectname due:duedate
 Modify many tasks to add a common project name: task ID1 ID2 ID3 modify project:projectname
 Schedule a task to automatically disappear after a given time: task 1 modify until:eoy
 Schedule a task to automatically appear after a given time: task 1 modify wait:30th
 
 Modify(e.g. change tagnames) a set of tasks by some attribute(e.g. project) : task project:projectname modify +tagname
 
 Print [next] tasks with specific attributes:
 
 print all the tasks in the "prj" project name: task project:prj
 print all the tasks in the "prj" project name and empty tag name: task project:prj tag:
 take all the tasks with "prj" project name and empty tag name and give them the tag name "newtag": task project:prj tag: modify +newtag
 print all tasks which are started: task started (write "task reports" to see all possible options)
 
 Now, some more info, to be better: http://taskwarrior.org/docs/best-practices.html
 
  Assign a project to your tasks if possible:
 
 task ID modify project:Home
 
 Assign due dates where appropriate, for the important tasks:
 
 task ID modify due:31st
 
 When you start working on a task, mark it started:
 
 task ID start
 
 If you know the priority of a task:
 
 task ID modify priority:M
 
 Add useful tags to a task:
 
 task ID modify +problem +house
 
 Add the special tag +next to a task, to boost its urgency:
 
 task ID modify +next
 
 Represent dependencies, where appropriate, because there is a big difference in the urgency of a blocking task, than that of a blocked task:
 
 task ID modify depends:OTHER_ID
 
 Try not to have large, long-term tasks that will sit on your list forever. It can be very satisfying and motivating to complete tasks, so create more, but smaller, tasks. 
 
  
 Adding due dates:
 
 The rules for date and time format can be changed from rc.dateformat setting (find out how to change it), but the default setting is the British Convention.
 example:
 
 task add Open the store due:2015-01-31T08:30:00
 task add Pay the rent due:eom
 
 Other handy commands that can be used to mention due date/time:
 
 Date & Time
 
 Taskwarrior supports date and time values. Date fields are used to track task creation, due date, scheduled date, end date and so on, as well as providing a date type for use with UDA fields.
 
 Whichever format is used to accept and display date and time, Taskwarrior resolves it to a UTC epoch value, accurate to one second. This is called Unix Time, POSIX time, or Epoch time.
 
 But you have full control over the format entered and the format displayed, and this document is a demonstration of this.
 Due Date Example
 
 Let us begin with an example of specifying a due date when the task is created:
 
 $ task add Pay the rent due:2015-01-31
 
 Or adding a due date to an existing task:
 
 $ task add Pay the rent
 $ task 1 modify due:2015-01-31
 
 Finally removing a due date from a task:
 
 $ task 1 modify due:
 
 This examples uses the default rc.dateformat, which is Y-M-D, to read the date from the command line.
 rc.dateformat
 
 The rc.dateformat setting allows you to specify other formats for date input. An example is the default, Y-M-D, which means a date is:
 
     a 4-digit year ('Y')
     followed by a hyphen ('-')
     followed by a 2-digit month ('M')
     followed by a hyphen ('-')
     followed by a 2-digit day ('D')
 
 Here are the possible elements of rc.dateformat:
 
 m 	1 or 2 digit month number, eg '1', '12'
 M 	2 digit month number, eg '01', '12'
 d 	1 or 2 digit day of month number¸ eg '1', '12'
 D 	2 digit day of month number, eg '01', '30'
 y 	2 digit year, eg '12', where the century is assumed to be '20', therefore '2012'
 Y 	4 digit year, eg '2015'
 h 	1 or 2 digit hours, eg '1', '23'
 H 	2 digit month hours, eg '01', '23'
 n 	1 or 2 digit minutes, eg '1', '59'
 N 	2 digit minutes, eg '01', '59'
 s 	1 or 2 digit seconds, eg '1', '59'
 S 	2 digit seconds, eg '01', '59'
 v 	1 or 2 digit week number, eg '1', '52'
 V 	2 digit week number, eg '01', '52'
 a 	3-character English day name abbreviation, eg 'mon', 'tue'
 A 	Complete English day name, eg 'monday', 'tuesday'
 b 	3-character English month name abbreviation, eg 'jan', 'feb'
 B 	Complete English month name, eg 'january', 'february'
 Everything else 	All other format characters are taken as literals
 
 Including Time
 
 Using rc.dateformat you can specify a date with or without elements that include time. If your dateformat omits any time elements, then you just specify the date, and the time defaults to 00:00:00.
 
 An example shows this using a temporary override:
 
 $ task add Pay the rent due:2015-01-01
 $ task 1
 
 Name          Value
 ------------- ------------------------------------------
 ID            1
 Description   Pay the rent
 Status        Pending
 Entered       2015-01-02 16:57:44 (8 seconds)
 Due           2015-01-01 00:00:00
 Last modified 2015-01-02 16:57:44 (8 seconds)
 UUID          6eb7c4d7-6323-4ee3-bf13-63c580de3712
 Urgency       9.58
 
 $ task add Open the store due:2015-01-01T08:30:00 rc.dateformat:Y-M-DTH:N:S
 $ task 2
 
 Name          Value
 ------------- ------------------------------------------
 ID            2
 Description   Open the store
 Status        Pending
 Entered       2015-01-02 16:58:15 (6 seconds)
 Due           2015-01-01 08:30:00
 Last modified 2015-01-02 16:58:15 (6 seconds)
 UUID          bc8f9b89-8dea-4dae-87e5-b320b651c25c
 Urgency       9.419
 
 The first task added used the default rc.dateformat value of Y-M-D. You can see that the due date was recorded with time 00:00:00.
 
 The second task added specified an rc.dateformat override value of Y-M-DTH:N:S. You can see that the due date was recorded with time 08:30:00, as specified.
 
 You can specify date, or date + time, but whatever you specify must match your rc.dateformat setting.
 Reports
 
 The rc.dateformat setting is used for both specifying dates on the command line, and displaying them in reports. Most reports allow a further override, for report-specific display formats, such as rc.report.REPORT.dateformat, but there are others. See man taskrc for a complete list.
 
 For display purposes, there are two additional elements:
 
 j 	1, 2 or 3 digit day-of-year number, sometimes referred to as a Julian date, eg '1', '11', or '365'
 J 	3 digit day of year number, sometimes referred to as a Julian date, eg '001', '011', or '365'
 
 Synonyms 2.4.0
 
 In addition to formatted dates, you can use a date synonym instead:
 
 $ task add Pay the rent due:eom
 
 Here the synonym eom means 'end of the month'. Synonyms are a useful shortcut to entering lengthy dates. Here is the full set:
 
 now
 today 	
 sod 	
 eod 	
 yesterda
 tomorrow
 monday, 
 january,
 later, s
 soy 	
 eoy 	
 soq 	
 eoq 	
 som 	
 socm 	
 eom, eoc
 
 Here, eo=end of, so=starting of (the next), soc=starting of the current, d=day, w= week, m=month, y=year, q=quarter etc. See http://taskwarrior.org/docs/dates.html for more details.
 
 
  A recurring task is a task with a due date that keeps coming back as a reminder. Here is an example:
 
 task add Pay the rent due:1st recur:monthly until:2015-03-31
 
 
 To get rid of unnecessary info that is displayed, this page can be a lifesaver:http://taskwarrior.org/docs/verbosity.html
 
 The most useful info are:
 
 Adding the line
 verbose=no
 to the file .taskrc will help you get rid of the footnote and header.
 
 Here is an example of a custom report called "verybasic" which contains very specific columns that we want, in our desired order. Either add the following lines to .taskrc or add "task " to the beginning of every line and run individually in terminal (both have the same effect):
 
 report.verybasic.description='A list with very basic information, created by me.'
 report.verybasic.columns=id,project,tags,description.count,due
 report.verybasic.sort=start-,urgency-
 report.verybasic.filter=status:pending
 
 To make this report your default output report, add to your .taskrc:
 default.command=verybasic
 
 or, issue this command in terminal: task config default.command 'verybasic'
 
 To see this custom report in action, just run "task verybasic". Detailed documentation found at: http://taskwarrior.org/docs/tutorials/report.html
 
 To undo a change that you have made:
 task undo

 Task warrior has a very good calendar display with useful info showing. Use
  task calendar
 You can combine more commands to generate desired output.
 
 A task warrior front end vit. Compile from the AUR.
 I run into problems: vit freezes while I want to make any task done, or delete etc. Magically, it disappeared when I did this:
 I had a user-defined custom report which was not created carefully. I don't know which one was missing, but I recreated one from the "next" report, (only deleted some fields) and now it works fine. I think, the description.count was converted to description only. But I have to verify.
 
 Syncing your tasks through a remote server and have it on android:
 
 The website freecinc website provides a service to host your tasks so that you do not need to set up your own server (although, one day, I will set it up, when I have my own website). To use this, simply log in to the website and follow their instruction. After you are done, in order to sync manually, run "task sync" in your client and done. To automate it, add this to your crontab -e:

# Syncing task warrior
 3 */2 * * * task sync && notify-send "Syncing Tasks"
 and send a littel notification every time.
 
 In android, the app Mirakel gives you a way to upload a specially created config file so that you can sync with your server (freecinc, in this case). Format of this config file:
 
 
 username: foo
 org: bar
 user key: aa0f8f67-c20c-4476-b1c4-ed72f293006c
 server: localhost:6544
 client.cert:
 -----BEGIN CERTIFICATE-----
 …
 -----END CERTIFICATE-----
 Client.key:
 -----BEGIN RSA PRIVATE KEY-----
 …
 -----END RSA PRIVATE KEY-----
 ca.cert:
 -----BEGIN CERTIFICATE-----
 …
 -----END CERTIFICATE-----
 
 Get your username, org and server from the line starting with "taskd.credentials=" in the file ~/.taskrc. The format of that line is 
 	taskd.credentials=org\/username\/user_key (note that the org comes before the username)
 Get your server from the line staring with "taskd.server="
 Finally, insert the contents of the file `*.cert.pem`, `*.key.pem`, `*.ca.key`.
 Save it with any name and send it to the mobile phone so that you cam import it into mirakel.


 Tips:
  Use arithmetic operations in attributes:
  	task add newtask due:2days scheduled:due-1day

 
 My new favourite is inthe.AM. This one has a web frontend as well as a nice server. Works similarly. You have to login with your email.

 To use Mirakel effectively, I use these UDAs which are defined in my taskrc:
  

 
# Very nice image viewer with nice features (better than feh, except for the zooming part)
 
 pacman -S sxiv
 
 See then manage to see all the controls, most are very useful, similar to the vim keybindings, useful ones are:
 
 Enter to see the thumbnail mode
 w,W to best fit
 e,E to  fit image to height, width
 = to show 100%
 3j to scroll 3 times j
 85= to show it 85%
 b to toggle bars
 
 Question: how to delete the thumbnails generated? Where is the cache file?
 Answer: ~/.cache/sxiv
 
 Tips: Support opening .gifs: use `sxiv -a *.gif`
 Open all images recursively(means including subdirectories) in the current directory: sxiv -a -r .
 
 
# Making whole linux dark
 
 (I) Firefox:
 
 Change the firefox default page colors to dark background and white/yellow text
 
 Install plugin: Dark Backgrounds Switcher
 
 Change the menu bar and other components of firefox, without any plugin (developer option, from firefox 35 onwards, lucky me)
 Open about:config and look for the string: browser.devedition.theme.enabled
 Make it true by double clicking on that value.
 Press F12 to open developer mode, click on the wheel button on upper right corner, which is the Options button, scroll down to find "Dark Theme".
 
 
 (II) Xterm:
 
 Change the terminal color: Edit the file .Xdefaults and add the following lines if do not exist:
 ## color scheme for xterm
 #xterm*background: grey11
 #xterm*foreground: cornsilk1
 
 (III) Vim:
 
 Edit vim's spell check highlight color:
 Changing the colors scheme altogether is the key. Add this line to .vimrc:
 
 colorscheme slate
 
 This scheme seems nice for now, shift to better one when possible.
 
 (IV) task warrior
 
 In .taskrc, uncomment dark-green-256 theme.
 
 (V) Vimperator statusbar
 
 You have to set the colorscheme, can be downloaded other people's or use my own. Coming soon, or will be uploaded to github.
 
 (VI) Zathura
 
 In .config/zathura/zathurarc, add the lines:
 
 set recolor-darkcolor "#93A1A1"
 set recolor-lightcolor "#002B36"
 Now either add the line to the file
 set recolor true
 or issue it inside the programme to activate it.
 
 
# Remove mouse module and insert again to disable/enable mouse:
 
 rmmos psmouse
 removes the mouse
 
 modprobe psmouse
 inserts it back, have to wait for 5-6 seconds.
 
 
# Play video as background through mplayer
 
 mplayer video.ogv -rootwin -vf scale=1280:800 -noconsolecontrols
 
 
# Copying between terminals:
 
 Theory: Shift+Insert:
 
 Whatever is selected, be it by mouse or visual mode in vim, goes to the buffer. That means, copying to the buffer is done. No need to copy separately. That means, no need to press y to yank after selecting in vim, no need to press Ctrl+C in Firefox.
 Shift+Insert pastes. 
 Tips: avoid selecting anything else in the meantime at all costs.
 
 Theory: Ctrl+C:
 
 So, you are selecting a string before pressing Ctrl+C. Selecting it makes it available for Shift+Insert. Also, it makes it available for Ctrl+V also. So, both will give you same results.
 
 However, do the following, you'll end up with two different buffers to use whenever possible:
 1. Select text_a in firefox (text_a goes to Shift+Insert Buffer)
 2. Press Ctrl+C (text_a goes into Ctrl+V buffer)
 3. Select text_b (text_b goes into Shift+Insert buffer)
 
 Now, in firefox text field, you get the following:
 
 Shift+Insert -> text_b
 Ctrl+V 	     -> text_a
 
 But in xterm, you have only Shift+Insert available, so only text_b is available to you for terminal.
 
 Both of them are X commands.
 
 So, copying from firefox to terminal or vim is easy.
 What about the other way round?
 The only thing everybody talks about is the using screen. It gives you the functionality to copy-paste between different instances terminals within screen through some really weird key strokes.
 
 
# The solarized color palate has some nice symmetry. You just invert it and start from the top, removing the base color and stop wherever needed. The only benefit is that you can interchange between the dark-light schemes very fast.
 
 You can set the colors in the .Xresources file and done. The vim colorscheme will do the rest of the work. Beware though: xterm does not support many boldface colors for many colorcodes. So, you will have to change either the termianl, or the colors.
 
 In .Xresources file, replace all the colors in #define section with the TERM hex-codes, which you will find in the comment section. The result is not blues, though. But you will be able to use all the shades of grey, which is nice. Currently I am trying to look for replacements for the colors that are not supported
 
# GTK+ bookmarks:
 While locating file through GTK+ dialog box (e.g. "Save as" in Firefox or GIMP), you might want to create a "bookmark" of a directory that you want to access with one click. So generally you can drag and drop those directories to the left pane and they stay there. These locations can be saved/modified/added through the file ~/.gtk-bookmarks
 
# Loading the new .Xresources
 
 xrdb ~/.Xresources
 
 
# Using wicd
 Install wicd, wicd-gtk
 
 Run wicd
 Run dhcpcd on the wlan card: dhcpcd wlp6s0b1
 Finally, run wicd-gtk
 
 Then connect.
 
# Youtube viewer and downloader for terminal
 
 pacman -S youtube-viewer youtube-dl
 
 To launch, youtube-viewer
 or,
 youtube-dl URL
 
 See the manpage for more details.
 
# Simple client-server using netcat
 
 Important: Must install openbsd-netcat. I accidentally installed the gnu-netcat and it did not support many of the commands and the standard examples given in the internet failed.
 
 After installation, use it using nc.
 
 Open a listening port in the server: ( -l for lsten, -v for verbose)
 
 nc -l -v 1432
 
 Connect to the server
 
 nc server_name_or_ip 1432
 
 If it succeeds, cursors in both the computers will wait. Now type text in one to send it to the other.
 
# Pacman stuff:
 
 Instead of keeping track of every package you are installing using pacman, issue this to show all explicitly installed packages:
 
 pacman -Qei
 
 Note: -Q is the query mode, -e for explicitly installed, -i for detailed info about the packages.
 Now you can use grep, awk, sort etc to do whatever you want with them.
 
 To find all the orphan packages, issue
 
 pacman -Qdt
 
 Here, -d shows all the packages which were installed as a dependency of another packages. -t shows that are not required anymore.
 
# DNS server using ngrok and tcp tunelling (for sshing into the local machine):
 
 Download the ngrok software (Note; Do NOT install it through AUR as it is old)
 Extract it.
 At this point, you will be able to use http server using
  ./ngrok http 80
 In order to use ssh, you need to create an account. I logged in using github account  and did not have to create a account.
 Next step is authenticating the key that they provide you. It will be written in that login page only. Do that.
 Run the tcp tunnel using
  ./ngrok tcp 22
 Now you can log in to you local server using the global hostname:port that thy show in the forwarding tab.
 To get hold on this port number (so that you can dump it and git commit it), you need to do the following:
  wget http://localhost:4040/
  (Here, we are collecting the source code of the client API that ngrok creates for monitoring purposes)
  We get the index.html page in this process. Now we extract the address from it like this:
```
   cat index.html | grep "tcp://" | awk -F"/" '{print $3}' | awk -F"\\" '{print $1}'
```
  Now, we can easily update (git commit) this info so that we can access from anywhere. I mean, create a script to run ngrok and git commit together to dump this port information along with uploading it (to the git repo to use somewhere else)
 
# Cleaning up your Arch system
 
 1. Delete the log files.
 One big file is /var/log/journal
 You can delete its content but NOT the directory itself to temporarily make the boot process fast. 

 To set a global limit of maximum size of journal files, edit the file
 /etc/systemd/journald.conf
 and set

 SystemMaxUse=50M

 Delete /var/log/wtmp and wtmp.1 files for last login etc. Note: the command 'last' does not work. Will it work after reboot?

 2. Pacman old packages in cache
 There are nice commands for that which can be found in another topic.

 
# MTS Mblaze activation using usb_modeswitch
 
 Install the package usb_modeswitch. Reboot. It should work. If it doesn't:
 Do lsusb and look at the device and vendor number. I got 
  Bus 002 Device 005: ID 12d1:1f01 Huawei Technologies Co., Ltd. E353/E3131
 Here, we need the number 12d1:1f01. Which is our DefaultVendor:DefaultProduct.
 If we are lucky, we can find what command to pass by looking at
  /etc/usb_modeswitch.setup
 Here, search for this number and copy the whole section. I got:

``` 
 ########################################################

 Now, we just put this whole thing inside /etc/usb_modeswitch.conf. (Note: pasting these line after the content of the file did not work. I Deleted everything and then pasted it.)
 
 Now launch the programme using 
 usb_modeswitch -c /etc/usb_modeswitch.conf
 And it worked. Now you can lsusb and see that the numbers have changed.

 Note: this the manual process and for some reason it doesn't work automatically. The method that worked for me is this:
  uninstall usb_modeswitch: pacman -R usb_modeswitch
  Reboot: reboot
  Install: pacman -S usb_modeswitch
  Reboot: reboot
 The rebooting are important because /lib/udev/rules.d/40-usb_modeswitch.rules get modified and the effects are applied on reboots.
```
# Speeding up the internet using the fastest DNS server
 Install namebench. 
 There is a AUR repo for namebench. But it needs python2-graphy, which has to be installed from AUR first.
 After installing, run using: namebench.py
 After the test is finished, it will generate some results. You can visualize the data by opening the .html file that is generated in /tmp.

 In the router, go to My Network > Network Connection > Broadband Connection > Settings > DNS Server: Use the following DNS server (from dropdown) and set it.

 If using pi-hole to block ads, use the fastest DNS as the second DNS server. The first one should be the ip address of the Pi running a pi-hole.

# wpa_supplicant
 Find the network by scanning
  iwlist wlp6s0b1 scan | grep ESSID
 The list is NOT ordered according to signal strength.
 or, use wifi-menu but cancel it after it finds the ssids.
 
 To create a config file, see manpage of wpa_supplicant.conf
 
 Works only for home wifi (have to check for work wifi): If you do not want to store the password and create a config file, use wpa_passphrase
 wpa_passphrase ssid_name
 you shall enter the passphrase from stdin and will be encrypted.
 Now copy the code from the file and create a config file. Delete the commented line containing the actual password.

 Alternatively, you can do the following:

 For home wifi, this works:
 network={
               ssid="home"
               psk="passphrase"
          }

 For GWireless, this works:
 network={
        ssid="GWireless"
	key_mgmt=WPA-EAP
	eap=PEAP
	identity="netID"
        password="password"
 }
 
 For eduroam, this works:
 network={
         ssid="eduroam"
 	key_mgmt=WPA-EAP
 	eap=PEAP
 	identity="email id"
 	password="password"
 }
 
 To run the config file with debugging:
 
 wpa_supplicant -i wlp6s0b1 -c /path/of/config/file.conf -d
 
 To run it in the background, replace -d by -B
 
 Finally, run dhcpcd if not running  already by dhcpcd or systemctl restart/start/enable dhcpcd.service
 
# Install Broadcom WiFi Driver and restart to get internet access.
 
  
# IP and hostname resolution
 
 List hostnames and ips:
 arp -a
 avahi-browse -a
 For IP <---> Hostname, use resolveip: 
 resolveip IP/Hostname
 
 Sometimes, one way: IP --> Host: 
 host ip_address
 but most of the time this fails due to the DNS server, I think.
 For IP <--- Host, nslookup:
 nslookup host
 This also does not work for internal hosts.
 
# Live ports:
 
 Know the live ports of your OWN hosts, and the connected ips:
 sudo netstat -tpan
 
 Know if a particluar port is open or not in a remote host:
 nmap -p port host/ip
 
```
 nmap --script=smb-enum-users 192.168.2.167 -p 445|perl -le 'while(<STDIN>){if(/^.*?\\(\w+)\s+.*/) { print "$1"; }}'
```
 
