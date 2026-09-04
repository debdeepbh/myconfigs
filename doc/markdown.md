# Bash script to create a table in markdown

We want to create the following table from a matrix of values.
```
|  4 |  5 |  6 | 
|  :---: | :---: | :---: |
|  (4,1) | (4,2) | (4,3) |
|  (5,1) | (5,2) | (5,3) |
|  (6,1) | (6,2) | (6,3) |
```

The following code can be used

```bash
## markdown table
file=$HOME/img_compare.md
rm $file

echo "# comparison" >> $file
echo "" >> $file

# headers
#echo -n "| " >> $file
echo -n "|    |" >> $file
for del in ${dellist[@]}
do
    echo -n " del=$del | "  >> $file
done
echo "" >> $file

# alignment
#echo -n "| " >> $file
echo -n "| :---: | " >> $file
for del in ${dellist[@]}
do
    echo -n " :---: |"  >> $file
done
echo "" >> $file

for m in ${mlist[@]}
do
    #echo -n "| " >> $file
    echo -n "| m=$m | " >> $file
    for del in ${dellist[@]}
    do
	echo -n " ($m,$del) |" >> $file
	#echo -n " ![img]($HOME/img_pacman_comp/${del}_${m}_${rc}/img_tc_00025.png) |" >> $file
    done
    echo "" >> $file
done
```

The body can be images too:
```
echo -n " ![img]($HOME/img_pacman_comp/${del}_${m}_${rc}/img_tc_00025.png) |" >> $file
```

- To transpose the matrix (table), we add an optional argument to the function

```bash
    if [ "$1" = "transpose" ]
    then
	arr2=("${mlist[@]}") 
	arr1=("${dellist[@]}") 
    else
	arr1=("${mlist[@]}") 
	arr2=("${dellist[@]}") 
    fi

    ## markdown table
    file=$HOME/img_compare.md
    rm $file

    # headers
    #echo -n "| " >> $file
    echo -n "|    |" >> $file
    for val2 in ${arr2[@]}
    do
	echo -n " del=R/$val2 | "  >> $file
    done
    echo "" >> $file

    # alignment
    #echo -n "| " >> $file
    echo -n "| :---: | " >> $file
    for val2 in ${arr2[@]}
    do
	echo -n " :---: |"  >> $file
    done
    echo "" >> $file

    #for m in ${mlist[@]}
    for val1 in ${arr1[@]}
    do
	#echo -n "| " >> $file
	echo -n "| m=$val1 | " >> $file
	#for del in ${dellist[@]}
	for val2 in ${arr2[@]}
	do

	    if [ "$1" = "transpose" ]
	    then
		#echo -n " ($val1,$val2) |" >> $file
	    else
		#echo -n " ($val2,$val1) |" >> $file
	    fi
	done
	echo "" >> $file
    done
```

The markdown can be converted into html (or latex, or pdf) using
```
html=$HOME/img_compare.html
pandoc $file -s -o $html --css $HOME/pandoc.css
```
The css template `pandoc.css` is taken from [here](https://gist.github.com/killercup/5917178). The css file also controls the width of the page. Without it, the page size is undefined. Other templates can be used to convert to html with different style.

# Tex and markdown conversion to html with pandoc


- Put all latex preamble in the header part of the `.md` file [source](https://pandoc.org/MANUAL.html#extension-yaml_metadata_block) like this

```yaml
---
title: Readme
author: Author
header-includes: |
    \usepackage{amsmath, amssymb, amsthm, amsfonts, color, bm}

    \newcommand{\R}{\mathcal{R}}
    \newcommand{\ww}{\boldsymbol{\omega}}
    \newcommand{\xx}{\mathbf{x}}
---
```

- Converting a tex file into html `pandoc file.tex -o file.html` uses unicode by default to render math symbols. We need to use `mathjax` for a nicer rendering. Other options are

```
--mathml, --webtex, --mathjax, --katex
```

and demos can be found in pandoc [demos](https://pandoc.org/demos.html).

According to [pandoc documentation](https://pandoc.org/chunkedhtml-demo/3.6-math-rendering-in-html.html) One need to specify the url of the `.js` file that would be used to convert math into mathjax. By default pandoc uses some link form some content delivery network (CDN), which does not work on firefox at the first attempt. So we can specify the url like this:

```
pandoc math.text -s --mathjax=https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js -o   mathMathJax.html
```

There are other CDN locations on [mathjax documentation](https://docs.mathjax.org/en/latest/web/start.html#cdn-list) from sites like

- jsdelivr.com [latest or specific version] (recommended)
- unpkg.com [latest or specific version]
- cdnjs.com
- raw.githack.com
- gitcdn.xyz
- cdn.statically.io


- To use latex goodies such as snippet completion etc in vim, set 

```vim
:setfiletype pandoc.tex
```

# Markdown as writing tool

A combination of tools required to make the entire workflow possible.

| Tool                  | Purpose                                   |
|-----------------------|-------------------------------------------|
| vim-pandoc            | compilation, live preview                 |
| vim-pandoc-syntax     | syntax highlighting for delimited code    |
| easy-pandoc-templates | to produce reasonable looking html output |
| vim-tablemode         | creating and handling markdown tables     |
| ?                     | file management, tagging, searching       |
| ?                     | file backup                               |

### Good things

- Easy to type
- Easy to include images

- pdf output
 - perfect equation rendering with default parameters
 - Images get rescaled correctly

- HTML output
 - easy to scroll and click on links

### Issues
- html rendering requires bunch of custom flags and templates
- Autorun command launches the browser window every time (run command on write is on)
- Custom templates depend on google api website which slows down the launch time (for the first time only)
- Handling large md file with TableMode on is too laggy (need to manually turn it off)
- Folding for large files is slow (need to install fastfold plugin)
- Recompiles the whole page on each save, so progressively longer compile time
- Only single column pictures are available. No side-by-side.

### Compare workflow and ease with
- Jupyter
- vimtex


# Table borders in pandoc-converted html from markdown

When converting markdown files to html, the table borders do not show up. Add the following css snippet within the `.md` files so that

```
pandoc file.md -o file.html
```

actually renders a border in the tables:

```html
<style>
table { border-collapse: collapse; }
th, td { border: solid black 1px; padding: 0 1ex; }
tr:nth-of-type(odd) { background-color:#eee; }
th { color: white; background: #444; }
</style>
```

# Update Gemfile.lock of github website repository to the latest version
Instead of updating the version numbers by hand in `Gemfile.lock`, automatically generate the `Gemfile.lock` with the latest versions available (which is hopefully equal or even higher than the version number suggested by Github security vulnerability message), using
```
bundle lock --update
```
(You need `ruby-bundler` installed for this to work.)
Now check the generated `Gemfile.lock` to see if version number stated in security vulnerabilities section of your github repository matches the version number in `Gemfile.lock`. It should match or show even a higher (more latest) version number.

Another way to manually specify the version number is to add it to `Gemfile` file (not `.lock`) like this:
```
gem "kramdown", ">= 2.3.0"
```
and then update the lockfile using `bundle lock --update`.

