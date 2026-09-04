# Sharing keyboard and mouse between multiple computers:
 
 We have two computers called archy and pratima-3z. we want to use archy's inputs in pratima-3z. Install package called synergy. Archy has the following configuration file:
 
 section: screens
 archy:
 pratima-3z:
 end
 
 section: aliases
 pratima-3z:
 10.10.101.124
 end
 
 section: links
 archy:
 right = pratima-3z
 pratima-3z:
 left = archy
 end
 
 section: options
 screenSaverSync = false
	    vector<double> C_lrtb = get_lrtb(PArr[i].CurrPos);
 # My KVM uses Scroll Lock to switch screens, so set the

 # hotkey to lock the cursor to the screen to something else
 keystroke(f12) = lockCursorToScreen(toggle)
 end
 
 To run the server: synergs -f --config ~/.synergy.conf
 -f is for foreground.
 
 In the client, run synergyc -f ipaddress
 
 Note: Keyboard can be used only when the mouse is in the corresponding screen.
 
 
