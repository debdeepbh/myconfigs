# Terminal based:

[source](https://lifehacker.com/5743814/become-a-command-line-ninja-with-these-time-saving-shortcuts)

In terminal `!!` means the last command!!!! And `!$` is the argument of the last command.
For example, if `vim /etc/file` gives you permission error, run `sudo !!` which is essentially `sudo vim /etc/file`.
Also, `vim !$` means `vim /etc/file`.
Useful situation: `mkdir longdirectoryname`. to enter the directory, do `cd !$`.

To search for the last command with `cat` in it from the history, do
`!cat:p`
To run the last command with `cat` in it from the history, do `!cat`
To find commands in the history and run a desired one, do `history | grep cat` and say the command number 455 is the right one that you want to run. Do `!455`.

Array approach for typing less:
instead of `cp /etc/file /etc/file-old`, do `cp /etc/file{,-old}`
or, instead of `mv /etc/file.txt /etc/file.pdf` fo ` mv /etc/file.{txt,pdf}`
So, empty field inside {.,.} means itself.


# Vim 

* `S` (substitute) deletes the current sentence and goes into the edit (compared to DD where the current line vanishes)
* `:set textwidth=69` and `:set colorcolumn=+1` breaks the line after 69 characters. (`linebreak` makes sure that that words do not break in the middle). However, after editing for a while in this mode, lines will have different width. It can be fixed with `gq` command: `gqap` (here, `ap` is `a paragraph`)
* Also, `s` is a better alternative to `r` to edit strings
* W, E, B instead of w,e,b to avoid special characters. So, dW, dE, dB etc
* `Crtrl+E/Y` to  move page without moving the cursor so that I don't have to look at the bottom of the screen all the time; Even better: `zz` adjust the screen  so that the cursor is at the middle of the screen. `zb` and `zt` to place it in the top and bottom.
* `tx` to jump till the next occurrence of character x instead of `fx` which brings the cursor on the character. So, `dtx` instead of `dfx` to delete till the character x, instead of including the character x. Useful for deleting till the next ).
* Once f or F or t or T is pressed followed by a character, pressing `;` and `,` will take the cursor matching the same character further in that direction. Use `#` and `*` for the occurrence of the same word under the cursor.
* `gf` and `gx` to open the file or hyperlink under the cursor. `gf` on a hyperlink will will open the html file for editing.
* `g;` and `g,` to move through the changelist
* `ddp` to switch current line with the next, like `xp`
* `C` or `D` - change or delete the rest of the line
* `U/u` on a visual selection to make all uppercase/loswercase and `~` to flip the case
* `=` to fix indentation of code like this: `==` to fix the correct line, `=5j` to fix the next 5 lines, place cursor on an opening brace `{` and press `=%` to fix until the matching closing brace i.e. the whole block. Finally, if the cursor is inside a code block  of `{.}`, pressing `=a{` will fix the indentation of the whole block
* `Ctrl+w` to delete word back in insert mode
* `Ctrl+a` to insert string inserted in last edit mode, while being inside the insert mode. Pressing . does the same in edit mode.
* `:set ic` to set ignorecase and `:set noic` to bring back case while searching
* `\`"` to jump to the place last exited buffer, `\`\`` to jump back to where you jumped from, `\`[` or `\`]` to the start or end of last yanked or changed buffer, `\`<` or `\`>` to the start or end of the last visual selection.
* `:reg` to see all the registers, `:reg p` `q` or `r` to see only those registers, registers 0-9 fills up with deleted lines.
* `"rY` yank current line to the buffer `"r`, use `"rp` to paste the content of buffer `"r`. In insert mode type `Ctrl+r` then s to paste the content of buffer s.
* `"=` can do integer calculations of evaluate commands like `system('ls')` and can be used via `Ctrl+r=` or `"=p`
* `"%` is the current filename and `":` is the most recently executed vim command
* First type up a macro then execute it as a string: yank the macros string to a buffer (say m) then type @m to execute it. In fact, when you record a macro (with q), it gets copied to the buffer of the same name.
* `:ab <abbreviation> <full\ name>` will expand abbreviation while typing, use `:una <abbreviation>` to remove the rule.
* `Ctrl+A`, `Ctrl+X`	Increment, or decrement the first number found after the cursor
* `g Ctrl+g` to get work/line/char count and just `ctrl+g` to show the file info (also `:%`) and number of lines etc. 
* `g-` or `:earlier` to return the buffer to the earlier state, like undo u but does not erase the other undo branch. Similarly `g+` and `:later`. Finally `:earlier` 1m or 1h or 5f (`f` for number of save times ago)
* matching or unmathed braces: `[[` to jump to the previous opening brace. Similarly `]]`. Also, `[{` `[(` will take you to the previous unmatched opening brace and parenthesis. `Similarly` for `[}` and `[)`.

## Using vim-surround:
 
* `cs({` : Change the surrounding () to {} 
* `ds{}` : Delete surrounding {} 
* `ys` : Add surrounding things. For example, `ysiw{}` will add `{}` to current word (`iw`). For example, `0ys$)` will enclose the current sentence with `()`. Or, `yst})` to enclose from current position till the next `}` with `()`
* To add to a visual selection, use `S` to add enclosures. For example, do `S'` to enclose a visual selection with `''`.
* While adding or changing, use `}` instead of `{` to add spaces 
* specific use: type anything other than `{}()[]'"` and it will be considered as a html tag `<tag> </tag>`


## Using vim-easymotion:

Following the keybinding of my `.vimrc`, here are the most useful motions.

* `\w` or `\b` to jump forward and backward to words. Also, `\W`, `\B`, `\E`, `\ge`, `\gE`
* s or t to search for two-character search string to jump to (remaped less used s, remapping t does not cause any conflict so far)
* `/` with searching will now show links to jump to. Without hitting Enter after entering the search string will give you and opportunity to press Tab to scroll forward and backward (with Shift+Tab) to look for other matching strings
* `L` will show links to line numbers
* Probably the most useful option is the use of these motions with v (and V and Ctrl+v) and d. After entering the visual mode, use `\w`, `\b`, `\s`, `L`, `\B`, `\W` etc to quickly make selections. This was one of the cases where keyboard-only paradigm was painful. But not anymore.


## Questions:
- Create a new line at the cursor point without going into insert mode: mapped oo and OO for that reason, but this also makes o and O very slow
- Delete backward when the cursor is on the last letter of the word (dB does not work): done with dge and dgE
- Copy-pasting with firefox and terminal: done with `clipboard=unnamedplus`
- Navigating a multi-line sentence
* `:tag` and how to use them: need to use ctags to create a tag file with limited scope.
- `:earlier` `:later`
- undo branching

# Awesomewm related shortcuts:

- modkey + j/k/h/l = browse by direction
- altkey + j/k = browse by order
- modkey + d = dmenu
- modkey + s = show help (not so helpful)

Layout manipulation:

- modkey + shift + j/k = swap with the next client by index
- modkey + F2 = rename current tag

- modkey + shift + h/l = increase/decrease number of master clients
- modkey + ctrl  + h/l = increase/decrease number of columns
- modkey + shift + enter = move to master

The slight issue is: when you do modkey + ctrl + enter to set a client as master, it replaces the first client already set as master. So, if you want to add some client as master, first, move the topmost master client down using modkey + shift + j and then navigate to the client you intend to make master and then hit modkey + ctrl + enter. Downside is: the second master client is not master anymore :( Not sure if there is any shortcut for this.
Alternatively, move the slave client up until it is the first slave client. Then use Modkey + shift + h to increase the number of master client and automatically the fist slave client will be move to be the last master client.

- modkey + u = jump to the urgent client (what is urgent client?)

These two are new and should be used:
- modkey + tab = jump back to the previous client
- modkey + Esc = jump back to the previous taglist

- altkey + shift + l/h = increase/decrease master width

- modkey + ctrl + space = toggle floating
- modkey + t = keep on top

- modkey + shift + number = move the focused client to taglist number
- modkey + ctrl + shift + number = copy focussed client to taglist number, toggle

Added myself: 
- modkey + shift + n = create a new tag
- modkey + shift + d = delete a tag
- modkey + F2 = rename a tag


## TODO:
Find out how to restart xinput without restarting, possibly via modprobe.
