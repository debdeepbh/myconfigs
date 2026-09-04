# fingerprint login
[instruction](https://www.reddit.com/r/LinuxOnThinkpads/comments/8qmqvz/enabled_t420_fingerprint_reader_for_sudo_login/)

### full script
```
sudo apt-get install libfprint-2-tod1 libpam-fprintd

wget -c http://dell.archive.canonical.com/updates/pool/public/libf/libfprint-2-tod1-goodix/libfprint-2-tod1-goodix_0.0.6-0ubuntu1~somerville1_amd64.deb

sudo dpkg -i libfprint-2-tod1-goodix_0.0.6-0ubuntu1~somerville1_amd64.deb

sudo pam-auth-update

fprintd-enroll -f right-little-finger

```

### step by step

- get driver (amd64.deb) from [link](http://dell.archive.canonical.com/updates/pool/public/libf/libfprint-2-tod1-goodix/)
- install dependency for the driver package
```
sudo apt-get install libfprint-2-tod1
```
- install the downloaded `.deb` (amd64) package using `sudo dpkg -i`
- install pam library
```
sudo apt-get install libpam-fprintd
```
- [unnecessary, it seems] Now edit the common-auth file
```
sudo vim /etc/pam.d/common-auth
```
In the file common-auth, add the line above the section "Primary Block", it will be the first non-comment line. Save the file and exit editor.
```
auth sufficient pam_fprint.so 
```

- Start auth-update by
```
sudo pam-auth-update
```

- enroll fingerprint using
```
fprintd-enroll -f right-little-finger
```

- Test it out with `sudo -i` and lightdm login page

### configs
- Set up the timeout (waiting time for fingerprint before resorting to password) in `/etc/pam.d/common-auth` with `timeout`. Modified line looks like time
```
auth	[success=2 default=ignore]	pam_fprintd.so max_tries=1 timeout=5 # debug
```

