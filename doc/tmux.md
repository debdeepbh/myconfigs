# tmux help

- `Ctrl-b` as the default `prefix`
- `Ctrl-b :source-file .tmux.conf` to reload the new config file (Caution: if there are instances of tmux running `tmux -ls`, opening a new tmux won't automatically load the new config, you have to source the config file)

## tmux copy-paste
The main issue is copying over ssh from a remote server to the local client.
1. where should the copied text live? `xclip` does not work in remote server since Xserver hasn't necessarily started.
1. how to retrieve server's `xclip` information from the client's `xclip`?

- Setting `copy-mode-vi y 'xclip -in selection'` 
- No Xserver (no DISPLAY) for ssh sessions, so `xclip` does not work to copy text.

### Using mouse selection for copy-paste from tmux over SSH 
- For non-vim terminal text, use mouse to copy with `C-S-c` and paste locally with `C-S-v`
- For vim sessions, hold down the `shift` key to make selection within vim then `C-S-c` to copy and `C-S-v` to paste
- For windowed tmux, fullscreen the window before copying to avoid vertical dividing line of tmux

The drawback for using mouse is that it cannot copy more than a page of text. Moreover, it picks up the vim line number and vertical tmux window borders.

### Using a clipboard file over SSH 
- To run `xclip` command over ssh in the local computer running Xserver
```
ssh localhost export DISPLAY=:0; echo 'test text' | xclip -in -selection clipboard
```
- dump desired clipboard string into a file in the server
- retrieve the file and copy the content into the local clipboard
- delete the remote and local copy of the file for security, periodically

Drawback: need to run retrieval command each time, an extra step.
	
### Between tmux windows:
- `C-b [ V`  to  select text, `Enter` to copy and go to normal mode
- `C-b ]` to paste it in another tmux window

Drawback: cannot copy more than a page, picks up vim line numbers

