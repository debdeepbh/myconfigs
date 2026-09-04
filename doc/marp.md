# MARP for presentation slides using markdown

Various tips:
[link](https://www.hashbangcode.com/article/seven-tips-getting-most-out-marp)

## Installation
* ~~Using npm~~ (didn't work)
* ~~Install from ubuntu snap repo~~ (the executable filename is weird)
```
sudo snap install marp-cli-carroarmato0
```
* Download the binary from the release page on github, extract the tar to get a _single_ binary file `marp`. Launch it with `./marp`.

## Workflow
* Create `slides.md` file with proper headers.
* Convert to html using `./marp slide.md`. This creates `slides.html`
* Open html in browser `firefox slides.html`
* Keep editing and see changes in real time using
```
./marp slide.md --watch
```
* Alternatively, use the native previewer using
```
./marp --watch --preview
```

## Usage
* Itemized lists are defined using `-`, whereas `*` produces next slide as we go (i.e. requires you to go to the next slide before showing the next item)
* Sublists need two preceding spaces
* Highlight text with ticks `text`, which can also be used to embed code
- Comment with `<!-- comment -->` which can span over multiple lines.


## Tex support

Marp uses KaTeX for rendering latex. Here are the supported functions.
https://katex.org/docs/supported.html

You can specify which math engine to use in the header

```
---
theme: gaia
math: mathjax
---
```

With mathjax, we can also specify preludes of tex files in the beginning of the page. For examples, if you add

```
$$
% User defined functions
\newcommand{\F}{\mathcal{F}}
\newcommand{\E}{\mathcal{E}}
\newcommand{\R}{\mathbb{R}}
$$
```

early on in the page, you can keep using `\R` to denote real numbers throughout the page.

## Changing settings for the current slide only
* Use underscored directives at the top of the current slide. For example, to temporarily change the background to a gradient color, do
```
<!-- _backgroundImage: "linear-gradient(to bottom, #67b8e3, #0288d1)" -->
```
* Skipping the underscore will cause the setting to apply all the subsequent slides. That is how you set global settings.

## Changing font size

To change the font size of the current slide, paste the following within the current slide:

```
<style scoped>
section {
  font-size: 30px;
}
</style>
```


## Embedding videos

* Embed video with html tag as usual

* Use `--html` option to parse html tags written in the `.md` file. For example, embed a video using the following html tag with size, autoplay and on loop like this:
```
 <video width="320" height="240" controls autoplay loop> <source src="data/pacman_fracture.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video> 
```
and do
```
./marp slide.md --html --watch --preview
```
* (requires `--html` option) Finally, to align the videos to the left, enclose them in a `<div> </div>` tag with left orientation like this:
```
<div style="float:left;margin-right:20px;">

 <video width="320" height="240" controls autoplay loop>
  <source src="data/pacman_fracture.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video> 

</div>
### Slide title
```

*  To get a long column, set a large `margin-bottom` to the `div` tag like this:
```
<div style="float:left;margin-right:30px;margin-bottom:300px;">
...
</div>
### Slide title
```

This (with all margin set to 0px) also creates a nice box within a bunch of text, and the text moves out of the way.

* To push the video to the right-edge of the screen (with no extra margin on the right), use negative margin value like this:
```
<div style="float:right;margin-right:-70px;margin-top:100px;margin-left:40px;margin-bottom:300px;">
...
</div>
### Slide title
```

* A good example that works on the default settings:
```
<div style="float:right;margin-right:-70px;margin-top:-70px;margin-left:10px;margin-bottom:300px;">
 <video height="720" controls autoplay loop>
  <source src="data/damping_w_friction.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video> 
</div>

### Simulation: damping with friction
Text goes here
```

## Adding vertical space
Use html tag with line break `<br>`. Use as many as needed.

## Adding horizontal space
Use html characters:
```
Regular space: &nbsp;
Two spaces gap: &ensp;
Four spaces gap: &emsp;
```

## Multiple images next to each other
List them in the same line, i.e, without any line break like this:
```
![h:300](data/nonconvex-demo.png) ![h:300](data/nonconvex-demo-ring.png) ![h:300](data/nonconvex-demo-rplus.png)
```
Specify height and width to fit things in the page.

## Align contents using tables
```
Solarized dark             |  Solarized Ocean
:-------------------------:|:-------------------------:
![](https://...Dark.png)  |  ![](https://...Ocean.png)
```

## marp columns

To have columns within a slide, use scoped style called `.columns`. Here is an example of a slide with two columns, with the right column an image with subtitle.

```

---
<style scoped>
    .columns {
    display: grid;
    grid-template-columns: 60% 40%;
    gap: 1rem;
}
</style>

# Multi columns in Marp slide

<div class="columns">
<div>

## Column 1

Column 1 text goes here

</div>
<div>

## Column 2

Column 2 text goes here
![img h:300](data/domain.png)
<center><font size="12">Centered text<font></center>

Text

</div>
</div>

This text is outside the columns.

---

```


## Repeated css styles

To avoid retyping detailed scoped styles (`<style scoped> ... </style>`) every time, you can give the style a name and reuse it using `<p class='stylename'> .. </p>`. 
Define the name of the style at the beginning globally like this:

```

---
marp: true
theme: gaia
style: |
  .subtext {
    font-size: 0.75rem;
    text-align: center;
  }
---

---
# Big text here

<p class="subtext">small text</p>

---

```

Note: in CSS, `rem` is root element.

## New theme files

Instead of defining new style names within `style: |` in the header, you can put custom themes in a new css file (you need to call with `marp --theme newthemefile.css` for it to load) based on the existing theme `gaia`.

The body of `newthemefile.css`

```
/* @theme theme-new */

@import 'gaia';

h1 {
  font-size: 60px;
  color: #09c;
}

.cols {
    display: grid;
    grid-template-columns: 60% 30%;
    gap: 1rem;
}

.subtext {
    font-size: 0.75rem;
    text-align: center;
}
```

In the body of `slided.md` use the style (and modify options on the fly) as

```

--- 
theme: theme-new
---
..
---
# Title
<div class="cols", style="grid-template-columns="50% 50%;">
	<div>
	col 1	
	</div>

	<div>
	col 2	
	</div>
</div>

<p class="subtext"> subtitle </p>
---
```

Compile with

```
./marp slides.md --html --watch --preview --theme newtheme.css
```

