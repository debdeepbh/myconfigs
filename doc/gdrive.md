# Google drive client for linux:
 A git-like command line tool called drive (https://github.com/odeke-em/drive) has implemented all the features though auth2 secret key.
 Follow the instructions in its readme file, run
 	drive init ~/gdrive
 to start the service. In the command line, it will give you alink to vist to get a secret_key which you enter in the command line.
 After that pull, push etc covers everything, Look at the Readme in the github for all information.

 After drive init, go to the directory you initiated drive and then
 	drive pull 'directory name'
 pulls all the files, directories etc of 'directory' name.

 Similar to git, to push files to drive, you can create subdirectory inside the local gdrive structure. For example,
 	cd ~/grive
	mkdir new-folder
	cd new-folder
	cp ~/newfile ./
	drive push
 Be aware, if you do not have a copy of the remote files in the local location, drive push will delete the ones that are not present in the local path or in its children.
 
 Issue: the authentication token expires occasionally, forcing you to follow some link, clicking on "Accept" and generate token, copy-paste it to the terminal window.
 
 Deleting files from drive:
 
 Either 
 	drive trash 'file to be trashed'
 
 Or, remember the name (with path) of the directory you want to delete. rm -r in local path. Then
  drive push 'path to the deleted file'
 to delete it remotely.
 
 To empty trash 
 	drive emptytrash
 
 To permanently delete files without trashing it first (no need because I have infinite space in my institution-given drive) use
 	drive delete 'file to be deleted forever'
 
 To list files upto 1 depth inside some directory
 	drive list
 
 To list files upto 3 directory depth
 	drive list -depth 3
 
 You can use strings to look for while listing
 	drive list --matches mp4 pdf mp3
 
 To first sort by modTime, then largest-to-smallest and finally most number of saves inside the directory Photos
 	 drive list --sort modtime,size_r,version_r Photos
 
 To see stats of a directory recursively
 	drive stat -r 'directory name'
    or until depth 3
    	drive stat -depth 3 'directory'
 
 drive allows you to create an empty file or folder remotely Sample usage:
 
 $ drive new --folder flux
 $ drive new --mime-key doc bofx
 $ drive new --mime-key folder content
 $ drive new --mime-key presentation ProjectsPresentation
 $ drive new --mime-key sheet Hours2015Sept
 $ drive new --mime-key form taxForm2016 taxFormCounty
 $ drive new flux.txt oxen.pdf # Allow auto type resolution from the extension
 
 Show all information about your drive account
 	drive quota
  in more detail
 	drive about
 
 drive allows you to copy content remotely without having to explicitly download and then reupload.
 
 $ drive copy -r blobStore.py mnt flagging
 
 $ drive copy blobStore.py blobStoreDuplicated.py
 
 To perform a rename:
 
 $ drive rename url_test url_test_results
 $ drive rename openSrc/2015 2015-Contributions
 
 drive allows you to move content remotely between folders. To do so:
 
 $ drive move photos/2015 angles library archives/storage
 
 Command Aliases
 
 drive supports a few aliases to make usage familiar to the utilities in your shell e.g:
 
     cp : copy
     ls : list
     mv : move
     rm : delete
 
 The url command prints out the url of a file. It allows you to specify multiple paths relative to root or even by id
 
 $ drive url Photos/2015/07/Releases intros/flux

### Fixing clashes
* List the clashes with
```
drive clashes list <path>
```
* Resolve the clashes with
```
drive clashes -fix <path>
```
 
 101. OpenFOAM
 
 http://openfoam.com/download/install-binary.php
 
 Follow this tutorial and after running openMesh, you get an error. 'pwd' to see you path, 'cd cavity' and run again to resolve.
 
  While running, systemctl start docker in the beginning and do everything else.

