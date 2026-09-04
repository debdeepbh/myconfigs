# How to connect to hdmi
 xrandr 
   to find the HDMI connection. In this case, it is called HDMI-0
 xrandr --output LVDS --off --output HDMI-0 --auto
 Click on the checkbox " Mathe this the default X-Server screen" while selecting the external display.
 
 See the list of connected displays with 
  xrandr --current
 Set the HDMI0 to be the biggest screen and current laptop screen to be a small part of it by
  xrandr --output HDMI-0 --auto
 
 Turn off the hdmi temporarily with 
  xrandr --output HDMI-0 --off
 
 HDMI -Audio
 
 Use aplay -l to get the discover the card and device number. For example:
 
 $ aplay -l
 
 Now try different number to see which one actually works by
 
 $ aplay -D plughw:1,3 /usr/share/sounds/alsa/Front_Center.wav
 
 In my case, 1,3 works. Now Edit the .asoundrc to 
 
 pcm.!default {
     type hw
     card 1
     device 7
 }
 
 If Kodi cannot play audio with all the hdmi devices, try
 alsactl restore
 or alsactl kill quit and alsactl init

# Peforming xserver activities through tty or remote ssh shells:
 
 After logging in, set the DISPLAY variable to :0.0 or to :0 or any other if necessary (which can be found by issuing w command and looking at the "from" field)
 
 export DISPLAY=:0.0
 
 Then  issue your commands like you do in the terminal.
 
 Note: apparently you cannot run a gui program in other user's tty even by setting the DISPLAY to the user's tty.
 
# Adjusting brightness (The ultimate method)
 
 There is a directory that stores the values of backlight brightness. To go to the folder, do:
 ls /sys/class/backlight
 
 In our case, the result acpi_video0 is the directory. cd into the directory. Then ls. Among them, the file 'brightness' contains the value of current brightness.
 To see the current brightness, do:
  cat brightness
 You'll get 10 which is the maximum brightness.
 To change this brightness, simply replace the value with desired brightness:
 echo 5 > brightness
 
