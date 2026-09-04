# Disk repair/error check
 Linux kernels mount devices read-only when their filesystems have errors. You can repair the filesystem with:
``` 
 sudo fsck.vfat -y /dev/sdc
```

 
 (replace sdc by the right one)
 
# Mounting unclean ntfs partition caused by windows
 
 install package called: ntfsprogs
 Then issue the command : ntfsfix /dev/sda1
 
# Moving /root to another partition
 Create new ext4 partition, say /dev/sda7. Mount it in a directory, say /otherlin
 Copy all data from /root to /otherlin using the following commands
  cp -urp /root/. /otherlin/
 Note that -r for recursive copy and -p is to preserve permission, date etc.
 Here, -u means update, i.e. doesn't overwrite already copied files. 
  Note that, cp -rp ~/* /otherlin
  	is not enough since it does not copy the dot files.
 Alternative tools suggested: rsync, and curl (nice use!) to have a progress bar etc.
 Find the UUID for the new partition using
  bkid
 Edit /etc/fstab and add the line
  UUID=daef66f2-4c7a-4daa-9d7d-f217a3a3994f	/root         	ext4      	rw,relatime,data=ordered	0 2
 Here, the UUIS should be replaced by the appropriate one.
 0 means it doesn't have to be backed up. 2 means the system checks the partition after the first one (1 is / so / gets checked first; 0 means no checking).

 Back up the current /root by 
  mv /root /root.old
 It failed the first time and had to uncomment the new line in fstab and reboot and try again to succeed.
 Remount all the drives by
 mount -a
# Fixing boot after erasing grub
 Install another linux, for example, Manjaro from USB livecd. It will come with its own grub. While booting through this new grub, if you get an error saying the UUID does not exist etc, edit the /boot/grub/grub.cfg file. Fix the UUID in the menuenry for the target linux. Usually, the the correct UUID appears in the first line, but in the lines containing the intiramfs, the UUID is messed up. Fix them in all the places. The config file should use the UUID of the old install, not the new one.
 
# Create a startup script to mount Hard disk drives:
 
  * Goto /media/ and create 3 directories called "windows", "disk3", storage".
 	cd /media/
 	sudo mkdir windows disk3 storage
  * Create a file named "mounting" with following content:
 
 ##startup script to mount the disk drives
 sudo mount /dev/sda1 /media/windows
 sudo mount /dev/sda3 /media/disk3
 sudo mount /dev/sda5 /media/storage
 #EOF
 
  * Change file permission to +x:
 	chmod +x mounting
  * Copy the file to /etc/init.d/:
 	sudo cp mounting /etc/init.d/
  * Update:
 	sudo update-rc.d mounting defaults
 
