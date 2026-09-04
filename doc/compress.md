# Compress and uncompress (zip/unzip) files using aunpack
 To extract all files from archive `foobar.tar.gz` to  a  subdirectory  (or the current directory if it only contains one file):
  aunpack foobar.tar.gz
 
 To create a zip archive of two files `foo' and `bar':
  apack myarchive.zip foo bar
 To compress the content of current directory into a zip file called comp.zip
  apack comp.zip *
 
 To list contents of the rar archive `stuff.rar`:
  als stuff.rar

