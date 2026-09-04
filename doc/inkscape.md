# Inkscape workflow

To integrate Inkscape plots into the latex/markdown writing workflow, we need to streamline frequently used actions.

- Saving the plot: Ctrl+S opens the `save as` dialog box, which could be avoided if we open existing files, in which case it will save to the same filename and extension without asking. The idea would be to keep a `template.svg` file and copy it to the current file name, open and edit it, and save it. A simple bash script could do it (see `$HOME/.myscr/drawfig`).

If needed, conversion to other formats such as `latex+pdf` or `png` can be done later (after saving) using command line arguments with `inkscape`.

- Selecting Bezier curve with `B`
- Selection `S` and Node mode `N`
- To trim the margins of the figure and reduce it to a bounding box of existing curves, do
	- Ctrl+A to select all
	- Ctrl+Shift+R to resize page to selection
This can also be done using  (see `man inkscape`) after saving using a script:

```
inkscape --export-filename=filename.png --export-area-drawing filename.svg
```


- Select a curve and press `Ctrl+Shift+F` to go the Stroke and Fill tab.

- Insert latex symbols by pressing a shortcut key `t` instead of clicking `Extensions > Render > Formula (pdflatex)`. The shortcuts can be set in `Edit > Preferences > Interface > Keyboard > Shortcuts` and setting the shortcut. Once set, the shortcut config can be saved for later from

```
$HOME/.config/inkscape/keys/default.xml
```


