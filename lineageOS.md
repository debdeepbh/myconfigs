# LineageOS


For Pixel 6a, follow this beautiful [guide](https://wiki.lineageos.org/devices/bluejay/install/#installing-lineage-recovery-using-fastboot)

After downloading `android-platform-tools`, you must set up the udev rules so that your device can accessed in the bootloader mode. This is especially true if you are reverting back to stock android.


In the bootloader mode, if your

```
./fastboot devices
```

does not show the device, but

```
sudo ./fastboot devices
```

does show the device, you need to set up the udev rules.

### udev rules

The LineageOS suggest [this](https://github.com/M0Rf30/android-udev-rules#installation) repo. Once you clone the repo, you can run `sudo ./install.sh` to set up the rules. After that, `sudo` won't be needed to see the devices in the fastboot mode.


## Reverting back to stock android.

In google-chrome, open [https://flash.android.com/](https://flash.android.com/) and follow the steps.

- Need to turn on USB Degugging in the developer mode of the phone first
- Need to select `File Transfer` mode in the USB options in the phone after connecting the cable, otherwise `no device is found`.
- Ignore the `connection is slow, we recommend using a usb 3 cable`
- You can choose the default public release for the stock rom
- The steps will launch the bootloader mode on the phone, but no button press is needed. At this point, if you keep getting `connection issue`, you need check if

```
./fastboot devices
```

shows the device without the `sudo`. If not, you need to set up the udev rules.
