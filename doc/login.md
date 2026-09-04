# Auto login to arch
 
 Create the file:
 /etc/systemd/system/getty@tty1.service.d/autologin.conf
 ( Create directories whenever necessary)
 
 Then enter the following:
 
 [Service]
 ExecStart=
 ExecStart=-/usr/bin/agetty --autologin root --noclear %I 38400 linux
 
 And save it. Here is the actual link with a few more options. Probably has info about faster booting method.
 https://wiki.archlinux.org/index.php/Automatic_login_to_virtual_console
 
