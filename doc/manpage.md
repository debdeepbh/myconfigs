# Writing a manpage
 It uses something called troff markdown language.
 Create a file starting with the following lines and open with
 	man -l filename.

 Body of the manpage:
 .Dd date-of-modification
 .Dt name-of-the-article 7 (7 for miscellaneous manual. see man man for explanation)
 .Sh NAME
 .Nm name of the article
 .Nd description of the article
 
 Caution
     ·   Keep codes in within a .Bd -literal ... .Ed block.
     ·   Do NOT write Em anywhere in your text, it will vanish. Write \&Em
         instead.
   Frequently used macros
     .Sh           New Section
     .Ss           New subsection
     .Bl           begin list. It can take the following parameters: -bullet,
                   -item, -enum, -tag, -hang etc.
     .It           items inside .Bl and .El
     .El           end list
     .Pa           path for a filename
     .Bd           begin a display block, It takes a few parameters, most importantly -literal which is useful for source codes, spaced and tabbed text.
     .Dl           literal text of one line
     .Ed           end display block one line of literal text.
     \fB           begins bold
     \fI           begins Italian
     \fR           ends bold and/or Italian
     .Em           emphasize (a line of bold, similar to \fB ... \fR). If using
                   inside an item of list, use without the dot, e.g.  .It Em tagname

  escape chars  \e generates a \, \& replaces at the beginning of a sentence,
                   but doesn't generate a .

                   Type        Output
                   \e            \
                   \efB          \fB
                   \&.           .
                   \&Em          Em

     See the BSD manpage for mdoc online. (Note: mdoc for Arch is something else)
     http://man7.org/linux/man-pages/man7/mdoc.7.html

     Some examples:
     http://manpages.ubuntu.com/manpages/trusty/pt/man7/mdoc.samples.7.html

     There is a way include a custom file to man database.

