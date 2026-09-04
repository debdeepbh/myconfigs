# Calibre setup with Kobo glo
 
 Install Calibre and the package udisks
 
 pacman -S udisks calibre
 
 Then connect the device, after some time it eill be detected.
 
 For Bookshelf management, follow this link:
 http://www.teleread.com/ebooks/using-calibre-for-e-book-management-chapter-6-managing-kobo-bookshelves/
 (The plugin they mention here is KoboTouch Extended)
 
 Basically,
 1. Preferences > Create your Own column > Add > Enter "Book Shelf", "bookshelf" (without quotes) > Apply
 2. Install KoboTouch Extended plugin
 3. Preferences > Addon > Select KoboTouch plugin > Customize> Scroll down to where they talk about Book Shelf > Enter "#bookshelf" (without quote) > Apply > Restart.
 
# Rules to ensure that files stay in certain directory with the same Book Shelf name:
 
 While importing, Calibre creates a directory with the same name as the Author and keeps the file inside. And while copying the files to the device, it keeps the same directory structure. 
 
 1. So, in order to keep several files in a directory, after importing the files to calibre, you must bulk edit their metadata and change the Author's name to the desired one. Note: In this process, the actual Author's name will be changed, which is the price we are paying.
 
 Second, creating Bookshelfs in calibre to avoid frantic tapping on the device, which is very frustrating given the speed of the device.
 
 Here is what we want:
 1. We wish to keep all the books in either of the book shelves
 2. For a file, it's book shelf name should be the same as the directory which it belongs to. 
 3. No intersecting book shelves
 
 In order to do that, after importing the books and changing the author's name, we need to do the following:
 2. Select files, bulk edit metadata, goto custom tags/metadata and enter the same name as the directory name/author's name.
 
 So, in brief, after importing the files from a place, immediately bulk edit the metadata, change the author name, custom tag to the directory name, then send to the device.
 
 
