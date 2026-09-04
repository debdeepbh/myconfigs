# Boot from LiveCD iso using GRUB:
 
 Add this to /boot/grub/grub.cfg in proper place with proper modification:
 
 menuentry "Booting ISO" {
  insmod part_msdos
  insmod ntfs
  set root='(hd0,msdos6)'
  loopback loop /new/liveDVDmint/ubuntu-11.10-desktop-i386.iso
  linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=/new/liveDVDmint/ubuntu-11.10-desktop-i386.iso noeject noprompt --
  initrd (loop)/casper/initrd.lz
 }
 
 The command "set root='(hd0,msdos6)'" is equivalent to mounting the 6th partition of the zero-th hard disk as root (/). The command 'insmod' is still unknown to me but the 2nd line (insmod ntfs) tells that the partition type is ntfs. The path name after "loopback loop" tells the location of the iso.
 The Last 2 lines are enough to resurrect any linux system with a kernel image (in this case, vmlinuz) and a ramdisk (initrd). Define their relative locations and you are good to go. For different distro, the location and names of kernel and initrd are different. Website says, this piece of code is enough to boot a linux:
 menuentry "My custom Linux" {
 set root=(hd0,5)
 linux /boot/vmlinuz
 initrd /boot/initrd.img
 }
 This is NOT tested. If does not work, then Maybe the the options are needed to be changed.
 
 For Windows, instead of kernel and initrd, use "chainloader +1" after defining root. A standard grub.cfg file is a good example.
 
 
