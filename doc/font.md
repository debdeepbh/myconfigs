# Making the default font of Arch linux pretty
 
 To enable the effect for one user, create a file called .fonts.conf and copy this xml code inside:
 <?xml version="1.0"?>
 <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
 <fontconfig>
   <match target="font" >
     <edit mode="assign" name="rgba" >
       <const>rgb</const>
     </edit>
   </match>
   <match target="font" >
     <edit mode="assign" name="hinting" >
       <bool>true</bool>
     </edit>
   </match>
   <match target="font" >
     <edit mode="assign" name="hintstyle" >
       <const>hintslight</const>
     </edit>
   </match>
   <match target="font" >
     <edit mode="assign" name="antialias" >
       <bool>true</bool>
     </edit>
   </match>
   <match target="font">
     <edit mode="assign" name="lcdfilter">
       <const>lcddefault</const>
     </edit>
   </match>
 </fontconfig>
 
 Now, to make it available system-wide, copy the same xml code in a file called 29-prettify.conf and place it in /etc/fonts/conf.avail/
 Then make a symbolic link by:
 ln -s /etc/fonts/conf.avail/29-prettify.conf /etc/fonts/conf.d/29-prettify.conf
 Now run:
 fc-cache
 
 Now it should work.
 
# Uninstall infinality font sets:
 
 sudo pacman -S --asdeps lib32-freetype2 lib32-cairo lib32-fontconfig
 
 Then restart the x-server: pkill xinit
 
