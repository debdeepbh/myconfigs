# Microphone recording
 
 Record from the microphone in wav format:
 arecord out.wav
 Or, more conveniently,
 rec out.wav
 
 The following commands require the package "sox".
 
 The package sox provides almost everything regarding audio handling. Here is how you can monitor your microphone input without recording it (with a dB monitor, that too, stereo):
 rec -n stat
 
 Without the dB monitor:
 rec -q -n stat
 
 Show it for 5 seconds then stop:
 rec -q -n stat trim 0 5
 
 Repeat after every 5 milliseconds:
 while true; do rec -q -n stat trim 0 0.05; done
 
 Repeat after every 5 milliseconds, but only show the Maximum amplitude in that 5ms time interval:
```
 while true; do echo $(rec -q -n stat trim 0 0.05 2>$1 | awk '/^Maximum amplitude/ { print $3 }') ; done
```
 
 Keep recording from standard output and echo 1 if the volume level is above certain threshold (0.15), and return 0 otherwise:
```
 while true; do echo $(rec -n stat trim 0 0.5 2>&1 | awk '/^Maximum amplitude/ { print $3 < .15 ? 0 : 1 }'); done
``` 

 Following similar command pattern, the following code mutes the master audio level if the input level is more than the threshold, otherwise unmutes:
```
 while true; do amixer set Master $(rec -n stat trim 0 0.5 2>&1 | awk '/^Maximum amplitude/ { print $3 < .15 ? 0 : 1 }'); done
```
 
 Returns "high" if the amplitude is higher than the threshold, or returns "low":
```
 while true; do ampli=$(rec -q -n stat trim 0 0.25 2>&1 | awk '/^Maximum amplitude/ { print $3 < 0.15 ? 0 : 1 }'); if [ $ampli -eq 1 ]; then echo "high"; else echo "low"; fi; done
```
 (Self-note: Very mysteriously, 3 > 0.15 ? 1 :0 does not work)
 
 Simulating key stokes:
 Package called "xdotool" can send keystroked to X11 like this:
 xdotool key k
 
 So, here is the code to simulate a keypress of "j" simulated ny a tap on the mic or a clap:
```
 while true; do ampli=$(rec -q -n stat trim 0 0.25 2>&1 | awk '/^Maximum amplitude/ { print $3 < 0.15 ? 0 : 1 }'); if [ $ampli -eq 1 ]; then xdotool key j; fi; done
```
 
 This can be used while endlessly scrolling 9gag/facebook page without hands. Best tool for forever alone guy.
 
# Dumping or redirecting your microphone feed through ssh
 arecord record the sound in CD quality in raw format

 arecord -f cd -t raw

 oggenc (need vorbis-tools for this) encodes the raw stream into ogg format (compression for low datarate)

 oggenc - -r 

 (note the extra - for some reason, check manpage)

 Finally log in to a remote ssh host and use their mplayer to play this encoded stream

 ssh user@host mplayer -


 Everything together:

 arecord -f cd -t raw | oggenc - -r| ssh user@host mplayer -

# Display the webcam feed with mplayer (play the webcam):
 
  mplayer tv:// -tv device=/dev/video0

 where /dev/video0 is the device.
 
98. Connecting another host though lan cable and  give it an ip address though dhcpd
 Install dhcpd ( note: it is not dhcpcd and is not installed by default)
 If the host (laptop) is going to have the ip 139.96.30.100, do the following.

  ip link set up dev enp7s0
  ip addr add 139.96.30.100/24 dev enp7s0

 Here, enp7s0 is your (laptop/server's) ethernet card. 
 ifconfig to check that the card really got the ip.

 Now we are going to follow what the archwiki page of dhcpd says.
 
 The config file should have the following:

	option domain-name-servers 139.96.30.100;
	option subnet-mask 255.255.255.0;
	option routers 139.96.30.100;
	subnet 139.96.30.0 netmask 255.255.255.0 {
	  range 139.96.30.150 139.96.30.250;
	}
 
 In this case, the dns is the server. The subnet mask has to be consistent with the ip range, whatever that means.
 You can also attach a static ip to a particular device if you like, by modifying the subnet "block" like this:

	 subnet 139.96.30.0 netmask 255.255.255.0 {
	  range 139.96.30.150 139.96.30.250;

	  host macbookpro{
	   hardware ethernet 70:56:81:22:33:44;
	   fixed-address 139.96.30.199;
	  }
	}	
 
 Finally, create the service file to run dhcpd though systemctl.
 /etc/systemd/system/dhcpd4@.service

	[Unit]
	Description=IPv4 DHCP server on %I
	Wants=network.target
	After=network.target

	[Service]
	Type=forking
	PIDFile=/run/dhcpd4.pid
	ExecStart=/usr/bin/dhcpd -4 -q -pf /run/dhcpd4.pid %I
	KillSignal=SIGINT

	[Install]
	WantedBy=multi-user.target

 To run this dhcpd on the network interface, run
	systemctl start dhcp4@enp7s0.service

 Now attach the other device to the server/laptop with a typical lan cable and see the lights flash. After some time, issue:
	ip neigh show
 You can see the other device's ip listed there. Most probably it will have the first ip possible, which is 139.96.30.150.
 Edit: ip neigh show does not show all the ips. cat /var/lib/dhcp/dhcpd.leases  might show some useful information.

* When ssh-ing to an user does not give you access to .bashrc
Do the following: 
Edit .bash_profile and add 
```
 	 	if [ -f ~/.bashrc ]; then
		  . ~/.bashrc
		fi
```

# Recording sound from output stream:
 
 * Open pulse audio, goto Volume control > Input Devices > Show: Monitors. You will see the bar responding to the output sound.
 * Click on the green tick sign to "Set as Fallback"
 * Open sound Recorder and record.
 
# Taking pictures through webcam 
 
 Easiest way:
 To take a picture while looking at the video feed:
 mplayer -vf screenshot tv://
 Press s to take a picture which will have names shot0001.png, shot0002.png etc.
 
 To play the webcam feed:
 mplayer tv://

 To specify particular device, do
 mplayer tv:// -tv device=/dev/video1
 
 To take a picture without any video feed:
 mplayer -vo png -frames 5 tv://
 and the desired picture is the 5th one, 00000005.png
 
 Using Mplayer (Haven't checked yet because of long list of arguments):
 mplayer tv:// -tv driver=v4l2:device=/dev/video0:width=1600:height=1200:outfmt=rgb24 -frames 3 -vo jpeg
 Using ffmpeg:
 
 ffmpeg -f video4linux2 -i /dev/v4l/by-id/usb-0c45_USB_camera-video-index0 -vframes 1 test.jpeg
 
 The author captures two frames and uses the second one:
 
 ffmpeg -f video4linux2 -i /dev/v4l/by-id/usb-0c45_USB_camera-video-index0 -vframes 1 test%3d.jpeg
 
 
 There is a software that does the job simply (not checked):
 fswebcam -r 640x480 --jpeg 85 -D 1 shot.jpg
 
# Streaming audio using cvlc: (not tested yet. GUI vlc streaming is straightforward and works :))
 
 you want a huge amount of streaming options, both in format and streaming protocols.
 
 VLC offers a huge range of options for both the protocol used to stream as well as the format of the stream. It also acts as both source and server, taking the audio input and streaming it (although it actually does this using the Live555 streaming media module). You can use http, rtp, rtsp among others and transcode the stream into pretty much any format you can think of. It can be quite complicated to setup. VLC can be run via a GUI or via the commandline using cvlc. The VLC wiki (http://wiki.videolan.org/Documentation:Streaming_HowTo) has lots of information about the various streaming options, but the documentation is sadly outdated. After lots of trial and error, I finally came to the following command that worked for me:
 cvlc -vvv alsa://hw:0,0 --sout '#transcode{acodec=mp2,ab=32}:rtp{dst=192.168.1.5, port=1234,sdp=rtsp://192.168.1.5:8085/stream.sdp}'
 
 This basically takes the microphone input, transcodes it into an MP2 file and then streams it via rtp to the address rtsp://192.168.1.5:8085/stream.sdp. If you then open "rtsp://192.168.1.5:8085/stream.sdp" in VLC on the client PC you get live audio, in near real time! The delay is about 1.5 seconds and requires*very little bandwidth. Sadly, there are three problems with this. First; only one client could connect at a time, secondly; the stream seems to fail after a while, sometimes after five minutes, sometime after two hours, but it would always fail and third it very CPU intensive (I am thinking this is why the stream failed on my box). 
 
 
