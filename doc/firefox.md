# Tridactyl for firefox


## Installation
* Download the `.xpi` file from git and install it from `Addon > 'gear menu' > Install from file`
* Then, install natively using `:nativeinstall`, which involve pasting the clipboard into a terminal to install something via curl, and then `:native` in firefox.

## Settings
In `~/.tridactylrc`, add
```
" find
bind ? fillcmdline find -?
bind n findnext 1
bind N findnext -1
bind ,<Space> nohlsearch

" Usual search for firefox
" You lose scroll down using ctrl-f
unbind <Ctrl>f
unbind d

bind qq tabclose

" Apparently slow implementation of smoothscroll by devs
" Does not perform as good as pressing Down or Up botton
"set smoothscroll true
" Smaller stepsize of scrolling, default is 10
bind j scrollline 5
bind k scrollline -5
```

## Reasons I disliked
* Hint mode is ugly (box and color)
* New tab opens the tridactyl help page by default, setting to blank page opens two tabs, weird behavior
* Hint mode on that default page produces hints for nonexistent links, and takes you to `issues` pages on github.
* Default searching keys do not follow vim, redefining search to behave like vim causes to lose incsearch 
* No `ma`, `mb` etc to mark locations in page. `'a` opens some search menu instead of jumping to mark.
* Sourcing `.tridactylrc` does not apply changes, requires restart. Options specified from withing Firefox persists over restarts. Where are those settings stored?
* Could not use vim as default editor sadly
* Smoothscroll is jumpy, and not by default. Holding `j` after turning on smoothscroll makes the scroll look very ugly.
* Unable to remap keys to another keys (e.g. `j` to `Down`)

## Features I enjoyed
* `;k` to kill elements of the page
* `g?` to encrypt page with cypher
* `C-i` to edit in vim directly (although could not make it work with vim+xfce4-term)
* Open or save images from the hint mode
* Bookmark add/delete directly with `A`
* `C-o` and `C-i` to jump to previously scrolled position within a page

# Vimium features

## Settings
In vimium preference, go to `Advanced` and then paste in `Custom key mapping` the following

```
# Insert your preferred key mappings here.
map <c-d> scrollPageDown
map <c-u> scrollPageUp

unmap x
unmap X
unmap u
unmap d

map qq removeTab
map u restoreTab
```

## Copy and google text found within a page
* (optional) Use Find `/` to place the cursor near a desired location
* Go to visual mode with `v`
* Press `c` to enter Caret mode, where the cursor can be moved around to select the starting point of the visual mode
* Press `v` to start selecting
* Press `j/e/w` etc to select region
* Press `p/P` to search the selected string directly, or `y` to yank it.

## Useful keystrokes
* To visit last visited tab:
 Press `Shift-6` or `<Shift-t><Enter>`. For second last tab, `<Shift-t><Tab><Enter>` etc.
* To detach current tab into  a new window: `W`
* Move tab left or right using `<<` or `>>`
* Copy current address using `yy`
* Possibly turn on `Use the link's name and characters for link-hint filtering` so that you can start typing the string of the link right away instead of waiting for the link text to be generated.

# Vimperator matters:
 
 Setting the Ctrl+i editor to vim:
 
 Type:
 
 :set editor='xterm -e vim'
 
 Make the command line bar (status bar) smaller:
 
 :highlight Normal -append font-size: 10pt;
 
 
 Other helps:
 
 Navigation forward/backward: Ctrl+o, Ctrl+i or :ba, :fo, H, L
 Goto the root of the current website: gU (it takes www.site.com/page/page2 to www.site.com)
 Close tab: :q, Save and close tab: ZZ
 
 Tab navigation:
 Change tabs: gt, gT
 Goto the previously selected tab: Ctrl+6
 Goto the tab numbered <n>: g<n>
 When there are too many tabs, pressing b will show all the tabs. Enter the number of the tab and hit Enter to go to it.
 
 
 Set local marks: ma, goto mark a: `\`a`
 
 Open download tab: :downl
 
 Highlight search: :set hsl
 
 Hide scrollbar: :set nosb (To turn back on: :set nosb)
 
 To copy the hinted url to clipboard: (; to enter the) y
 
 Disable vimperator temporarily: Shift-Esc
 
 To hide firefox menubar: :set gui=nomenu
 To access firefox menu:

```
 :emenu [key_word]
 # or
 :em[tab]
```
 
 
 TODOs: 	Choose between address bar and vimperator command line bar because both contain the address, although it's hard to copy-paste from vimperator bar
 	Checked: Remove some more bars to get more space
 	Easy way to look at the title of the page 
 	Autohide statusbar, or transparency
 	Smooth scrolling ( implemented. see .vimperatorrc)
 
 Browsing help
 
 Go back in the current tab: H
 Go forward in current tab: L
 
 reload the .vimperatorrc without restarting firefox
 :source ~/.vimperatorrc
 
 Toggle between page and its source code: gf
 Open the source code in EDITOR: gF
 
 Saving things: Press ; to enter the hint mode, press the right key, then the number.
 s for without prompt, a for with prompt, although both come with prompt initially if "Ask every time" is on.
 
 Saving the destination of a link (Save link as): ;s<link number> or ;a<link number>
 Saving an object (save image as, save the object etc): ;S<link number>, ;A<link number>
 
 Copy link location: ;y (yank, basically, in hint mode)
 Copy link text (that's the best that can be done without a mouse): ;Y
 
 Copy current link to the buffer: y
 Copy highlighted link to the buffer: Y ( Don't know how to highlight in vimperator bar)
 
 Imp: Copy non-link text from the page:
 
 Caret mode (c) gives you a cursor and you can move around with vim keystrokes and select things using visual block(v) and copy text (y). But there is a catch. Caret mode does not land the cursor on the portion of the page that you are viewing. So, it is important to search a string with / and reach the portion of the page where you want the cursor to be, and then press c to enter caret mode.
 
 Opening a link in new window (F) and same window (f) are easy, but modify the link before opining them requires Hint mode (;) and capital letter. For example, ;T or ;W or ;O lets you edit the thing.
 
 Very interesting:
 Follow the link labeled next or > if it exists: `]]`
 Follow the link labeled prev or < if it exists: `[[`
 
 Open right-click menu of a link: ;c
 
 Add the current page to bookmark: a(then Enter)
 Remove the current page from bookmark list: A
 
 Undo closed tabs: u
 Undo last 5 closed tabs: 10u
 
 Toggle between current and the tab opened last: Ctrl-^ (Actually, Ctrl-6)
 Run same command on tabs from 
 
 Stop a loading page: Ctrl-C
 
 Detach a tab from its current window and be on its own: :tabdetach
 Attach a tab to another firefox windos: :tabattach <number>
 
 Show all the navigation history of the current tab: :back <Tab>
 Open the previous tab history link in a new tab: :back <Tab> <home> <delete "back" and type "tab"/"tabopen" etc> <Enter>
 
# [Abandoned: couldn't see any improvement] Speeding up firefox by moving the profile to ram
 https://fixmynix.com/speed-up-firefox-with-ram-cache-and-tmpfs-linux/
 Note: Setting  browser.cache.disk.enable to false and setting browser.cache.memory.enable to true accelerates reloading recently loaded page elements. It comes with the variable browser.cache.memory.capacity which has to be created and specified as well. Eg: 409600. Reference: http://kb.mozillazine.org/Browser.cache.memory.enable
 Note: This specified size is OUTSIDE the profile directory of firefox. The precess so far has not used any ramfs yet.

 N: Didn't follow the first few http, ssl variable modifications. Starts from editing memory_cache variable.
 Main problem: the profile directory gets bigger and bigger and soon the tmpfs is full.
 Q: Can I sync while closing firefox instead of cronjob every 5 mins? Well, to save accidental crash, 5 mins seems better, still.
 Q: How to preserve the installed addons and login to pushbullet?
 Q: Why allocate capacity 2M and create tmpfs for 128mb?
 Q: Moving .vimrc to ram.
 Q: Wat else can I move to ram?


# Firefox font zoom

Go to about:config and set the following value
layout.css.devPixelsPerPx = 1.2 (instead of -1.0)
