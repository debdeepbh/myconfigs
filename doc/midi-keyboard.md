# MIDI keyboard for linux

Add yourself to the `audio` group and then `reboot` or (log out and log in)
```
sudo usermod -a -G audio <username>
```

## On raspberry pi, to reduce the latency, add following to the file `/etc/security/limits.conf`
```
@audio   -  rtprio      90
@audio   -  memlock     unlimited
```

## Previous command shortcut in terminal
* `!!` is the last command from `history`
* `!^` is the first argument (i.e. the second word) of the last command, and `!$` is the last argument (i.e. last word of the command)
```
cp file1.txt file2.txt
mv !^ file3.txt
```
implies
```
mv file1.txt file3.txt
```
* `!-2` is the second last command from the history
* `!cp:1` is the fist variable of the last command starting with `cp` (verify)

