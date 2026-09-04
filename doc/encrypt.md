# Password protecting text files in VIM:
 
 To encrypt a file while creating:
 $vim -x filename
 (You will be asked to enter a password twice)
 
 To open the file:
 $vim filename
 (You will be asked to enter the password)
 
 To edit the file and save it with the same password:
 $vim filename
 When finished editing, enter :wq!
 
 To change the password:
 $vim +X filename
 
 Tip: to verify that the file is encrypted, always check by cat filename
 
 
