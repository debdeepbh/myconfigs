# Detaching a process from terminal:
 
 The usual method is to add an & after it. For example: firefox &
 But when you have already issued the command and the process demands the terminal to stay in place, and you do not wanna restart the process with &, this might help:
 Press ctrl+z to stop the process
 Then type: bg 
 to send it to the background as a job
 Then type: disown
 to declare that you are disowning the job from the current terminal so that you can close the terminal without affecting the process.
 
 
# Killing processes
 To find the pid of the process, do
  pidof processname
 or,
  ps aux | grep processname
 To kill process with pid
  kill pid
 To kill stubborn unresponsive process
  kill -9 pid
 To kill all processes with name
  killall processname
  killall -9 processname
  
 Unmounting partitions in use: Find out which process is using it by
  lsof | grep /mountpoint
  killall/kill [-9] processname/pid 
