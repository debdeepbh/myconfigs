# Mutt with OAUTH2

## Installation

**Caution:** I keep getting errors
```
imap_oauth_refresh_command: unknown variable
smtp_oauth_refresh_command: unknown variable
```
where I run mutt installed via `apt-get install`. Turns out `SASL` was not available in the ubuntu release version. So I had to build from source.

* Build `mutt` from source with `sasl` support
Get the dependencies with
```
sudo apt-get build-dep mutt
```
Get the latest source (check latest version)
```
https://bitbucket.org/mutt/mutt/downloads/mutt-1.14.6.tar.gz
tar -xvf mutt-1.14.6.tar.gz
cd mutt-1.14.6
```
Configure with imap, smtp, sasl etc (run `./configure --help` for more options)
```
make clean
./configure --with-ssl                               \
            --enable-external-dotlock                \
            --enable-pop                             \
            --enable-imap                            \
            --enable-smtp                       \
	    --with-sasl				\
            --enable-hcache                          \
            --enable-sidebar                         &&
make -j4
sudo make install
```

Instead of `make install`, we can issue `sudo checkinstall` to create a `.deb` package that
can be uninstalled with `apt-get remove`.

Make sure the installed version has `sasl` support etc by using
```
mutt -v | grep IMAP
mutt -v | grep SASL
```
etc.

[This](https://gitlab.com/muttmua/mutt/-/issues/179) website tells you to install with following flags
```
./configure \
    --prefix=/usr/local         \
    --with-mailpath=/var/mail   \
    --enable-debug              \
    --enable-hcache             \
    --enable-imap               \
    --enable-smtp               \
    --enable-pop                \
    --enable-sidebar            \
    --enable-compressed           \
    --with-curses               \
    --with-sasl                 \
    --with-gss                  \
    --with-gnutls               \
    --with-idn
```

## OAUTH2 credentials

* Get the refresh token etc using Oath2: 
Download  the [file](https://github.com/google/gmail-oauth2-tools/blob/master/python/oauth2.py) and make it executable using `chmod +x oauth2.py`.
Get `<your_client_id>` and `<your_client_secret>` from [google](https://console.cloud.google.com/apis/credentials)

Run `oath2.py` like this:
```
./oauth2.py --user=<user>@gmail.com \
--client_id=<your_client_id> \
--client_secret=<your_client_secret> --generate_oauth2_token
```
Follow the link, login, and paste back in the script, the script spits out a `refresh code`, save that.

Now, add to `muttrc` (`~/.mutt/muttrc`) the following (later, move them to another file)
```
set imap_user='<username>'
set imap_authenticators='oauthbearer'
set imap_oauth_refresh_command='~/.mutt/oauth2.py --quiet --user=<username> --client_id=<your_client_id> --client_secret=<your_client_secret> --refresh_token=<your_refresh_token>'

set smtp_authenticators="oauthbearer"
set smtp_oauth_refresh_command='~/.mutt/oauth2.py --quiet --user=<username> --client_id=<your_client_id> --client_secret=<your_client_secret> --refresh_token=<your_refresh_token>'
set smtp_url = "smtp://<username>@gmail.com@smtp.gmail.com:587/"

# Remote Gmail folders
set folder = "imaps://imap.gmail.com"
set spoolfile = "+INBOX"
set postponed = "+[Gmail]/Draft"
set record = "+[Gmail]/Sent Mail"
set trash = "+[Gmail]/Trash"
```
where `<user>`, `<your_client_id>`, `<your_client_secret>`, `<your_refresh_token>` are replaced appropriately.


## Modifications

* `mutt` loads _all_ emails on each launch, which is time-consuming and useless. I could not find a way to specify the limit the number of headers that it fetches, but setting the command
```
set header=~/.mutt/cache/headers
```
and creating the directory (`mkdir -p ~/.mutt/cache/headers`), which is very important, the loading time reduces significantly.



## Questions

* Move all the secret credentials to another file, or keep them encrypted
* New unread messages are not highlighted by default
* How to separate spam and promotional ones from important ones?

