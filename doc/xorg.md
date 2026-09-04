# investigation on Xorg's memory leak

The following process fills up the memory and eventually shuts down the computer overnight, especially when the computer is idle:
```
 3 SIGQUIT         989 root       39  19 4244M 3164M 3128M S  0.0 20.0  0:00.00 /usr/lib/xorg/Xorg -core :0 -seat seat0 -auth /var/run/lightdm/root/:0 -nolisten tcp vt7 -novtswitch
```

### Attempts:
- Since the memory leak happens when the system is idle, it might be related to the screensaver, which may be attempting to launch and is failing. Lock screen requires the power manager to launch.
So, I am adding this to `.config/i3/config`:
```
exec --no-startup-id xfce4-power-manager #experimental, to see if the xorg-lightdm memory leak is resolved
```

- Found another occurrence on the internet, but what does that mean?
[reddit](https://www.reddit.com/r/archlinux/comments/89ytwa/x11_eats_up_my_memory/)
```
Update: After disabling all xscreensaver screensaver (using just blank black colour) and starting it via xscreensaver -nosplash & there has been no more memory leaks.
```

- Deleting `/usr/share/X11/xorg.conf.d/20-intel-backligh.conf` that I created during installation via `todo_xubuntu`. Thus resolves gui programs crashing like latexdraw, gmsh, fltk backend of python, octave plots etc.

