# Setting up vim and other goodies in a local environment

## vim
- compile vim 8 from source with python3 support
- add path (~/.local/bin/vim) to local vim *before* the system vim path

## nvim
- download the executable binary
- copy the content (`bin`, `lib`, `share`) of the extracted tar to `~/.local` so that it can be launched
- [see before] create `.config/nvim/init.vim` according to instructions and populate with appropriate lines
- run `nvim` and issue `:checkhealth` to see what does not work

### fixing ultisnip python3 path
- find python3 path with `which python3`
- insert in `.vimrc` for `nvim` to specify the path of python3
```
let g:python3_host_prog = <full path from `which python3` output>
```
- install `pynvim` using
```
pip3 install pynvim
```
- run `:checkhealth` to see if there is still an issue

### nodejs

- Download nodejs binary from [website](https://nodejs.org/en/download/)
```
wget -c https://nodejs.org/dist/v16.13.0/node-v16.13.0-linux-x64.tar.xz
```
- extract and add the path of extracted location to `$PATH` in `~/.bashrc` and source
- check `node` command runs
- [unnecessary] install npm package `neovim` using ` npm install -g neovim `

### coc.nvim
- with `:PlugInstall` command you will get the error that the `Release` branch could not be found
- go to the downloaded repository and (build and) install it with npm using
```
cd $HOME/.vim/plugged/coc.nvim
npm install
```
- open `nvim` and check that coc is not showing any error
- Install language servers using `:CocInstall coc-pyright`

## ranger
```
pip3 install ranger-fm
```

## Issues
- [ ] `nvim` takes a while to load
- [ ] the first insert mode in `nvim`  is very slow, after that it works well
- [ ] ranger takes a while to start



# Interactive terminal command from vim

```vim
function! <SID>InteractiveFZFCommand(...)
    let tempfile = tempname()
    if a:0
	" if an argument is supplied
	let dirname = a:1
    else
	" if no argument is supplied
	let dirname = ""
    endif

    let command = "!$HOME/.myscr/copyfilelocally " . dirname . ' >' . shellescape(tempfile)
    execute command
    try 
        silent execute 'read' tempfile
    finally
        call delete(tempfile)
    endtry
endfunction

" ? means 0 or 1 arguments
command! -nargs=? GetFile call <SID>InteractiveFZFCommand(<f-args>)
```

# Changing caps lock to escape

```
setxkbmap -option caps:escape
```

# Dual filetype

While working on a pandoc (markdown) file which contains some latex code, one needs to use the plugin features targeted toward each of the filetypes.

```
:set ft=pandoc.tex
```

This will likely have collisions between various snippets and keymaps, but seems to work for now.

Alternatively, you can temporarily change the filetype to tex using

```
:set ft=tex
```

do your tex editing, and come back to pandoc using

```
:set ft=pandoc
```

# Vim helps:

## Newer vim moves

* Navigation: along with Ctrl-U/D/Y/E, use H/M/L to jump to top, middle, and bottom part of the screen. Then, use zb/zt to adjust the screen. Scroll by the first character of the line using `-` and `+`.
* While searching, press Ctrl-G/T to jump between partial search highlights
* Ctrl-X Ctrl-K to get correct spelling from the dictionary while typing a word
* Hop indents in insert mode with Ctrl-D/T. Jump to default indent with `S` (substitute line) in normal mode, deleting the current line. 
* `:browse oldfiles` or `:bro ol` opens a list of last opened files. Useful after closing a file and navigating away.
* Delete or change up to a mark with "d`a" or "c`a". Also delete till the occurrence of search string using `d/string`, or maybe, `d/str<C-G><C-T><C-T>ing<CR>`

* `"0p` to paste last copied segment even after using `d` or `c` in the meantime.
* `:/` to search for the last searched string
* Use buffer instead of tabs for the same project

## vim window splitting
- Make window sizes equal after resizing with `<C-W>=`. Resize further using `<C-W>>/<`
- Split current window with the last buffer horizontally using `:sb#`
- Split current window with the last buffer vertically using `:vert sb#`
- Similarly, split with `N`-th buffer (from `:b`) using `:sb N` and `:vert sb N`
* Move current split to (horizontally) left or right using `<C-W><S-H/L>` and (vertically) to top or bottom using  `<C-W><S-J/K>`


## vim Ex commands

We can apply a command on a range of lines using ex commands.

* Ex commands start with `:`, followed by a line range to produce a set of line numbers, and a command to apply to those lines. The line range and the command can take additional arguments.

* Line range is separated using a comma (or semicolon for absolute reference) e.g.:
`:5,10` means the lines from 5 to 10
`:.,10` means the from current line to line 10
`:.,+10` means the from current line to the next 10 lines
`:1,$` (alternatively, `:%`) means from line 1 to the last line
`:'t,\string` means from the line containing mark `t` to the line where the string `string` appears next after the cursor (Note: to get the next occurrence of `string` after the mark `t` (instead of the occurrence of `string` after the current cursor position), using the separator `;` instead of a comma)

* A line range can be further filtered using a regular expression `re` by appending a `g/re/`. To negate the regular expression `re` we can append `v/re/` instead. 
e.g.
`:% g/string/` means all lines in the file where `string` appears
`:/this,+10 g/sring/` means all lines between the appearance of `this` after the current line and 10 lines after that appearance such that the string `sring` appears in it
`:'t,$ v/string/` means all lines between the tag `t` and the end of the file such that the string `string` does *not* appear

* A command goes after the (filtered) line range. It applies like a for loop to each line in the range.

`j` to join the line to the next
`d` to delete the line
`m` to move line, followed by a destination (e.g. `m$` to move to the end of the file)
`co` to copy line, followed by a destination (e.g. `:1,10 co +10` copies to 10 lines below)
`p` to print line (to a temporary window, which can be saved or further edited)
`s` to substitute, followed by search sting and replacement string and whether on each line or not (possibly with confirmation) (e.g. `s/foo/bar/gc`)
`!` to call an external command, followed by the external command (e.g. `:5,10 !sort` that sorts the lines 5 through 10)
`norm` to run a command (e.g. `:.,+10norm @a` to run the macro `@a` on the next 10 lines)
`w` to write to disk (e.g. `:% g/hello/w test.txt` to save all lines with `hello` to a file)
`r` read (e.g. `:$r !date` to read the date into the last line)

Acting on a line range (i.e. *not* to each line in the range but as a whole)
`c` to change the line range, followed by text 
`a` to append the line range, followed by text 
`i` to insert before the line range, followed by text 
(e.g. `:.,+10 c<CR>` followed by `hello<CR>.<CR>` to change (delete and then add) the next 10 lines by the test `hello`. Note that `.<CR>` is to indicate end of input.)

* A command can take a prefix to modify the line number it is acting on
e.g.
`:5,10 g/hello/-1j` joins each line that has the string `hello` to its *previous* line (as opposed to the next line) via `-1` modifier on the line number obtained by the range `5,10 g/hello/`.
	

## Basic vim
 
 Type vimtutor to go through a short interactive tutorial.
 For slightly advanced and very useful tutorial: http://linuxgazette.net/152/srinivasan.html
 Navigation: The most popular way to scroll will be Ctrl-Y/E, Ctrl-D/U. W/w, E/e, B/b to move left-right via words, `5b`, `5e` to hop 5 word backward and forward, `}`,`{` to move to prev/next blank lines. And most importantly, `)`,`(` to hop sentences i.e. hop the fullstops.

 Mainly use w,e,b to go left-right, ),( and },{ to hop fullstops and paragraphs, j,k to up down. Ctrl-U/D to move the screen by half page up/down.
 
 Operators: Start selecting text using `v`, move cursor to select strings, then: copy- y, change - c, delete- d, yank- y, paste- p.
 Handy commands:
```
 	de - delete upto the end of the current word
 	db - delete upto the beginning of the current word
 	d) - delete upto the beginning of the current sentence
 	d) - delete upto the end of the current sentence
 	diw, ciw - cut, change words inside which the cursor is.
 	yaw - copy a word (the current word)
 	ci(, ci" - change inside () or " ". Can be replaced by di,ca,da
 	gf - to quickly go to the filename on which the cursor is
 	yy/Y - copy whole line
 	dd - cut whole line
 	D - delete till the end of the line
 	das, dis - delete the current sentence (i.e. enclosed by dots or some vague identifiers(very shady))
 	5Y, 5dd - copy/cut 5 lines
 	`` (two back-ticks, not apostrophe) - jump to the previous cursor position 
 	dtx - change till the next occurrence of character x
 	ctx - delete till the next occurrence of character x
 	jtx - jump till the next occurrence of character x
 	ktx - jump till the previous occurrence of character x
 	fx, Fx - jump left, right to the next occurrence of the character x
 		(for example, dt. deletes the text till the next dot from the current position)
 	xp  - to swap two consecutive letters like "taht" to "that"
 	ddp - switch the current line and the next
 	A;  - append a semicolon to the end of the line.
 	>>  - increase indent of current line.
 	<<  - decrease indent of current line.
``` 
 
 ##############################################################################
 A list of tricks found in the [page](http://stackoverflow.com/questions/726894/what-are-the-dark-corners-of-vim-your-mom-never-told-you-about?rq=1)
 
 Moving around in vim: All the long moving around can be done by bB,eE,)(,}{, and the special f/F{char}, t/T{char}. Once f or F  is pressed followed by a character, pressing ; and , will take the cursor matching the same character further in that direction. t or T takes one character before the target character.
 
 Tip: To open a hyperlink in your browser, bring the cursor inside the link text and type `gx`.
 
 Redo in VIM: press Ctrl+R, and not a capital U.
 
 Duyuuuelete everything till the end of the word by pressing . at your heart's desire.
 
 ci(xyz[Esc] -- This is a weird one. Here, the 'i' does not mean insert mode. Instead it means inside the parenthesis. So this sequence cuts the text inside parenthesis you're standing in and replaces it with "xyz". It also works inside square and figure brackets -- just do `ci[` or `ci{` correspondingly. Naturally, you can do di (if you just want to delete all text without typing anything. You can also do a instead of i if you want to delete the parentheses as well and not just text inside them.
 
 ci" - cuts the text in current quotes
 
 ciw - cuts the current word. This works just like the previous one except that ( is replaced with w.
 
 C - cut the rest of the line and switch to insert mode.
 
 ZZ -- save and close current file (WAY faster than Ctrl-F4 to close the current tab!)
 
 ddp - move current line one row down
 
 xp -- move current character one position to the right
 
 U - uppercase, so viwU upercases the word
 
 ~ - switches case, so viw~ will reverse casing of entire word
 
 Ctrl+u / Ctrl+d scroll the page half-a-screen up or down. This seems to be more useful than the usual full-screen paging as it makes it easier to see how the two screens relate. For those who still want to scroll entire screen at a time there's Ctrl+f for Forward and Ctrl+b for Backward. Ctrl+Y and Ctrl+E scroll down or up one line at a time.
 
 Crazy but very useful command is zz -- it scrolls the screen to make this line appear in the middle. This is excellent for putting the piece of code you're working on in the center of your attention. Sibling commands -- zt and zb -- make this line the top or the bottom one on the sreen which is not quite as useful.
 
 % finds and jumps to the matching parenthesis.
 
 de -- delete from cursor to the end of the word (you can also do dE to delete until the next space)
 
 bde -- delete the current word, from left to right delimiter
 
 df[space] -- delete up until and including the next space
 
 dt. -- delete until next dot
 
 dd -- delete this entire line
 
 ye (or yE) -- yanks text from here to the end of the word
 
 ce - cuts through the end of the word
 
 bye (yiw) -- copies current word (makes me wonder what "hi" does!)
 
 yy -- copies the current line
 
 cc -- cuts the current line, you can also do S instead. There's also lower cap s which cuts current character and switches to insert mode.
 
 viwy or viwc. Yank or change current word. Hit w multiple times to keep selecting each subsequent word, use b to move backwards
 
 vi{ - select all text in figure brackets. va{ - select all text including {}s
 
 vi(p - highlight everything inside the ()s and replace with the pasted text
 
 b and e move the cursor word-by-word, similarly to how Ctrl+Arrows normally do. The definition of word is a little different though, as several consecutive delmiters are treated as one word. If you start at the middle of a word, pressing b will always get you to the beginning of the current word, and each consecutive b will jump to the beginning of the next word. Similarly, and easy to remember, e gets the cursor to the end of the current, and each subsequent, word.
 
 similar to b/e, capital B and E move the cursor word-by-word using only whitespaces as delimiters.
 
 capital D (take a deep breath) Deletes the rest of the line to the right of the cursor, same as Shift+End/Del in normal editors (notice 2 keypresses -- Shift+D -- instead of 3)
 ############################################################################
 Others shared:
 
 One that I rarely find in most Vim tutorials, but it's INCREDIBLY useful (at least to me), is the
 
 g; and g,
 
 to move (forward, backward) through the changelist.
 
  vity and vitc can be shortened to yit and cit respectively. –  Nathan Fellman Sep 7 '09 at 8:27 
 
 
 
 Not sure if this counts as dark-corner-ish at all, but I've only just learnt it...
 
 :g/rgba/y A
 
 will yank all lines containing "rgba" into the a buffer. I used it a lot recently when making Internet Explorer stylesheets.
 
 
 Jumping the marks: To create a mark, press m and then any letter, say a. So, `ma` creates a mark named `a`. Now you can move around here and there. To come back to mark `a`, press a backtick and the markname i.e `\`a`. If you want to hop marks created in a different file which is not even open in vim right now, you have to create the marks with capital letters. For example, if you create a mark named `F` by `mF` in file called file1 and exit it and open another file called file2and you want to jump to the mark F in file1, all you need to do is press `mF`.
 
 One very important mark is `.`, the mark at which the file was last edited. So, after opening a file, pressing `tick` followed by dot will take you to the place where the file was last edited. You can go back further into the last edited place list by pressing `g;` and forward by `g,`.
 
Other useful special marks are "`[" and "`]" which take you to the beginning and the ending of the last yanked location. On the other hand, "`<" and "`>" for the last section.
 
 
 Typing `==` will correct the indentation of the current line based on the line above.
 
Actually, you can do one `=` sign followed by any movement command. e.g. `=ap` or `=G` or `=a{`
 
For example, you can use the % movement which moves between matching braces. Position the cursor on the { in the following code:

``` 
 if (thisA == that) {
 //not indented
 if (some == other) {
 x = y;
 }
 }
```

``` 
 And press =% to instantly get this:
 
 if (thisA == that) {
     //not indented
     if (some == other) {
         x = y;
     }
 }
```
Alternately, you could do `=a{` within the code block, rather than positioning yourself right on the { character.
 
 `gg=G` corrects indentation for entire file. 
 
 ##############################################################################
 
 
 Creating visual blocks: Ctrl + v
 Select the previously selected visual block: gv
 
 Insert a string str in front of every line in a visual block:
 1. Select the visual block
 2. Press I. It will take you to the beginning of the first string of the first line of the visual block.
 3. Enter the string str.
 4. Press Esc
 
 Similarly, making any change in every line of a visual block involves similar steps.
 
 Insert Mode (i) commands: 
 Ctrl-w delete upto the word before the cursor
 Ctrl/Shift-Left/Right to move left/right by one word as usual
 Ctrl-Y, Ctrl-E mimics (copy-pastes) the characters above and below the cursor.
 
 Ctrl-@ to insert the strings entered in the previous insert mode session and stop insert mode
 Ctrl-A to insert the strings entered in the previous insert mode session 
 
 
 Word Completion: Press Ctrl-P, Ctrl-N to complete the current half-typed word by the matching word found just before/after the current position. If you don't want the matching word occurring immediately before/after the current position, i.e. if you want options, then press "Ctrl-X Ctrl-P" or "Ctrl-X Ctrl-N" for a drop down list of matching word occurring before/after the current position. To complete the word using words from dictionary, press "Ctrl-X Ctrl-K" to get a list. This is useful when you don't know the spelling of some word and you need help on the way typing the word. You can type a couple of letters and type Ctrl-X Ctrl-K then keep typing until you can narrow down the dictionary list and select one. Also, to auto-complete filenames or path, press"Ctrl-X Ctrl-F".
 
 
 When autoindent is on (:set autoindent or :set ai), and a new line starts after some whitespaces respecting the indentation, you might want to press backspace to go to the previous indentation mark. But in this case, backspaces only deletes one whitespace at a time. To delete indents one by by one, press Ctrl-D, and insert indents, Ctrl-T.
 Note: A more powerful indenting option is "smartindent" which brings back your cursor by one tab when you type the ending bracket } to {.
 
 Note: After using smartindent, the autoindent options seems useless. It is faaar better and fun to use. Never use autoindent again. Spread the word.
 
 Searching a string: `/string` will highlight all the matches. This is case sensitive. `:set ignorecase` or equivalently `:set ic`will get rid of that limitation. Pressing n and N will take you back and forth among the search results. `:set noic` will turn of the ignorecase option. Also, * and # will search the previous and next occurrence of the current word on which the cursor lies. Again, case sensitive if `:set ic` is not set. 
 
Replace: Replacing is done by the command :substitute or :s. These are some examples with explain the basics:
 
```
 :%s/foo/bar/g
 Replaces foo by bar everywhere in the file.
 
 :%s/foo/bar/gc
 Replaces foo by bar everywhere in the file with confirmation.
 
 :s/foo/bar/g
 Replaces foo by bar everywhere in the current line.
 
 :s/\<foo\>/bar/gc
 Replaces foo by bar with confirmation everywhere in the file only when foo is found as a whole word i.e. enclosed by spaces.
```
 
 Once again, `:set ic` and `:set noic` will play a role.
 
 Spell Check: To turn on spell check, type :set spell and hit enter. (Optionally, :set spell spelllang=en_us for language selection). Press `]s` and `[s` to hop the misspelled words and type z= to get a dropdown list of possible correct spellings. Note that `[[` and `]]` takes you to the beginning and ending of the file, similar to GG and gg. To turn off spelling mode, type, :set nospell. You can always all include "set spell" in .vimrc to enable default spell check in the default language en_us. While in insert mode (i), typing "Ctrl-X s" will give you a drop-down list of correct spelling of the last misspelled word.
 
 Edit .vimrc to set necessary options. If it doesn't exist, copy it from etc. 
 Here are some necessary augmentations to make life simpler:
 
 syntax on
 (for highlighting the keywords in different colors based on the extension)
 
 set clipboard=unnamedplus
 (to copy yanked texts to X-system buffer instead of vim buffer, which is useful for yanking from vim and pasting in another program, say firefox. But this gives a little problem regarding pasting, which is arbitrary. Need to fix this.)
 
 set spell spelllang=en_us
 (to enable spell check in en_us. spelllang=all will allow all languages)
 
 set linebreak
 (to display long lines after breaking them at spaces i.e. after a word is finished instead of breaking it in the middle of a word)
 
 set visualbell
 (the screen flashes if you hit Esc more than once to help you control your OCD)
 
 imap <c-l> <c-g>u<Esc>[s1z=`]a<c-g>u
 (This option accelerates the process of auto correct like crazy. While in insert mode, if you have made a spelling mistake, you can press Ctrl-L to quickly accept the first spelling suggestion of the last misspelled word, create a undo node, come back to your original position and enter insert mode. If you don't like the auto correct, you can press u to undo or Ctrl-R to redo. Here is how it works:
 	<c-g>u 	inserts an undo-break	
 	[s 	moves to the last spelling mistake
 	1z= 	chooses the first suggestion
 	`] 	move to the last insert point
 	a 	append text
 )
 
 set wildmenu
 (for option list the :option by pressing tab. For example, :color <Tab>)
 
 Smooth Scrolling: The following code to be added to .vimrc in order to smoothen the scrolling in vim. This affects only affects Ctrl-D, Ctrl-U.
 Important note: Remember that the ^ character indicates a control character; copy-paste will produce invalid results and these must be entered manually (with CTRL-V)!
 To enter ^Y in the file, type Ctrl-V,  Ctrl-Y. And similarly for ^E.
 
 function SmoothScroll(up)
     if a:up
         let scrollaction="^Y"
     else
         let scrollaction="^E"
     endif
     exec "normal " . scrollaction
     redraw
     let counter=1
     while counter<&scroll
         let counter+=1
         sleep 10m
         redraw
         exec "normal " . scrollaction
     endwhile
 endfunction
 nnoremap <C-U> :call SmoothScroll(1)<Enter>
 nnoremap <C-D> :call SmoothScroll(0)<Enter>
 inoremap <C-U> <Esc>:call SmoothScroll(1)<Enter>i
 inoremap <C-D> <Esc>:call SmoothScroll(0)<Enter>i
 
 
 Make vim open new buffer in new tabs: (useful while pressing gf on a filename/path, :o :e etc)
 
 " Experimental. Remove if buggy.
 " This is incredibly good. I like it.
 " set hidden actually lets you open another buffer by :o, :e etc even when the
 " current file has unmodified changes. Fun!
 set hidden
 :au BufAdd,BufNewFile * nested tab sball
 
 Help for tabs:
 gt, gT to navigate through tabs
 :qa to quit all, :wqa to save and quit all, :qa! to quit all without saving 
 Most important of all:
 Press :tabo to close all other tabs except the current one. There is a catch though, it does not care if there is any modified buffer in the other tabs. It ignores them, i.e. the changes in all the other buffers are gone.
 
 Find out more for tab navigation
 
 Syntax folding in VIM:
 
 zi 	switch folding on or off
 za 	toggle current fold open/closed
 zc 	close current fold
 zR 	open all folds
 zM 	close all folds
 zv 	expand folds to reveal cursor
 
 
 Open recently opened files in vim:
 
 :bro ol
  
 This is short for :browse oldfiles. It will show a list of 100 recently opened file. You can navigate through the list to get the number corresponding to your desired file (sorry, no / to search). Press q to quit the navigation mode  and get the prompt and enter the number. The code in the previous subsection will ensure that the new buffer is opened in a new tab.

 Selecting, changing and editing tags (such as <a> text </a>):
 You can jump between tags using visual operators, in example:

      Place the cursor on the tag.
          Enter visual mode by pressing v.
 	     Select the outer tag block by pressing a+t or i+t for inner tag block.
 
 	     Your cursor should jump forward to the matching closing html/xml tag. To jump backwards from closing tag, press o or O to jump to opposite tag.
 
 	     Now you can either exit visual by pressing Esc, change it by c or copy by y.
  
#5. Setting VI keybindings for the terminal emulator:
 
 Edit your .inputrc file (or create if it does not exist) and insert the following:
 set editing-mode vi
 set keymap vi-command
 
 Note: You have to export the EDITOR variable ans vim: export EDITOR=vim
 Or, save it it the file that contains the env variable. Where you save your proxy info. i.e. 
 echo "EDITOR=vim" >> /etc/environment
 echo "VISUAL=vim" >> /etc/environment
 
 Now save and open the terminal. It'll behave like vim in insert mode. Although it not as powerful as vim, it is surely something. All the basic vim commands are usable. You can press v to enter the text editor for better editing. 
 Here is the cheatsheet: http://www.catonmat.net/download/bash-vi-editing-mode-cheat-sheet.txt
 "
 
# Applying particular config file to a particular file in vim
 
 Create a somefile.vim containing settings for the file. (Only the ones OTHER THAN the main ~/.vimrc)
 Run it with -S param.
 vim -S somefile.vim filename
 
# Vim plugin Pathogen
 Follow instructor  from git.
# calendar.vim
 Since  I have pathogen to install vim plugins, cloning the repo to .vim/bundle/ installs it.
 Setting the google options in .vimrc, when I do :Ca inside vim, I cannot copy the link got google authentication. So I opened it in gvim and copied it. But in gvim, I cannot paste the code that I received from google. So I hand-typed it. Very annoying.

 Here is a quick possible solution:
 1. Open gvim
 2. Type :Ca
 3. Copy the link
 4. Paste in browser, proceed, get a code
 5. Edit the file .vim/bundle/calendar.vim/google/client.vim and navigate to the line: 
 let code = input(printf(calendar#message#get('access_url_input_code'),
 (This line is inside a function called access_token_async. The input code here is not able to access the bufferes "+, "* etc. So we manually supply the value of variable 'code'. Make sure this modification does not stay for long)
 6. Modify the line to
 let code = 'xxxx_your_code_goes_here_xxxx'
 7. Save the file.
 8. Open usual vim and run :Ca and it should work directly.
 9. Undo the changes in client.vim and save it back. This step is necessary because you don't want to leave the code in a config file that is possibly uploaded to github. Make sure there are no git commits in the time interval between the two saves otherwise someone can look at the history of the file and retrieve it.
 
 See the calendar.vim/doc/calendar.txt for a complete help which I followed mostly.
 As a shortcut in awesomerc, add `xterm -e vim +:Ca` to open vim in a terminal with command :Ca and mapped it to Modkey+C
 
  
# Setting up neovim

Install with `sudo apt-get install neovim`

Launch with `nvim`

To make neovim use the config and plugins of vim, create the file `~/.config/nvim/init.vim` and insert
```
" Using the path and plugings of vim 
set runtimepath^=~/.vim runtimepath+=~/.vim/bundle
let &packpath=&runtimepath
source ~/.vimrc
```

For vimtex, we need to use servermode, which is not directly available. Install it using
`sudo pip3 install neovim-remote`
(Note that the sudo is added to make sure the installation path is found by the shell. Otherwise, we need to add the path of local installation to `$PATH`)

vimtex now advises (link:https://github.com/lervag/vimtex/wiki/introduction#neovim) to add the following to init.vim
```
" Do this after installing neovim-remote using pip3
let g:vimtex_compiler_progname = 'nvr'
```
Apparently, nvim _always_ launches itself in server mode by default, so no need to launch it in servermode (with `--listen` parameter) unlike vim.

The behavior of nvim seems to be a bit faster than vim, although I am yet to be sure. coc.nvim still hangs as soon as more than the main option is uncommented in .vimrc.

# coc.nvim  

## Installation: 
[deprecated] `git clone` the plugin to `.vim/bundle/` directory (if using Pathogen for managing plugins. Inside the downloaded path, run `install.sh` which downloads node.js and installs it.
[New, didn't work properly] 
Modification to the official instruction to get nodejs: use sudo to install nodejs
Install nodejs as root using
```
curl -sL install-node.now.sh/lts | sudo bash
```

Copy-paste the suggested config into .vimrc, then TURN OFF mapping with `<cr>` since it causes infinite loops and makes nvim (and vim) freeze!!

Caution: vim (and nvim) hangs when this part of the .vimrc (suggested by coc.nvim documenttion) is turned on.
```
"" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
"" position. Coc only does snippet and additional edit on confirm.
"if exists('*complete_info')
"  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif
```
So, make sure to turn it off. One bugreport says upon hitting <cr>, vim goes into an infinite loop of <cr>s.

Moreover, turn off do the following change to .vimrc to avoid slow load of ranger upon pressing <leader>r.

```
"nmap <leader>rn <Plug>(coc-rename)
nmap <leader><f2> <Plug>(coc-rename)
```

To use ultisnip snippets, install the coc-extension `coc-snippet` using `:CocInstall coc-snippets` (and other extensions if needed). The snippets show up with a tilde at the end.

Note: snippets defined using regex do not show up :(

To use intelliSense code expansion and jumping etc, we need to install language server specific to that language, either using `:CocInstall` or manually and then configure using `:CocConfigure`.

If you want the definitions, implementations etc to open in a new tab (jump to existing tab if it is already open, `drop`), add the following to `~/.vim/coc-settings.json` or via `:CocConfig`:
(**Caution:** Does not work when the file is not already open. Use the next `nmap` command and replace the existing `gd`)
```
{
    "coc.preferences.jumpCommand": "drop"
}
```
Alternatively, to open _only_ the definitions in a new tab, edit the line with shortcut `gd` in `vimrc` to
```
nmap <silent> gd :call CocAction('jumpDefinition', 'tab drop')<CR>
```

For example, to use C++ code completion, jumping to definition etc, we use `clang`. Install it using `sudo apt-get install clang`. Then install the extension using `:CocInstall coc-clang`. Now, we have more information on the auto-completion, including argument names for functions etc. 
It does not work well since it cannot find many paths of header files, for example.

To use coc code-completion with vimtex, install `:CocInstall coc-vimtex`
(I tried coc-texlab, which is a language server for tex, could not see and linting hapending, so abandoned. Maybe look into it in details?)

Could not find one with matlab yet.

## features
* `:CocList services` to open services list, you will have id state and filetypes for each service.


## How to
* Get suggestions from predefined snippets (from `Ultisnips`) with `:CocInstall coc-snippets`
* Pressing tab should automatically fill up the cursor position with the first suggestion, instead of having to press ctrl-n. How to do that? Notice: <S-Tab> actually does what is expected.
* How to resolve behavior of pressing tab twice when the first result is a snippet?
* what is the purpose of Ctrl-space to coc#refresh()??


## coc-pyright for python 
[link](https://github.com/fannheyward/coc-pyright)
* Install 
```
:CocInstall coc-pyright
```
* Organize the lines with `import` with
```
:CocCommand pyright.organizeimports
```
* Format the code with `:Format` 
to make it work, first `pip3 install autopep8`
then run `:CocConfig` and add within the fist (outermost) curly braces:

```
{
"python.formatting.autopep8Path": "~/.local/bin/autopep8",

}
```
Otherwise, the plugin cannot find the installation location!

* [Doesn't work] For packages like `numpy`, a type stub needs to be created to avoid error messages
```
:CocCommand pyright.createtypestub numpy
```
This creats a directory called `typings` where stubs are kept.


## Code completion and definition for C/C++ files #

* Install the C/C++ language server `clangd` with `sudo apt-get install clangd`
* Install the clangd extension to coc using `:CocInstall  coc-clangd`. Alternatively, provide the configuration using `:CocConfig` and pasting the following:

``` 
{
"languageserver": {
    "clangd": {
      "command": "clangd",
      "rootPatterns": ["compile_flags.txt", "compile_commands.json", ".git/"],
      "filetypes": ["c", "cpp", "objc", "objcpp"]
    }
  }
}
```

Alternatively, use the `ccls` (`sudo snap install ccls --classic`) and include in `:CocConfig`
```
{
    "languageserver": {
        "ccls": {
            "command": "ccls",
            "filetypes": [
                "c",
                "cpp",
                "objc",
                "objcpp"
            ],
            "rootPatterns": [
                ".ccls",
                "compile_commands.json",
                ".vim/",
                ".git/",
                ".hg/"
            ],
            "initializationOptions": {
                "cache": {
                    "directory": "/tmp/ccls"
                }
            }
        }
    }
}
```

- Install `ccls` from source
[link](https://github.com/MaskRay/ccls/wiki/Build)
```
# download
git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cd ccls

# install dependencies
sudo apt install cmake clang libclang-dev
sudo apt install zlib1g-dev libncurses-dev

# cmake configure
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=/usr/lib/llvm-7 \
    -DLLVM_INCLUDE_DIR=/usr/lib/llvm-7/include \
    -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-7/

# cmake build
cmake --build Release

# install
sudo cmake --build Release --target install
```

* In your C/C++ project, generate a file called `compile_commands.json` using `CMake` (if the project is CMake-based) or `bear` (if the project is `make`-based) in the following way. [link](https://releases.llvm.org/8.0.0/tools/clang/tools/extra/docs/clangd/Installation.html)

* If your project builds with CMake, it can generate `compile_commands.json`. You should enable it with:
```
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1
```
`compile_commands.json` will be written to your build directory. You should symlink it (or copy it) to the root of your source tree, if they are different.
```
ln -s ~/myproject/compile_commands.json ~/myproject-build/
```
* Other build systems, using `Bear`: Bear (`sudo apt-get install bear`) is a tool that generates a `compile_commands.json` file by recording a complete build.

For a make-based build, you can run 
```
make clean; bear make
```

 to generate the file (and run a clean build!)

* Edit a file with `vim`. At this point coc should recognize the file. Verify that with `:CocList services`. Now, place the cursor over a call of a function and press `gd` (`<Plug>(coc-definition)` in `.vimrc`) to jump to the definition of the function.


# vim-matlab modifications

Git clone vim-matlab and make the following changes.

* `mlint` as code checker (linter): First locate `mlint`. The location of the binary `matlab` can be found using
```
whereis matlab
```
My output is `matlab: /usr/local/bin/matlab`. A quick `ls -l` shows that it is actually a soft link to `/usr/local/MATLAB/R2020a/bin/matlab`. The binary `mlint` must be nearby. Turns out, mlint is in the location `/usr/local/MATLAB/R2020a/bin/glnxa64/mlint`.
Create a soft link in `/usr/local/bin/` of `mlint` using
```
ln -s /usr/local/MATLAB/R2020a/bin/glnxa64/mlint mlint
```
Now, mlint can be invoked from other terminals like this: `mlint filename.m`.

Therefore, `$HOME/.vim/bundle/vim-matlab/compiler/mlint.m` can access it. Now, we need to set mlint as a compiler for the .m files. Filetype-specific options can be set in the `ftplugin` directory. So, in the file `$HOME/.vim/bundle/vim-matlab/ftplugin/matlab.vim`, we add
```
compiler mlint
```
Now, after opening a .m file, we can issue `:make` and then `:copen` to see error messages. We can combine these options together and another line to the file `ftplugin/matlab.vim`
```
map <silent> <Leader>ll :make<CR>:copen<CR>
```
This launches the errors when we press `\ll`, to be consistent with latex shortcut.

* Enable matlab jump of cursor between `for` and associated `end` using %
Matchit has been added to the main vim version since v6. To enable it add to .vimrc

```
runtime macros/matchit.vim
```
See more help with `:h matchit`.


# Vim search for string in a case-sensitive manner temporarily
Use \C in the beginning, i.e. search for string 'ThisThat' using `/\CThisThat`. To search in a case-insensitive manner, use `\c`. 
Moreover, searching backward can be done with `?` instead of `/`.

# Folding Help:
 
  zi 	switch folding on or off
 * za 	toggle current fold open/closed
   zc 	close current fold
 * zR 	open all folds
 * zM 	close all folds
   zv 	expand folds to reveal cursor
  
 * zj,zk	jumps to the next/previous fold, even when unfolded
   zo,(zO)	open fold (recursively)
   zc,(zC)	closefold (recursively)
 * zA	toggle folds recursively
  
Folding Options (Should change in TODOsettings.vim file to make it permanent.)
 set foldnestmax=10      "deepest fold is 10 levels
 set nofoldenable        "dont fold by default
 set foldlevel=1         "this is just what i use
 set shiftwidth=1 	to consider spaces as one foldlevel away
 
Searching Help:

```
:set foldopen-=search  		"to stop folds from opening on search, which is even better.
:folddoopen s/old/new/ge 	"to replace old with new in the lines which are not folded. 
```


Warning: 
 Smartindent is on, hence use <F2> before pasting into it.
 
Want: 
 Not more than 2 stages of folding
 Search within the visible folded text
 Search within the invisible text inside folds
 INdent = on
 
