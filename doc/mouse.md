# A fun script to rotate the mouse pointer (10 times) in a circle of radius 250 in clockwise direction. Needs xdotool package.
 
 # Script for fun rotation. Check manpage for more details

```
 for i in {0..3600}
 do
 	xdotool mousemove --polar $i 250
 done
```
 
 Note: An example is the .myscr script wifire
 
# Touchpad and vertical scrolling
 
 Installing xf86-input-synaptics will make your touchpad work except for the verticla scrolling.
 To enable it, open the file /etc/X11/xorg.conf.d/50-synaptics.conf
 In the first section:
 Section "InputClass"
 Identifier "touchpad"
 Driver "synaptics"
 		
 along with the other options, add this line
 
 Option "VertEdgescroll" "on"
 
 Now save and resrat xinit.
 
 
