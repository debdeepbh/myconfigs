# Installing xournal from source and adding useful patches:

So, apt-get install doesn't give you the latest version (e.g. now it is the 2.8.2016 version) or the patches the community developed.

To install the development dependencies, do
sudo apt-get build-dep xournal

Download the latest tar, extract it with
tar -xf xournal.**.tar.gz
cd xournal.**

Details of patching can be found here: https://sourceforge.net/p/xournal/discussion/554377/thread/5d03da22/
Here is the summary:
Patch the source code with the download patch file
```
patch -p1 < patchfile.patch
```

Note: if the patchfile is a tar file, extract and then -p1 should be change to -p2 or the required number of depth  of path.

Compile and install this modified source file, follow http://xournal.sourceforge.net/manual.html#installation

Summmary: 

To install in the user directory (~/bin/), do:
```
./autogen.sh; ./configure --prefix=$HOME; make; make install; make home-desktop-install
```
The last step is to set mime-type etc.

To install it in the system, do with sudo:
./autogen.sh
make
(as root) make install
(as root) make desktop-install

So, far used the following patches: various improvements, linewidth-patch, vi-style scrolling

Caution: If you use the linewidth-patch, older versions of xournal will not be able to open the files saved by the patched version. Chances are, this patch will not end up in the official version in future, making all the files created with the patched version useless.

### Xournal patches
Install xournal from the patched version from xournal-patches by following the INSTALL file from the source code, satisfying the dependencies (see lin/TODO new installation), make and sudo make install

Open "Software & Update" app and check the "source codes" box, password and reload
Install build-dependencies for xournal using: `sudo apt-get build-dep xournal`
In the patched source code directory,  (archyhome/xournal-patches/xournal-0.4.8.2016)
```
./autogen.sh
make
sudo make install
sudo make desktop-install
```


# Drawing with touchscreen in xournal
 1. Select 'Designate as touch screen' and select the touch screen
 2. Turn OFF 'Pen disables touch'. Then draw.

To log the input events, add the following line at the top of the file src/xo-callbacks.c:
#define INPUT_DEBUG 1
Then, compile and run from terminal to see all the input events popping up at the terminal.


