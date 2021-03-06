# Latex tutorial

pdflatex should convert the tex file to pdf.
I wish to use xdvi (already installed through some package, find out which one) to perform forward and inverse search.
vimlatex-suite must be used.

\rf to collapse all the equns.
za to expand individual folds. How to expand all? Ans: zi
how to compile? how to set the right program to pop up at the right time.
what are the keypresses during compilation?



pressing F7 while the cursor is touching a word will turn it into a keyword along with the format. E.g.
frac becomes \frac{<<++>>}{<<++>>}<<++>>
word becomes \word{}<<++>>
etc.

Useful: frac <F7>, textbf<F7>

You can select some text in visual mode (v) and then press <F7> and enter the desired keyword to turn it into the arguments of a keyword.

Useful: If you want to make some text bold, select the text in visual mode, press <F7> and type textbf and hit <enter> to make that text boldface.
Or, select a long expression through visual mode and press <F7> and type sum and <enter> to put a Sum sign beofre that.


Shift+<F7> will let you change the parent command that you are inside.

For inserting things like \begin{equation} ...\end{equation}, enter equation and press <F5>. Shift+<F5> works accordingly.


Typing SSE will turn into
\section{New Section}, which is a nice way to start a section.
Others are 

SPA for part
SCH for chapter
SSE for section
SSS for subsection
SS2 for subsubsection
SPG for paragraph
SSP for subparagraph


Most useful:::
Greek Letter Mappings

Lower case
`a through `z expand to \alpha through \zeta.

Upper case:

`D = \Delta
`F = \Phi
`G = \Gamma
`Q = \Theta
`L = \Lambda
`X = \Xi
`Y = \Psi
`S = \Sigma
`U = \Upsilon
`W = \Omega


Expanding the arrangement situation:
`^   Expands To   \Hat{<++>}<++>
`_   expands to   \bar{<++>}<++>
`6   expands to   \partial
`8   expands to   \infty
`/   expands to   \frac{<++>}{<++>}<++>
`%   expands to   \frac{<++>}{<++>}<++>
`@   expands to   \circ
`0   expands to   ^\circ
`=   expands to   \equiv
`\   expands to   \setminus
`.   expands to   \cdot
`*   expands to   \times
`&   expands to   \wedge
`-   expands to   \bigcap
`+   expands to   \bigcup
`(   expands to   \subset
`)   expands to   \supset
`<   expands to   \le
`>   expands to   \ge
`,   expands to   \nonumber
`~   expands to   \tilde{<++>}<++>
`;   expands to   \dot{<++>}<++>
`:   expands to   \ddot{<++>}<++>
`2   expands to   \sqrt{<++>}<++>
`|   expands to   \Big|
`I   expands to   \int_{<++>}^{<++>}<++>


Must get used to it. As soon as possible.


 In addition the visual mode macros are provided:

`(  encloses selection in \left( and \right)
`[  encloses selection in \left[ and \right]
`{  encloses selection in \left\{ and \right\}
`$  encloses selection in $$ or \[ \] depending on characterwise or
                                      linewise selection

Use the Alt key to make inserting all the \left ... \right stuff very easy: see the help, does not work becuse Alt is being used somewhere in my system. MOving on.

Pressing the Alt+B however, converts the previous character into a \mathbf{} character which is super-useful. Figure out a way to turn it into \mathbb{} whic I use more often. Shouldn't be hard. Or, make your own. Have to find out how. It is in the Macro Customisation Section: http://vim-latex.sourceforge.net/documentation/latex-suite/customizing-macros.html




There is a referencing help section in completion section. Read later if you are into the \ref{equn:name} kind of things. Not useful for now.

 Pressing ... (3 dots) results in \ldots outside math mode and \cdots in math mode. 


Ctrl+j jumps through <<++>>.



Compiling::

copy the file /root/.vim/ftplugin/latex-suite/texrc to  /root/.vim/ftplugin and name it tex.vim:

cp /root/.vim/ftplugin/latex-suite/texrc /root/.vim/ftplugin/tex.vim

This will be our new config file that we'll use.

link: http://vim-latex.sourceforge.net/documentation/latex-suite/latex-compiling.html

Pressing \ll compiles the tex file into dvi and log etc. Works when evince is installed and the texrc file is unchanged.

In the textrc file, the TexLet g:Tex_ViewRule_<filetype> is set to xdg-open as a first choice. The other choices are xpdf, xdvi etc which can be replaced accordingly to our choices. Alternatively, we can modify the xdg-open's default programme to open these file types.
To see the default programme for a certain filetype, we need xdg-mime. 
Here, we want to change the default programme to open the filetypes application/pdf and application/x-dvi.

Currently, I want the pdf opener to be apvlv and the dvi opener to be evince-previewer (soon to be changed to xdvi for the sake of lightness) for now. So I will issue the following commands:

xdg-mime default apvlv.desktop application/pdf
xdg-mime default evince-previewer.desktop application/x-dvi

won't work, so I'll have to edit the file /usr/share/applications/mimeinfo.cache to make the desired programme to be the default one.

To make xdvi the default dvi player, I had to create a desktop settings file called xdvi.desktop in /usr/share/applications with the following content:

[Desktop Entry]
Version=1.0
Type=Application
Name=xdvi
Comment=A minimalistic document viewer
Exec=xdvi %f
Terminal=false
Categories=Office;Viewer;
MimeType=application/x-dvi;

Then I had to add xdvi.desktop in the mimeinfo.cache file. Then it worked.

Does not work: You can visually select a portion of the file and press \ll to compile that portion with the preambles of the file included. \lv works in visual selections too, as soon as I make this \lv work.

Info: The file ~/.vim/ftplugin/latex-suite/texrc says, the default programme to open the pdf, dvi, ps files is xdg-open, which is not really a programme since it was eveince when it was installed, but as soon as I uninstalled it, it became firefox. This xdg-open seems to be some kind of generic programme name which maintains the list of programmes installed.

Copy this file to:

Default format is dvi and it is already set:
g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'

you can supposedly change it, by commands like g:Tex_CompileRule_<format>, god knows how.


Pressing \lv is supposed to show the output file, but does not work yet.

 Pressing \ls from within Vim should make the viewer display the portion of the document where your cursor is placed. 

Note for future forward/backward searching implementation: 

Most DVI viewers need "source-special" information in order to do forward (and inverse) searching. This information is embedded in the dvi file if the LaTeX source is compiled with the --src-specials option. By default, Latex-Suite does not supply this argument to the compiler. See the section on g:Tex_CompileRule_dvi to find out how this option can be set. For pdf viewers you need to use the pdfsync package in your LaTeX document. 


While using compiling to pdf using pdflatex, you get the Warning: Label(s) may have been changed. Rerun to fix it.
Then you should re-run it using \ll and the warning should go away. Should find out details about this one.

Easiest way to make the output format "pdf" is to add this line to .vimrc:
let g:Tex_DefaultTargetFormat='pdf'

" To change the default viewer
let g:Tex_ViewRule_pdf = 'evince'


I think, you can modify all the variables this way. Just replace the TexLet by let and you are good to go.

Alternatively, you can always edit the file tex.vim and make the necessary changes.


Ok, forward search worked with dvi and xdvi. Here is how:

add the lines to your .vimrc and you are done:
let g:Tex_ViewRule_dvi = 'xdvi'

to make the default dvi player xdvi and finally:
let g:Tex_CompileRule_dvi = 'latex -src-specials -interaction=nonstopmode $*'
to enable search available.
Actually all those line of codes to detect which your default pdf viewer is through xdg-open etc etc got lost somewhere in the process and didn't make it through.


Inverse search worked with Ctrl+click on the xdvi window which was opened through \lv or \ls.
Strange! Ctrl+Click opens new vim window even when I open only the dvi file through xdvi independently.

To make the same instance pop up every time, we need vim to have the +clientserver command enabled.

Now we want it to work with

1. dvi in evince 
2. pdf in apvlv


Inverse search works!! with xdvi and vim:

Two commands:

vim --servername mynewserver db.tex
xdvi -editor "vim --servername mynewserver --remote +%l %f" db.dvi &

It basically creates a server called mynewserver and both get connected to it. Ctrl+click on the xdvi file will bring the cursor to vim and pressing \ls in vim will select the cursor to the xdvi window.

If you make a change in the tex file, save it (:w) and compile it (\ll). At this stage, the dvi file won't be changed. You have to press \ls once to see the change.

Time  to automate this thing with one command.

so, if you keep this line:
let g:Tex_ViewRuleComplete_dvi = 'xdvi -editor "gvim --servername sofun --remote +\%l \%f" $* &'

in your .vimrc file, pressing \lv will launch xdiv attached to the server called "sofun".
So, in order to ensure that your vim window is attached to the same server, instead of launching vim normally, you must launch:

vim --servername sofun filename.tex

This will work like a charm.

Very Important: It is very important to press \lv before pressing \ls to start using this mechanism.!!!

To use inverse search with pdf and evince, do the following:

Add or, activate the following in the .vimrc:

let g:Tex_ViewRule_pdf = 'evince'

to make the default pdf viewer to be evince. And,

let g:Tex_DefaultTargetFormat='pdf'

to compile as pdf. Also,

let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 -interaction=nonstopmode $*'

to support the syncing in tex files through SyncTex package command.:w



While working:

To get the sum limits and have the placeholders, add this to vimrc.
let g:Tex_Com_sum = "\\sum\\limits\_{<++>}\^{<++>}<++>"
let g:Tex_Com_cap = "\\bigcap\\limits\_{<++>}\^{<++>}<++>"
let g:Tex_Com_cup = "\\bigcup\\limits\_{<++>}\^{<++>}<++>"
let g:Tex_Com_lim = "\\lim\\limits\_{<++>}\^{<++>}<++>"


Remove "Failed to load bookmarks" the zathura warning by muting it forever in bashrc. Add this alias, not to te vimrc, but to your .bashrc:
alias zathura='zathura "$@" 2>/dev/null'

No, \lv make it load itself, this process does not respect the bashrc.


finally:
let execString = 'silent! !'.viewer.' --synctex-forward '.line('.').':1:"'.expand('%').'" "'.mainfnameRoot.'.'.s:target.'"'

The modification of the code in compiler.vim file:

----------------------------------------------
else
                        if viewer =~ '^ *zathura'
                        " We must be using a generic UNIX viewer
                        " syntax is: viewer TARGET_FILE LINE_NUMBER SOURCE_FILE
                        "let execString = 'silent! !'.viewer.' "'.mainfnameRoot.'.'.s:target.'" '.line('.').' "'.expand('%').'"'
                        "zathura --synctex-forward 193:1:paper.tex paper.pdf
                                let execString = 'silent! !'.viewer.' --synctex-forward '.line('.').':1:"'.expand('%').'" "'.mainfnameRoot.'.'.s:target.'"'

                        else
                                let execString = 'silent! !'.viewer.' "'.mainfnameRoot.'.'.s:target.'" '.line('.').' "'.expand('%').'"'
                        endif


                endif

----------------------------------------------

Or, this part of code in the .vimrc to make \f work as \ls:

-----------------------------------------------------------
function! SyncTexForward()
"     let execstr = "silent !zathura --synctex-forward %:p:r.pdf\\#src:".line(".")."%:p &"
        let execstr = 'silent! !zathura --synctex-forward '.line('.').':1:"'.expand('%').'" "'.expand("%:p:r").'".pdf'
        execute execstr
endfunction
nmap <Leader>f :call SyncTexForward()<CR><C-L>

--------------------------------------------------

Add the lines to .vimrc to save and compile with one command \k:
" To save and compile with one command \k (k=kompile) :)
nmap <Leader>k :w<CR> <Leader>ll<C-L>

Note: Have to use the \lv to launch the pdf file generated. We work with \k, \f now.

Good News: This makes the "Press ENTER or type command to continue" prompt! :) Sweet Success!


Now we create a custom command for this mini setup that we have created. We create the file called vetx and paste the following lines:

# The file called vtex make it better
for i in "$@"; do
    if [[ ${i} == *.tex ]]; then
        fileName=$i;
        # Strip off path and extension, and convert to uppercase.
	# although there is no need to turn into upper case
        serverName=$(sed -e 's:\(.*/\)\?\(.*\)\.tex:\U\2\E:' <<< $i)
        break;
    fi
done

if [[ ${serverName} == '' ]]; then
	echo 'not a tex file or no non-extension part, no server to create'
else
	# run in server mode
	# now we need to make sure the forward search connects to the right server
	# check in .vimrc or tex.vim to see if it is correct
	echo 'creating server called $serverName'
	exec vim --servername $serverName "$@"
fi

-----------------------------

Now we call run the same server while issuing pdflatex by modifying the necessary line in .vimrc:
---------------------
" Get the correct servername, which should be the filename of the tex file, 
" without the extension 
" Using the filename, without the extension, not in uppercase though, but 
" that's okay for a servername, it automatically get uppercased 
let theuniqueserv = expand("%:r") 
 
" Working!!!, when we run vim appropriately 
let g:Tex_ViewRuleComplete_pdf = 'zathura -x "vim --servername '.theuniqueserv.' -- remote +\%{line} \%{input}" $*.pdf 2>/dev/nul &' 

-------------------------------

Note: the variable ViewRuleComplete_pdf was defined in a different way. Please make sure you modify it while you are going for this vtex package thing.



Templates:

Insert a template in an empty tex file by :TTemplate.
You can create your own template with <++> and required packages inside /ftplugins/templates (check spelling)

Conclusion::

Now we can launch this setup using vtex for all these supports:
* vim-latex suite
* own custom placeholders for \sum, \bigcup etc
* Use forward and backward search
* \k to kompile and \f forward
* vtex package for only for tex files
* 



TODO:

* Make this vtex file recognise only tex files.
* Make all this pdf-latex things separate from .vimrc. I think it can be done with vim.tex file.



General LATEX tips:

1. Use align* instead of equation*
2. Text in equation mode: \text{your text here }
3. No page number: Add \pagestyle{empty}  to the preamble
4. New line in equation mode: not possible as of now
5. \mathcal for caligraphy fonts (power set, etc) , \mathbb for those scripted fonts for standard sets (Real number, Rationals etc)
6. To export a pdf into png after trimming the empty spaces with good resolutions, do the following:
	(a) Add  \pagestyle{empty} to the preamble of the tex file so that the page number does not appear in the bottom. You can save some empty space there.
	(b) Compile and get the pdf file.
	(c) Use the imagemagick tool "convert" to trim empty spaces, convert to png with specified pixel density:
		convert -trim -density 150 infile.pdf outfile.png

7. To write reasons on the right inside align* tag, use \tag*{}. Just write your text in it.


## Placing figures next to each other
So far, the easiest way to do that is to use `columns` environment
(Subfigures are not useful unless there is a global caption for all,
which is unlikely).
Example:
\begin{columns}
	\begin{column}{0.33\textwidth}
	\begin{figure}[htpb]
		\centering
		\includegraphics[height=3cm]{plasma}
		\caption{plasma globe}%
	\end{figure}
	\end{column}
	\begin{column}{0.33\textwidth}
	\begin{figure}[htpb]
		\centering
		\includegraphics[height=3cm]{corona}
		\caption{plasma globe}%
	\end{figure}
	\end{column}
	\begin{column}{0.33\textwidth}
	\begin{figure}[htpb]
		\centering
		\includegraphics[height=3cm]{corona}
		\caption{plasma globe}%
	\end{figure}
	\end{column}
\end{columns}

