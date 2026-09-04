# Search for all http links in a file by grep

``` 
 cat filename | grep 'http://[^"]*'
```

 Alternatively, and more intuitively (more useful too), extracting mp3 links from a html file in Vim:
 
 Open the file. Type:
 gg
 (goto the beginning of the file)
 /\.mp3
 (searches for all occurrence of .mp3 and the cursor waits on the first occurrence of it)
 qr
 (starts recording a macro named r)
 yi"
 (yanks all link inside " " and cursor moves to the beginning of the corresponding " ")
 G
 (goes to the end of the file)
 o Esc p
 (Inserts a new line and goes to normal mode and pastes the link in the end)
 (two back ticks. Two single apostrophies also work)
 (to go back to the previous cursor position, which is the beginning of the " ")
 nn
 (Here, the number of n's may vary depending on the format of the page. first n takes the cursor to .mp3 inside of the current " " and the second takes it to the next one, which maybe part of the text in a hyperlink rather than being part of a link. In that case you need to enter 3 n's i.e. nnn)
 q
 (now that we have completed the loop, we stop recording the macro, which was named r)
 
 Now press @r to run the macro once more and the 5@r to repeat it 5 times. At the end of the process, you have a all the links at the end of the file, which you can yank and paste in a file called dumpfile.  
 
 The whole sequence of key presses to create the macro named "r" is: 
 gg/\.mp3<Enter>qryi"Go<Esc>p``nnq
 
 (note: here the `` two backticks, not apostrophies. Remember this otherwise it might cause trouble)
 
 Notes: Instead of using  two backticks, which may give "mark not set" error, you can actually set a mark every time the cursor is on the search string by giving it a name (say b) using mb. When jumping to that position, use \``b` and it will be back to that position again.
 
 You can save the macro named r inside .vimrc using
 let @r = 'yi"Go<Esc>p''nnq'
 
 Inside vim you can actually issue "rp to paste the content of the macro to copy it to vimrc.
 
 Then you can dump the output in a file by >> and wget -i dumpfile to download them.
 
 Note: A better and much faster way to download all the files:
 
 cat dumpfile | parallel --gnu "wget -c -b -q {}"
 
 alternatively:
 
 parallel -j #number wget < dumpfile
 
 
 Caution: stopping wget (pkill) and restarting has some weird download issue.
 Try not to stop the wget once it's running. Weird. Even with -c. Needs to be checked.
 
 
 This command requires a package called parallel which allows parallel downloads unlike a "wget -i listfile".
 Here, -c resumes partially downloaded file download, -b sends the wget processes to background, and -q is for quiet mode, i.e. does not generate a logfile while downloading. One problem is that you cannot see the progress of the downloads which is the price of -q, otherwise, you can always cat the wget-logfile to check the download progress. But, doesn't matter if the connection is reliable, because we don't want thousands of log files to fill up our space.
 
