# Protonvpn for ubuntu

After installing the `.deb` package the website specifies, the following command does not work

```
sudo apt install protonvpn
```

with error `protonvpn: could not locate`.

The issue is the repository list file did not get copied to `/etc/apt/sources.list.d/`. 
Simply extract the `.deb` file with tar `tar -xvf protonvpn....deb` and copy the file `./etc/apt/sources.list.d/protonvpn-stable.list` to `/etc/apt/sources.list.d/`. 

Then do `sudo apt update`. Now can find and install the package.

## No internet due to ip leak protection

Turn off the service using

```
sudo nmcli connection delete pvpn-ipv6leak-protection
```

