# Vimtex experience
Install via pathogen using:
```
cd .vim/bundle
git clone https://github.com/.../vimtex
```

Install `latexmk` using `sudo apt-get install`


Setting zathura as the default viewer
let g:vimtex_view_method = 'zathura'

Check the info using <leader>li (<leader> = \)
Start the continuous compile mode using \ll. At this point, automatically compiles when the file is saved. 
\lv to display the pdf file and do a forward search 

:VimtexLabelsOpen|:VimtexLabelsToggle: open table of labels
\lt  or :VimtexTocOpen|:VimtexTocToggle: open a clickable toc in the left pane (q will close the window) 
:VimtexCompileOutput: show the output form the compilation command (i.e. from latexmk)
:VimtexErrors: open quickfix window if there are errors or warnings.
:VimtexClean: clean auxilliary files like *.aux, *.out, and so on files. Use :VimtexClean! to remove everything, including the generated pfd file.

delete surround environment (dse) and cse works. So do dsc and csc for commands.
tse (toggle star environment) and tsc toggles star in envs and commands
tsd (toggle star delimiter) changes the surrounding delimiter to appropriate latex version, eg. () becomes \left( \right)

To traverse through the autocomplete dropdown list, use C-P and C-N instead of the arrows.
Eg. type \cite{Bour<C-X> <C-O>
Then use C-P and C-N to choose the right one. It supports regex as well

Now % can jump through \left( and \right)

Close matching delimiters (brackets or other pairing symbols like $, $$ etc) using ]] in insert mode.
In insert mode, ]] also closes the current unclosed environment.

In normal mode, [[ and ]] jump through sections and subsections. Moreover ]m jumps through the start of the next environment (faster navigation, also use \lt)


\lm to see all the macros, like \alpha = `\`a` etc

To be able to access the help file (:h vimtex), you might get errors that it does not exit. In that case run :Helptags by which pathogen creates a list of all help files from doc directories. Use Ctrl-w + O to make the help window fullscreen. Ctrl-w + C closes a window.

Syntax folding and expanding: zi and za to fold and unfold all

Q: Is it convenient or worth it to make all the greek letters with (a<Tab> = \alpha)?
 Maybe not, since we already have `\`a` (typed quickly). See \lm for a complete list.
Q: How to add align* environment quickly?
 Using Ultisnip, so use al*<Tab>
Q: How to add templates quickly?
 Using Ultisnip, decided to use `_pde` etc. (leading underscore for template completion)
Q: Good to know: shutting down continuous compile.
 Added the line 
	let g:vimtex_view_forward_search_on_start = 0
 to .vimrc to stop launching the pdf reader twice.
Q: vim-easymotion leader key bug is not here anymore, but is very slow
 Turned off most of it, kept \w for word jump. However, it interferes with vim-sandwitch command m( to select \left( \right) pair.
Q: In-file timestamp for current save time.
 Not sure yet, need to use autocommand.
Q*: Jump to locations of the file for application process.
 \lt to open a table of contents. Also \lv jumps to compiled part.
Q: Need shortcut for sac<align*> etc (<F7> works for command)
 Still need to unify the behavior of <Tab> and <F7>.
Q: Intuitive conflict between vim-sandwich (sree = surround replace env by env) and default (cse = change surround e)

Features from vim-latex-suit:
frac needs to be two-key

Selected text enclosed by command or environment: 
Using vim-sandwich instead of vim-surround. The default keybindings are intuitive
sa, sd, sr (surrounding add/delete/replace), followed by the delimiters.
Works in visual mode as well. 
Works with vimtex environments and commands with sac and sae (surround add command/environment) both in normal and visual mode.
<F7> still works in normal and visual mode to create commands. However, the brace does not close automatically, which is a problem.

Idea: maybe map S-<F7> to cse and S-<F5> to csc

Using Ultisnip:
I am using Tab for both TriggerExpand and TriggerJumpNext. (Instead of Tab and C-j respectively, to preserve placeholder jump <++>)

If you hit Esc or do undo while filling up one of the fields in a snippet, Tab does not take the cursor to the next place anymore. 
In that case, to jump to the next place in the incomplete (actually, untraversed) snippet, enter Insert mode, and then hit Tab.
Be careful to not expand the current word.
Therefore:
	Shortcut to resume incomplete snippet traversal: i <tab>
Note: As long as the cursor does not reach $0 (or at the end of the snippet if $0 is absent), the snippet does not end

While writing snippets, the backslashes need escaping (for new line, etc)

Converting selections to environments using $VISUAL snippets: select
text in visual mode, press <tab>. This deletes the selected text and
you enter the insert mode. Now, type the trigger word for the snippet
which has `$VISUAL` in it. Now pressing <tab> again will expand the
snippet with copies visual mode text pasted in the right location.


# vimtex use xelatex and the compiler

Put this line as the first line of the tex file

```
%! TEX program = xelatex
```
and restart vim.


# Compiling tex files with svg

- Include the svg package

```
\usepackage{svg}
```

- Add svg files with

```
\includesvg{path/file.svg}
```


- Use shell escape to compile

```
pdflatex --shell-escape file.tex
```

