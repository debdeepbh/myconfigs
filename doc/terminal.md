# Incremental terminal history search:
 
 In terminal enter:
 
 gedit  ~/.inputrc
 
     then copy paste and save 
``` 
 "\e[A": history-search-backward
 "\e[B": history-search-forward
 "\e[C": forward-char
 "\e[D": backward-char
```
 
     FROM now on and many agree this is the most useful terminal tool saves you a lot of writing/memorizing... all you need to do to find a previous command is to enter say the first 2 or 3 letters and upward arrow will take you there quickly say i want: 
 
```
 for f in *.mid ; do timidity "$f"; done
```
 
 all i need to do is enter
 
```
 fo
 
```
 and hit upward arrow command will soon appear 
 
 
# Few Terminal keyboard shortcuts
 
 Ctrl-k 	clear all characters after the cursor 
 Ctrl-u 	Clears all characters before the cursor
 Ctrl-w 	clears word before the cursor. a word is set of characters separated by spaces
 Ctrl-l 	clear screen 
 
