# ABD (Android development bridge) help
Short list from [some guy](https://github.com/sncvikas/ADB_Commands)
Long list from [android manual](https://developer.android.com/studio/command-line/adb)

* Run a shell command with `abd shell`, followed by the shell commands.
```
adb shell ls
adb shell stop
adb shell reboot
```
Alternatively, enter the shell with `abd shell` and run usual shell commands.

* Transfer file using `adb pull` and `adb push`
```
adb pull /sdcard/test.png
adb push ~/Downloads/test.apk
```

* Take screenshot using `screencap`
```
adb shell screencap /sdcard/screenshot.png
adb pull /sdcard/screenshot.png
```
Use `screenrecord` to record screen video.

* Package manager related tasks
All packages:
```
adb shell pm list packages
```

| Fileter packages   | parameter   |
| :----------------- | :---------- |
| System apps only   | `-s`        |
| Third party apps   | `-3`        |


* Install external apk using
```
adb install filename.apk
```

* Uninstall apps, from a user
```
adb shell uninstall com.example.MYapp
adb shell pm uninstall -k --user 0 com.MYApp
```
Reinstall them using 
```
adb shell cmd package install-existing com.onyx.latinime
```

* Disable an app (without installing)
```
adb shell pm disable <package_name>
```
The `<package_name>` can be found by searching with a string like this:
```
adb shell pm list packages -e | grep 'calculator'
```

* See the list of active internet connections
```
netstat -lantp
```

* Press a key
```
adb shell input keyevent <KEYCODE>
```
Example:
```
adb shell input keyevent  KEYCODE_MENU
adb shell input keyevent  KEYCODE_HOME
adb shell input keyevent  KEYCODE_BACK
```

* Enter text into a open text box
```
adb shell input text <text goes here>
```

* Reboot into the recovery mode
```
adb shell reboot recovery
```
* See system info
```
adb shell getprop
```

* Extract all apk files:
```
for i in $(adb shell pm list packages | awk -F':' '{print $2}'); do adb pull "$(adb shell pm path $i | awk -F':' '{print $2}')"; mv base.apk $i.apk 2&> /dev/null ;done
```

* Onyx uninstalled apps:
com.onyx.mail
com.onyx.appmarket
com.onyx.latinime
com.onyx.android.onyxotaservice
com.onyx.android.production.test
com.onyx.pinyinime
com.onyx.floatingbutton
com.android.browser
com.android.email
com.android.providers.calendar
com.android.calendar
com.google.android.syncadapters.calendar
com.quicinc.cne.CNEService

* Onyx installed apks:
```
gboard
fluid navigation bar
fx file browser
```

