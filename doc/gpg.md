# Setting up linux password management system with pass and gnupg

* Install using `sudo apt-get install pass`
* Password stores are associated with GPG keys stored in the system. 
* Initiate a password store using 
```
pass init KEY_ID
```

Here, `KEY_ID` is the 8-digit GPG key, or name, or email address associated with a GPG entry.

Now, an empty `~/.password-store` is generated.

* You need to create a gpg key (along with a passphrase) beforehand using 
```
gpg --gen-key
```
 - In this process, you need to supply a name and an email address. You will then be asked to specify a secret password or passphrase to protect the private key generated in this process. See [Diceware](Dicewarehttps://theworld.com/~reinhold/diceware.html) method as an example of a memorable passphrase generation method.

All generated files are saved in `~/.gnupg` directory.

 - You can see all keys in your system using 
all public keys using `gpg --list-keys` and all private keys using `gpg --list-secret-keys`. Note that private keys have public keys in them.
The hexadecimal code associated `pub` is the identifier `KEY_ID` that can be provided to `pass`. Alternatively, you can specify the `name` or the email address as the `KEY_ID` while using `pass init`

The privatekey-passphrase pair is secret and needs to be protected. Losing the private key means you won't be able to decrypt anything, including the stored passwords. The private key (which already contained the public part) can be exported to a file using
```
gpg --export-secret-keys KEY_ID > secret_keyfile
```
This produces a binary (unreadble) file. To export into human-readable ascii file, include `-a`:
```
gpg --export-secret-keys -a KEY_ID > secret_keyfile
```

The output file `secret_keyfile` should be stored safely and can be imported to a new computer using
```
gpg --import secret_keyfile
```
Both importing and exporting methods will involve you recalling the _secret_ passphrase, which was used to generate the gpg key.

Note that with the `secret_keyfile` alone (i.e. without passphrase), the private key cannot be installed into a new computer and hence encrypted files cannot be decrypted.

As long as you have access to `secret_keyfile` and the passphrase is memorized, the existing private key can be deleted. This can be done for example using `gpg --delete-secret-key KEY_ID` (which deletes the private key only, to delete the public part as well, do `--delete-key` again)  or by simply deleting the directory `~/.gnupg`. 

* After importing a secret key from another source, you need to `trust` the key to use it in your `pass` like this:

```
gpg --edit-key KEY_ID
gpg> trust
```
Select `5 = I trust ultimately`. Exit with Ctrl+D or `gpg> save` to exit.

After that, commands like `pass insert` should work.

* `pass` requires the gpg key (private key) to encrypt the passwords.
* If you want to re-encrypt the passwords with another gpg key, you can run
```
pass init NEW_KEY_ID
```
CAUTION: You need to have BOTH  the old key `KEY_ID` and  the new key `NEW_KEY_ID` present in your `~/.gnupg`.


Back to `pass`:
* See your list of passwords using `pass`
* Insert a new password to you store using `pass insert Category_C/Site_A`
* See the stored password using `pass Category_C/Site_A`
* Copy the password to the clipboard for 45 seconds using `pass -c Category_C/Site_A`

* Make your password store a git repository using
```
pass git init
pass git remote add origin github.com:a-pass-store
```
After this step, every call to `pass` also initiates a `git commit` for the changes made to the password files. 

Note: all usual git commands can follow after `pass`. For example, `pass git push -u --all`
* For firefox extension:
Install the 'host app' using
```
curl -sSL github.com/passff/passff-host/releases/latest/download/install_host_app.sh | bash -s -- firefox
```
Install the plugin from 
https://addons.mozilla.org/en-US/firefox/addon/passff/

* For Android, use the `Password Store` app by Harsh Shandilya

* [Read](https://michael.kjorling.se/computers/passwords#need-remember)

More:
* The expiry date on the gpg key does not affect the ability to decrypt. The expiry date can be extended by editing the key using
```
gpg --edit-key KEY_ID
gpg> passwd
```
and then Ctrl+D or `gpg> save`.
* The passphrase can be updated using `gpg> passwd` and then `gpg> save`. Changing passphrase does not affect the decryption process of already-encrypted files.

Storing:
- `pass`-encrypted passwords can be stored in **private** github repositories
- Storing private key: writing down (printing out) a modified version on paper
- No storing passphrases, but remembering them. A good output is
```
diceware -d - -n 5 -w en
```
to use smaller words from source `en`. 
Better alternative: `xkcdpass`
Pictures based on the words are easy to remember. Update every 6 months or so.


