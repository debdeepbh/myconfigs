# Papis

## Install on Ubuntu 24.04

```
git clone https://github.com/papis/papis.git
cd papis
pipx install . 
```

From pip

```
pip3 install --user papis whoosh papis-schihub
```

## [Older] Install


- (Doesn't work) Install from source
```
sudo apt-get install libxml2-dev libxslt1-dev
#git clone https://github.com/alejandrogallo/papis.git # bad link
git clone https://github.com/papis/papis.git
cd papis
python3 setup.py install --user
```
Uninstall with `make uninstall` from the directory or

```
python3 setup.py install --user --record files.txt 
xargs rm -rf < files.txt
```

(Still doesn't work) Install older python version which provides the latest packages (weird)
Get `python3.8.6`
[link](https://hackersandslackers.com/multiple-versions-python-ubuntu/)
and 
[link](https://linuxconfig.org/how-to-change-from-default-to-alternative-python-version-on-debian-linux)
* Install the dependency
```
sudo apt-get install python3-setuptools
```
* As user (create default directory `$HOME/Documents/papers` to avoid errors on first run)
```
pip3 install --user papis
```
- For bash completion add to `.bashrc`
```
# for local installation with --user
export PATH="$PATH:$HOME/.local/bin"
# for bash completion
source $HOME/.local/etc/bash_completion.d/papis.sh
```

## Config

- View the config file `~/.config/papis/config` to find (or change) the default paper location

```
dir = ~/Documents/papers
pip3 install --user papis
```

- Create the directory (otherwise you get error while running)

```
mkdir ~/Documents/papers
```

- For papis-vim (follow instructions)

```
pip3 install whoosh
```

- If using `whoosh` as a database backend,

```
database-backend = whoosh
```

now open papis with (or add `default-query-string = title:*` to the config)

```
papis open '*'
```

- Clear papis cache with

```
papis --clear-d 
```

which clears the directory `~/.cache/papis`.

Do this often when rebuilding the library, while testing, etc.

## Usage

- Use query language for searching like this

```
papis open `author:einstein publisher:review Principia` 
```

All specified options are joined with `AND` for default database type.
With `whoosh` database, we can use `OR` (and other whoosh query language strings)

```
papis open '(author:einstein AND year:1905) OR title:einstein'
```

- Use `project` YAML field for papers

- Exporting all references from a project to bibtex

```
papis export --all --format bibtex project:pterodactyl-migration > bibliography.bib
```

- Add files to existing paper (selected by a search string) with `addto`
```
papis addto 'einstein photon definition' -f a.pdf -f b.pdf
```

- Update a .bib file after changing some YAML info: [see](https://papis.readthedocs.io/en/latest/commands.html#module-papis.commands.bibtex)

## Moving from Zotero

- Generate a bibtex from zotero (without exporting files). File paths will be extracted from bib files, even when zotfiles is in use.

- Import in papis using

[didn't work]

```
papis bibtex read ./path/to/my/bibfile.bib import -o test
```

- Import using zotero-compatible command:
	- specify and output folder for testing purposes (so that you don't contaminate the existing papis data)
	- **Main issue with path:** the command below reads the file paths from the bib file and understands in the **relative** sense to the bib file. Therefore, one needs to modify the paths (vim search and replace) within the bib file to make paths relative to the bib file.

```
papis zotero import --from-bibtex bibfile_modified.bib --outfolder test_dir
```

## To make papis as functional as Zotero, it needs to be able to 

- [ ] (add `--from pdf2doi` before filename that works sometimes ) extract metadata from supplied pdf
- [ ] (currently broken) sci-hub auto download
- [ ] (papis-vim)  should be able to generate .bib from .aux files
- [x] (from zotero-exported bibtex file, but filenames with special characters are ignored) bulk add multiple files (or convert Zotero database to this)
- [x] tag papers for projects
- [x] (manually using gdrive) sync the database
- [x] (use `addto` or edit with C-e to manually add file) store attachments, mainly .xoj files
- [x] (warns when adding) remove duplicates
- [x] (creates unique(?) citation key in `ref` field) should have unique citation keys 
- [x] (can set default filename pattern in config) meaningful filename of pdf

## Current Bugs 
- [ ] (add `--from pdf2doi` before filename that works sometimes) Cannot `papis add <filename>.pdf` when there is a white space in `<filename>`
- [ ] cannot add pdf file if `add-folder-name` is specified to be something non-default
- [ ] (add `--from pdf2doi` before filename that works sometimes) Cannot extract doi info from local pdf
[ ] Sci-hub script does not work

- [x] (compiles with latest git after `pip3 uninstall papis` and `make uninstall` from `papis` repos) Cannot compile from github even after installing `libxml2` and more. There some talk of version 0.12 (which possibly fixed some of the issues) but where is it?

