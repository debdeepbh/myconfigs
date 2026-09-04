# Enabling cron job for arch linux
 
 systemctl enable cronie
 
 (Cron for arch linux in NOT enabled by default. So you must start it.)
 
 Setting vim to be the default editor:
 
 echo "EDITOR=vim" >> /etc/environment
 echo "VISUAL=vim" >> /etc/environment
 (It needs restarting/relogging-in to read from environment file. To get instantly, use: export EDITOR=vim etc)
 
 My current crontab entry is: 
 
 
 # Minute   Hour   Day of Month       Month          Day of Week        Command    
 */10 */3 * * * cd /storage/Lenovo/lin && ./agitifyTODO.sh >> outfile 
 */10 */3 * * * ./updateArchy.sh 
 # Supposed to happen every 10 minute of every 3rd hours
 
 #*/2 * * * * export DISPLAY=:0 && zenity --info --text "hi"
 # Pop up every 2 minutes
 
 The files agitify.sh and updateArchy.sh can be found in my github.
 
