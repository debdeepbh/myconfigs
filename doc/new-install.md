# Goto terminal and install:
 
 sudo apt-get install unetbootin gparted linuxdcpp ffmpeg libavcodec-extra-52 vim tree openssh-server default-jre
 
 * tree
 * vim
 * vlc
 * ubuntu studio theme (sudo apt-get install ubuntustudio-theme ubuntustudio-icon-theme ubuntustudio-wallpapers ubuntustudio-gdm-theme)
 * latexpdf (sudo apt-get install textlive-latex-base)
 * Limewire, Frostwire
 * Vuze {
 	INSTALL JAVA FIRST: sudo apt-get install default-jre
 	Then install vuze from anywhere (package manager/terminal/website)
 	(For total manual installation, see http://forlong.blogage.de/en/entries/2008/12/2/How-to-install-and-update-Vuze-formerly-Azureus-4-on-Ubuntu
 NOTE: A modification to be done in the tutorial given above: To add vuze to the menu, you need to create a file named vuze.desktop. Create the file in the location /usr/share/applications instead of /usr/local/share/application)
 	}
 * Others: Creox, bb
  
# Enable Visual Effects:
 
 * Enable Wobbly Windows
 * Enable Shift Switcher (Cover) and Change Shortcut to <Ctrl>+<Tab> for next window and <Ctrl>+<Shift>+<Tab> for previous window.
 
# Installing sound driver:
 
 * In terminal, write: sudo gedit /etc/modprobe.d/alsa-base.conf
 * In the end of the file, add this line: options snd-hda-intel model=6stack-dell (For that dell studio 1435)
 options snd-hda-intel model=ideapad (For lenovo ideapad Z560)
 * Save the file and Reboot.
 * Open pulse audio and enjoy full features.
 
# Handy Commands:
 
 See the size of partitions: 
 	df -h  
 		(-h stands for human-readable. It applies to 'ls' too)
 See the dependency of a package: 
 	apt-cache depends <package name>
 See the packages which are depndent on a package (reverse-dependency)
 	apt-get rdepends <package-name>
 Search for a package or metapackage: 	
 	aptitude search <search_string>
 See the list of open files:
 	lsof
 
# Manually download Flash Videos:
 
 (i)   Visit the YouTube video and wait for it to be downloaded fully.
     Then, run from the command line the command "lsof -n | grep Flash" which shows the files (even memory files!), and filters to those that have Flash in their name.
     You get something like "plugin-co 2461 user 17u REG 8,5 1693301 524370 /tmp/FlashXXVkHEM6 (deleted)".
 
     In Linux, if a file is deleted, it is actually gone only when all programs that opened it earlier are closed. That is, the Flash plugin is using a trick to hide the /tmp/FlashXXVkHEM6 file. It creates it and immediately deletes it. But since the Flash plugin keeps running, it can apparently still use it.
 
 (ii)   From the above line we note the number 2461, which is the process ID. In your case it will be probably different. Then, run "cd /proc/2461/fd" and finally execute "ls -l". This will show you the memory files, and specifically "lrwx------ 1 user user 64 2011-09-16 10:23 17 -> /tmp/FlashXXVkHEM6 (deleted)". The number 17 (in my case) is the filename you can use to access the deleted /tmp/FlashXXVkHEM6. Therefore, simply run "cp 17 /tmp/myyoutubevideo.flv" and you restore the Youtube Video!
 
 
