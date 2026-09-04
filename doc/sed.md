# Replacing entries in file with another one
 
 # sed -i 's/\/sbin\/resolvconf/\/usr\/bin\/resolvconf/g' vpnc-script
 
 Note: Can be used for config files containing Solarized color palette.
 

36. Using awk to reformat the output:
``
 stdbuf -o0 xinput test 12 | awk -F' ' '{printf $3}'
``

This means, consider the lines of the output as a sequence divided by the character ' '. Then print the 3rd element of that sequence.
