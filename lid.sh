#!/bin/bash
## To be used by suspend.sh
grep -q open /proc/acpi/button/lid/LID*/state
if [ $? = 1 ]
then
    sleep 1; su -c "DISPLAY=:0 xrandr --auto" debdeep;
fi
