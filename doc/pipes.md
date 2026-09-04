34. Interaction between different consoles through pipes:
 
 In a console, create a pipe names mypipe using mkfifo:
 mkfifo mypipe
 
 (You can see that this file is a pipe by ls -l mypipe)
 
 To use these pipes, redirect the output of a command (say ls -l) to mypipe via:
 ls -l > mypipe
 (the cursor will wait)
 
 Now goto another console and take that output out of the pipe via:
 
 cat < mypipe
 (The cursor on the other console will resume)
 
