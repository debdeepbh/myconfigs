# Disable the  use of swap space

* To temporary turn off swap space and move all data to ram, turn off and turn on swapping:
```
sudo swapoff -a; sudo swapon -a
```

* Check the current swappiness using
```
cat /proc/sys/vm/swappiness
```
A value of 10 is recommended, which means the system will move ram to swap space (located in disk) if the available ram falls below 10%.

* To permanently set swappiness to 10:
```
sudoedit /etc/sysctl.conf
```
Add this line 
```
vm.swappiness = 10
```
Finally, restart system
```
    sudo shutdown -r now 
```

* With kernel version 3.5+ setting swappiness to 0 does turn it off entirely and a setting of 1 is recommended if you want the lowest swappiness algorithm. [source](https://www.percona.com/blog/2014/04/28/oom-relation-vm-swappiness0-new-kernel/)

