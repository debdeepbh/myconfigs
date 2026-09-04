# Video recording from command line

* Using command line `vlc`

```
cvlc v4l:///dev/video0 --sout file/avi:movie.avi
```
* Using ffmpeg
ffmpeg -f video4linux2 -s 320x240 -i /dev/video0 out.mpg

* To take picture,
```
sleep 1s;gst-launch-0.10 v4l2src num-buffers=1 ! jpegenc ! filesink \
location=$HOME/Pictures/failedlogin.jpg
```
[Source](http://ubuntuforums.org/showthread.php?t=1418586)

```
gst-launch-extra v4l2src ! videorate ! video/x-raw-yuv,width=640,height=480,framerate=15/2 ! ffmpegcolorspace ! theoraenc quality=20 ! oggmux name=mux alsasrc ! audio/x-raw-int ! audioconvert ! queue ! vorbisenc ! mux. mux. ! shout2send ip=172.19.3.113 port=8000 password=password mount=webcam.ogg
```


## Network streaming

* Stream video using RTP and network elements.

On the server, issue
```
gst-launch  v4l2src  !  video/x-raw-yuv,width=128,height=96,format='(fourcc)'UYVY ! ffmpegcolorspace  !  ffenc_h263  !  video/x-h263  !  rtph263ppay pt=96 ! udpsink host=127.0.0.1 port=5000 sync=false
```

Use this command on the receiver:
```

gst-launch   udpsrc   port=5000   !   application/x-rtp,  clockrate=90000,payload=96 ! rtph263pdepay queue-delay=0 ! ffdec_h263 ! xvimagesink
```

* Following script will start the http server. It will start listing for requests for http streaming on your linux machine (IP-192.168.91.77) on 8080 port. It will not stream start sending packets on network until it gets a request from a client. Now to test this, open vlc player on any other machine and try capturing the network stream by typing http://192.168.91.77:8080. You should see webcam frames.

```
#!/bin/bash
/etc/init.d/httpd restart
vlc -vvv v4l:/dev/video0:norm=secam:frequency=543250:size=640x480:channel=0:adev=/dev/dsp:audio=0 --sout '#transcode{vcodec=mp4v,acodec=mpga,vb=3000,ab=256,vt=800000,keyint=80,deinterlace}:std{access=http,mux=ts,dst=192.168.91.77:8080}' --ttl 12
```
you can play around with the codecs and other options.

* After removing audio, the modified script:

```
#!/bin/bash
/etc/init.d/httpd restart
vlc -vvv v4l:/dev/video0:norm=secam:frequency=543250:size=640x480:channel=0 --sout '#transcode{vcodec=mp4v,vb=3000,vt=800000,keyint=80,deinterlace}:std{access=http,mux=ts,dst=192.168.91.77:8080}' --ttl 12
```

