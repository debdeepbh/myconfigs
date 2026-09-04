# Wireless USB speaker
 
 For wireless(bluetooth) mouse, install bluez4. It should work.
 For USB speaker,
 cat /proc/asound/cards
 to see the available cards. In my case, the USB one is 2. Now edit vim 
 /usr/share/alsa/alsa.conf
 
 
 
 
 and change the line
 defaults.pcm.card 0
 to
 defaults.pcm.card 2
 and save.
 
 To accelerate the process of changing this value, I did this:
 Create another alsa.conf file next to it(i.e. in the same directory), called alsa.conf.other which contains the altered value i.e. pcm.card 2.
 cp /usr/share/alsa/alsa.conf /usr/share/alsa/alsa.conf.other
 vim /usr/share/alsa/alsa.conf
 (Edit the desired value and save it.)
 
 Now this code interchanges these two files:
 
```
# we have alsa.conf and alsa.conf.other. We want to interchange them.
cp /usr/share/alsa/alsa.conf /usr/share/alsa/alsa.conf.tmp
rm /usr/share/alsa/alsa.conf
cp /usr/share/alsa/alsa.conf.other /usr/share/alsa/alsa.conf
rm /usr/share/alsa/alsa.conf.other
cp /usr/share/alsa/alsa.conf.tmp /usr/share/alsa/alsa.conf.other
rm /usr/share/alsa/alsa.conf.tmp 
``` 
 
 
 
