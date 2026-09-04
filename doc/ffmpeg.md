# Converting media:
 
 sudo apt-get install ffmpeg libavcodec-extra-52 ( optional: libavcodec-unstripped-52 or libavcodec-unstripped-51)
 ffmpeg -i samjho\ na.flv -vn -ar 44100 -ab 128k -f mp3 samjho\ na.mp3
 
 ffmpeg -i Scorpions\ -\ Believe\ In\ Love.mp4 -ab 128k -ar 44100 -b 200k -r 20 -s 640x480 -aspect 4:3 -f avi BIL.avi
 follow somuda's blog: soumyashantnayak.blogspot.com

## mp4 encoding for mac and incorrect color in subsequent gif 
			
Mac computers cannot plot mp4 files that are generated from png files. So, we use the following encoding instead.
```
ffmpeg -i pacman_%3d.png -pix_fmt yuv420p vid4.mp4
```

* If the starting number in the input sequence is not 1, specify it using `-start_number <num>` before the `-i` option like this:
```

ffmpeg -start_number 50 -i pacman_%3d.png -pix_fmt yuv420p vid4.mp4
```

- The ending number cannot be specified but total number of files after the `start_number` can be used using `-frames:v` argument
```
ffmpeg -start_number 50 -i pacman_%3d.png -frames:v 150 -pix_fmt yuv420p vid4.mp4
```


- If you encounter the error that the height or width is not divisible by 2, instead of resizing manually, do
```
ffmpeg -start_number 1 -i img_tc_%5d.png -pix_fmt yuv420p -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -r 25 -crf 30 vid.mp4
```

- Use `-crf` along with framerate `-r` to produce smaller video
    * Larger the framerate, smaller and faster the video (good range 20-28)
    * Larger the `crf` smaller the video (good range 20-30)
- To increase the duration of each image in the video, use `-framerate` option which specifies how many frames to show per second (i.e. decreasing this value will increase the duration of each image).

```
ffmpeg -framerate 10 -start_number 1 -i img_tc_%5d.png -pix_fmt yuv420p -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -r 25 -crf 30 vid.mp4
```


Next, convert the output mp4 to gif to get correct color reproduction using
```
ffmpeg -i vid4.mp4 vid4.gif
```

- Combine multiple videos side-by-side using `hstack`
```
ffmpeg -i vid_1.mp4 -i vid_2.mp4 -i vid_3.mp4 -filter_complex hstack=inputs=3 vid_combined.mp4
```
 
# Convert m4a to mp3
 
 
 This shell script is quite handy for converting a directory of .m4a sound files to .mp3's. This script requires that you have LAME and FAAD2 installed already.

```
#!/bin/bash 
for i in *.m4a; do 
	echo "Converting: ${i%.m4a}.mp3" 
	faad -o - "$i" | lame - "${i%.m4a}.mp3" 
done
```
 
(Note: The $ evaluates the variable i. So, if you type `Converting $i`, no problem. The part `${i%.m4a}.mp3` means that it searches for the string '.m4a' in the end of `$i`, deletes it (if exists) and appends .mp3)
 
 You then need to make it executable, and move it to the /bin directory.
``` 
 su 
 chmod +x m4a2mp3 
 mv m4a2mp3 /bin/
```
 
 Now you can simply type m4a2mp3 in the shell and it will convert any M4A files contained within the current directory to MP3. The script does not delete the old m4a files, but that can be easily added to the script if you wanted.
 
