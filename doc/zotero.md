# Zotero

### Restore old setup 
**(use script `myconfigs/zotero_setup` instead)**
- Install
- Copy old profile `.zotero/zotero/<random_string>.default` (saved in google cloud directory `zotero`) into `$HOME`. This will have login and plugin information and settings, but not the database.
- Run `zotero` and **refuse** to `sync to empty database` 
- Disable `sci-hub`
- Go to `Zotfiles settings` and verify the custom location and subdirectory (`General Settings > Location of Files` as `Custom Location`, `Subfolder defined by` as `/%c/`)
- Sync
- Enable `sci-hub`
- Set zathura as **firefox** default pdf viewer to set the same for zotero

### Installation
* Install Zotero from source (the snap version does not follow system theme) by following the instruction.
[link](https://www.zotero.org/support/installation)

Alternatively, use [this guy's script](https://github.com/retorquere/zotero-deb) for latest version via `apt-get`:
```
wget -qO- https://github.com/retorquere/zotero-deb/releases/download/apt-get/install.sh | sudo bash
sudo apt update
sudo apt install zotero
```
* Install the firefox plugin.
- Download plugins: (right click and `save link as` to get the `.xpi` file instead of attempting to install on Firefox as a plugin). To install plugins, goto Zotero app `Tools > Addon > Gear Icon > Install from file`. Restart Zotero.
    * Download the  `Zotfile` plugin from [link](http://zotfile.com/)
    * [install after Zotfile setup and sync] Download `Better Bibtex` plugin from [link](https://github.com/retorquere/zotero-better-bibtex)
    * [install after Zotfile setup and sync] Download `scihub` plugin from [link](https://github.com/ethanwillis/zotero-scihub)


- After installing the scihub plugin, follow this [link](https://medium.com/@gagarine/use-sci-hub-with-zotero-as-a-fall-back-pdf-resolver-cf139eb2cea7)
and set your browser in `.bashrc` by adding
```
export BROWSER=/usr/bin/firefox
```
and `source ~/.bashrc`.


### Zotfile Settings

In `Tools > Zotfile preference`, set the following
* `Advanced Settings`: _uncheck_ Only work with the following filetypes. Therefore, renaming and moving attachments work for tex, xoj etc, including new unexpected filetypes as well.
* `Advanced Settings`: check remove special characters from filenames
* `General Settings`: Set `Location of Files` as `Custom Location` and select a new directory which will be backed up using gdrive. Add `Subfolder defined by` as `/%c/` to add the `collection` name as the subdirectory.
- `Renaming rules:` Set `Format for all item Types except Patents` to `{%a} ({%y}) {%t}`. Also, `Delimiter between multiple authors` to `-`. Set `Number of authors to display when authors are omitted` to `2`.

### Setup syncing (Edit > Preferences > Sync)
* Set up syncing and turn off attachment syncing (uncheck `Sync attachment files in My Library using` and  `Sync attachment files in group libraries using Zotero Storage`. This way, the database is synced by Zotero and the pdf files (attachments) are backed up by drive.

- Click on the green sync button on top right to sync
- While using Zotfiles and a custom location for the pdf files, the path for the files in a new setup has to be the same (I think the original custom path is saved on the cloud). A path mismatch will throw a `not found` error.

### In Better Bibtex settings (Edit>Preferences>Better):
* Add vim support by adding the following to `.vimrc`

```
function! ZoteroCite()
  " pick a format based on the filetype (customize at will)
  let format = &filetype =~ '.*tex' ? 'cite' : 'pandoc'
  let api_call = 'http://127.0.0.1:23119/better-bibtex/cayw?format='.format.'&brackets=1'
  let ref = system('curl -s '.shellescape(api_call))
  return ref
endfunction

noremap <leader>z "=ZoteroCite()<CR>p
inoremap <C-z> <C-r>=ZoteroCite()<CR>
```

* In `Edit > Preferences` > `Better Bibtex` > `Citation Keys`, set an easy format like (see Documentation for more formats):
```
[authEtAl][veryshorttitle1:capitalize][shortyear]
```
   - Upto two authors - Lastnames, capitalized
   - More than 3 authors - first author last name, capitalized, followed by `EtAl`
   - First significant word of the title (ignore `a`, `the` etc), capitalize
   - Last two digits of the year



## **Caution:** 
* Items without a parent do not get moved or renamed, so make sure to create one for unrecognized files
* Items do not get automatically copied to the new location until you select them and click `rename attachments`
* Moving items to another collection can be done by holding the shift key while dragging with the mouse
* Auto syncing is done within a few seconds of change to the database.
* Files in the _Unfiled items_ category are placed in the base directory, instead of in the collection directories. Edit or move them.

## Navigation
- Ctrl-F to search
- Select and item and hold down `Alt` key to highlight the collection it belongs to
- Select collection pane with `Ctrl-Shift-L`
- [ ] no way to focus on the main pane (with the attachments etc)


## Cleanup

### Removing missing attachments with `zotero-storage-scanner` plugin

- Storage Scanner creates tags for broken attachments and duplicate attachments.
-  Selecting `#broken_attachments` filters items that have broken attachments.
- Selecting *1* of those broken attachments, then selecting ctrl+a appears to select all the broken attachments, which you can then delete by pressing `delete`

### Detecting and removing orphan attachments
Sometimes, files are added to the disk but are not linked with attachments. To detect those
- Set a new location to store files in zotifiles preferences
- select all files and `rename attachements`
- This way, all linked attachments will be moved to a new location. Unlinked files remain in the old location.
- Delete old unlinked files (or save them elsewhere to link later), and revert the storage directory back in zotfile preferences and `rename attachments` again.

## Other practices

- Merge duplicates
- Don't keep a file in more than one collection (to avoid having to select a location while renaming attachments via zotfiles). Use tags to mark files instead
- Rename attachments often
- Back up papers to gdrive often

```
cd ~/gdrive
drive push paper-org
```

- Back up Zotero configs occasionally

```
cd ~/.zotero
tar czvf zotero-conf.tar.gz zotero/
mv zotero-conf.tar.gz ~/gdrive/zotero/
cd ~/gdrive
drive push zotero
```

- Copy configs and `drive pull paper-org` into new computers before syncing

- Use patched xournal for compatibility with xoj files (or xournalpp)
- Use sci-hub to populate empty references


## Scenario:

* Move files to `~/Zotero` directory while renaming them
 1. Add files using Linked directory
 1. Zotfile preference: Location of files is `Attached Stored copy of file(s)`
 1. Select all files, and Rename

* You want to keep the directory structure of your pdf file, just batch rename them
 1. Add files using Linked directory
 1. Zotfile preference: `Location of Files` is `Custom Location`, possibly add `Subfolder defined by` as `%c/` to add the `collection` name as the subdirectory
 1. Select all files, and Rename
Now, you can keep backing up the custom location using gdrive etc.
Caution: original files are deleted (i.e. moved, not copied)

* You want to add citations to you tex file as you type and generate the .bib file automatically afterwards
 1. While typing in the tex file in vim, press `<leader>z` in normal mode or `Ctrl-Z` in insert mode to launch the Zotero search window
 1. Type search terms, select the citation, hit enter to insert strings like `\cite{AuthorEtAlTitle05}`
 1. After the tex file is generated with incomplete citations, go to Zotero, `Tools` > `Scan bibtex Aux file`
 1. Supply the `.aux` file that is generated from the `.tex` file. Set a tag name when asked.
 1. On the bottom-left part of Zotero, type and select the tag name you set, select all, right click, export as `Better Bibtex`. 
 1. This will create a `.bib` file with all citations extracted from the `.aux` file. Add it to `.tex` file in `\bibliography{}` with appropriate `\bibliographystyle{}`.
 Hint: Right click on the tag to rename, delete, or assign a color to it.

* Move all files to a new location, with a new directory structure, renaming them
 1. Select the location you want the files to go in `Zotfile Preferences > Location of Files`. For new installation of Zotero, you need to supply `Linked Attachment Base Directory` as the directory used by Zotfiles.



