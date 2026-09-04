# Git tutorial

## Removing a large file from the commit history
```
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch path/to/file.jpg' \
  --prune-empty --tag-name-filter cat -- --all
```
Then do
```
git push origin --force --all
```
to delete the same in the remote repo.

* If it is a directory, use `rm -r ...` instead of `rm`.


## Create a respository
 Created account in github. Created a repository called `testconfigs` under the username 
`<username>`.

### SSH access to github

* Generated public ssh key by: `ssh-keygen`
No passphrase, no name (this is important because we won't be adding this public key using `ssh-add`). Since this has the default name, the program accepts it by some accident. This needs a fix.
* Then follow this to run ssh-add:
```
 eval `ssh-agent -s`
```
 (Here, these are two backticks, not apostrophes). Then run:
```
 ssh-add
 cat ~/.ssh/id_rsa.pub
```
* Copy this output of `id_rsa.pub` and paste it in the website's ssh-key field after logging in.
 
* Then check that you have ssh access to github using: 
```
ssh -T git@github.com
```
(Caution: _not_ your username or id, but the username `git`)
This is most probably a routine check that you have the access. This does not give you a remote tty or you do not need to stay logged in to perform git tasks. You can probably skip this step.

* Next, update your name and email address in the config using
```
git config --global user.email "email@domain.com"
git config --global user.name "Name"
```

- To copy own ssh public key into another server's `.ssh/authorized_keys` so that you can login without password, do
```
 .ssh/id_rsa.pub | ssh user@server 'cat >> .ssh/authorized_keys'
```

- To avoid writing the full `user@server` address, add a nickname in your `.ssh/config` like this:
```
Host nickname
  User debdeep
  HostName serve.server.address
```

### To push/pull git repository without password
Change the url origin type of your repository to an ssh-based one using:
```
git remote set-url origin git@github.com:<username>/<repository_name>.git
```

### Back to creating a repository
 Create some empty directory as your repository, which will be your working directory. Then run: `git init`
 This will create a `.git` file in the directory.
 Now add the address of the remote host, which we are naming `gitty`
```
 git remote add gitty git@github.com:<username>/testconfig
```
 
 The repository `testconfigs` will be referred to as `gitty`.
 
 You can see all the remote hosts by: `git remote -v`
 If needed, you can delete a remote host by : `git remote rm nickname_of_host`
 
 Now download all the files from the master branch  of `gitty` by: `git pull gitty master`
 Now your working  directory  will have all the files stored in `gitty`. You can modify them, add more files etc. After modification, add the files to the modification list using:
```
 git add file1
 git add file2
 git add file3
```
 etc.
 
 After they are added to the _changelist_, it is the time to commit to the change and add a comment about the changes:
```
 git commit -m "Added file1, file2, changed file3"
```
 
 After committing, it is time to upload the change back to the place by:
```
 git push gitty master
```
 (Obviously we are uploading to the master branch here)
 (Here, for the first time you may be asked to enter your email id and username. Follow the instruction to add these info to the file `~/.gitconfig`)
 
 And we are done.


## Maintaining the local repo:
 Create a new repository in the website. Copy the clone address. Locally do
```
	 git clone https://github.com/username/reponame
```
 Now you have a local repo.
```
         cd reponame
```
 Add files/make changes e.g. `cp path/file .`
 Add to the git list : `git add file`
```
 git commit -m 'message'
 git push
```
 Provide username and password for your git repo.
 If you don't want to enter username/passwd repeatedly, add a remote repo:
```
  git remote add petname git@github.com:username/reponame
```
 Next, push to the repo called `petname` like this
```
  git push petname
```
 Then you won't be asked for credentials anymore. And by default it will get pushed to the master branch .
 
## Adding and committing only the files that are in the git ls-files list:
```
 git commit -am "Staging and committing all the modifications done to files in git ls-files"
```
 
 Alternatively, `get commit -a -m text"` works.

## Merging branches
If we want to merge the branch `remote_branch` to the branch `local_branch` (the terms `remote` and `local` are well-defined in that sense), we do the following.

* Create a branch
```
git branch local_branch
```
* Checkout to the (`local`) branch using
```
git checkout local_branch
```
* Merge the other branch (`remote`) to the current one (`local`)
```
git merge remote_branch
```
Note: you may get 'branch does not exist' error, in that case, `checkout` to the remote branch first and then get back to the local one.

* Merge conflicts will arise which can be resolved with launching a diffing tool with
```
git mergetool
```

- Delete the remote branch
```
git branch -d remote_branch
```

- Delete the remote branch on origin (remote)

```
git push -d origin remote_branch
```


### Replacing _all_ files without resolving conflicts

* **See below for alternative** ~~ To replace all the local files with the remote files, do 
```
git merge --strategy-option theirs
```
* To keep local files and discard the remote files while merging do
```
git merge --strategy-option ours
```
~~

**Caution:** Better alternative is to go through `git mergetool` and open it with `vimdiff` and then
 - Make the remote branch the final version with `:%diffget RE`
 - Make the local  branch the final version with `:%diffget LO`

## Using `vimdiff` as a mergetool:
* **Caution:** Quit unfinished merging work with `:cquit` (or `:cq`, to exit with an error code) so that next time `git mergetool` will launch `vimdiff` again. Otherwise, the file is all messed up with strings like `HEADER >>>>>>` and is saved as a real file and `mergetool` does not do anything.

If you quit `vimdiff` midway and would like to reset the merge again, 
 1. first cancel the merge
```
git reset --merge
```
 2. and perform the merge again with
```
git merge remote_branch
```
 3. fix merge conflicts
```
git mergetool
```
or with 
```
git mergetool tool=vimdiff
```
if it not not configured.

- Resize vimdiff window after maximizing using `Ctrl+w =`

* There are 3 windows on top:
	left: local: the file from the branch we are current staying, i.e. the local branch
	right: remote: the file from the branch from which we are merging, the remote branch
	middle: base: a common ancestor of both local and remote from which both of the files were originated and diverted

Bottom window: final version of the merged file in the local branch, after merging

* We navigate in the bottom file (using `[c` and `]c`), changing lines if needed. To add changes from the remote version (i.e. from branch `remote_branch`), do `:diffget RE`
Alternatively, `BA` or `LO` for base or local.
* To apply the same change to the _whole_ file:
 - Make the final version of the file same as the remote copy with `:%diffget RE`:
 - Make the final version of the file same as the local copy with `:%diffget LO`
* If the lines get misaligned, do `:diffupdate`

* After merging is done, save the final version (Bottom window) of the file and quit.
* Git `.orig` files using `git clean -fd` 
- Might need to add the file again using `git add filename` (check if this is needed with `git status`)
* Commit the current branch with `git commit -m 'merged remote_branch with local_branch'`
* Delete the branch that is merged with the current (local) branch using
```
git branch -d remote_branch
```
**Caution:** attempting to delete the remote branch without committing the merged local branch first will throw warning sign. That would be a reminder that the current needs to to committed.
 
## Scenarios

* **Pull from the internet and discard your local changes:**
```
git reset --hard
git clean -f
git pull
```
Here, `clean -f` to remove untracked files. `clean -fd` deletes untracked directories as well. Before `clean -f`, we can do `clean -d` to see which files are to be removed.

* Pull from the internet and set aside the local (uncommited) changes:
```
git stash
git pull
```
Then to pop back the local uncommitted changes on top of that using
```
git stash pop
```
To delete the stash, do `git stash drop` instead.

* **Desired Method**: Pull from the internet and put the current __committed__ changes as next commit after the remote version
[(nice explanation for the reason to rebase)](https://megakemp.com/2019/03/20/the-case-for-pull-rebase/)
```
git pull --rebase
```
(or just `git pull -r`)

This might need merge-conflict resolution 
```
git mergetool --tool=vimdiff
```
and cleanup 
```
git clean -df
```
Then, to indicate that rebasing is done, we do
```
git rebase --continute
```
followed by `git push` to push the final local change. (Note that  `git commit` is not required and has been done automatically)

This creates a commit history of the order `last remote commit, merged local commit`.

This (`--rebase`) is better for history and creates 2 commit histories compared to just `git pull` (with default `--merge` behavior), which creates 3 commit histories in the order `last remove commit, last local commit, merged commit`.

To recover from a failed `rebase` and revert to the state before the attempted `pull` (i.e. local changes remain in local directory), do
```
git rebase --abort
```

**Note**: `git pull --rebase` should be used over just `git pull` where we do not want to advertise that a merging has been done, e.g. when working on the same branch. This is the most common scenario.


* See the difference between file in two different branches
```
git diff branch_1 branch_2 -- filename.txt
```
The output will have the following:
  * Common lines are in white
  * Lines in branch_1 (and not in branch_2) are in red (and with `-`)
  * Lines in branch_2 (and not in branch_1) are in green (and with `+`)
To use `vimdiff`, replace `git diff` with `git difftool`.

* To change a conflicted file (with conflict markers) into the state of its last commit, do `git restore filename`

* See the commit history _of the current branch_
```
git log
```
or with ` git log -p ` to see all the changes (patches) to files. Other useful options are `--pretty=oneline` or `stat`.

* Delete `.orig` files (record of merging) after merging is done using
```
 git clean -fd
```
* Maintain  empty directories in your repository by creating `.gitkeep` file (conventional name)
```
touch empty_dir/.gitkeep
```
and tell to `.gitignore` to not ignore it using
```
# Inside .gitignore
empty_dir/*
!empty_dir/.gitkeep
```

## Rebasing (basing the current commit on) seems irrelevant and confusing to mess with history
`git rebase` linearizes two diverging branch heads. If we have a diverging branch `exp` of the `main` branch, we can do
```
git checkout exp
git rebase main
```
to make the changes of `exp` as a next commit to the ones in `main`. At this point, the last commit of `main` becomes a previous commit for `exp`. So, we can just merge `exp` to `main` using
```
git checkout main
git merge exp
```

**Q**: How to change files with conflict markers to its state before attempted merge?
```
git merge --abort
```
Note, for uncommitted files, this might revert the files back to last committed state.

## Removing sensitive information from github repo

[Main article](https://docs.github.com/en/github/authenticating-to-github/removing-sensitive-data-from-a-repository)

* To change the email address of all previous commits
```
git filter-branch -f --commit-filter '
      if [ "$GIT_AUTHOR_EMAIL" = "OLD_EMAIL" ];
      then
              GIT_AUTHOR_EMAIL="NEW_EMAIL";
              git commit-tree "$@";
      else
              git commit-tree "$@";
      fi' HEAD
```
Then, force push the repo with
```
git push --force
```
 
 
# Reverting a file or directory to its previous state in git (Or, restoring deleted files :P)
 
 First, stop any automated git commits by commenting out the necessary lines in crontab -e, or something else.
 Next, find out the right commit you want the file to be reverted to using
  git log filename
 Here, you should note down the commit number. Let's say it is abcdef
 Now, get it back using
  git checkout abcdef filename
 
 Done. Now git commit to make this change permanent. Resume your crontab based auto-commit.
 
