# Delete all even or odd numbered file in the directory
```
ls --color=none *.png | awk 'NR % 2 == 1 { print }' | xargs rm -r
```

Here, the option `--color=none` makes sure that the output of `ls` produces text-only string for `awk` and does not produce terminal color characters (e.g. try `ls > testfile`).


# Find out name of the linux distribution
 cat /etc/*-release
 typically, os-release has all the info, including the pretty name.
 For the linux kernel version, cat /proc/version
* Determine which physical disk partition mounted on a directory
 For example, the / filesystem is installed on
  df /
 The directory /root is located in
  df /root
 Conversely, to see a list of all block devices and their mountpoints,
  lsblk
 
# How to locate the path of a executable file: use `which`
```
which zathura
which vim
```

# Send messages to other users in terminal:
 
 The "wall" command will  post the strings followed to ALL logged-in user's terminal. Example:
 
 wall
 hi there
 ^D
 
 If you want to send a set of strings to a specific user's terminal who is already logged in, use:
 
 write target_username
 your text here
 ^D
 
 (Note: in order to receive message, the target user must have his mesg set to y. If not, he/she have to to issue the command: mesg y)
 
 (strange thing is that, you don't need sudo to broadcast a wall message where you have to depend on the target user's choice to send a message to one specific user. Counterintuitive, huh?)
 
# Adding environment variables like proxy etc permanently
 
 Add the data to the file /etc/environment, and/or the file /etc/bash.bashrc in appropriate form
 
# systemctl command
 Example: Adding dhcpcd to systemctl
 ln -s /usr/lib/systemd/system/dhcpcd.service /etc/systemd/system/multi-user.targer.wants/dhcpcd.service
 

