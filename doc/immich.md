# Local image server immich.app


## Installation

Follow the beautifully written tutorial

- The default docker.io installation (`sudo apt install docker.io`) will not work. Need to follow described method to download it from docker website. Then we need to run docker using

```
systemctl start docker
```

- The `.env` file should not have any prefix (first name). It is just `.env`.

- Need to use sudo for compose up

```
sudo docker compose up -d
```

- Better to set up with filename template engine on for easy organization. The original files will be stored in `./library/library/<user>/`


## File structure

- Add backed up files are stored in

## Testing

- Can delete all backed up photos and delete the database with `docker copmose down -v` (see the [Administration](https://immich.app/docs/administration/backup-and-restore/)  for details)

```
docker compose down -v  # CAUTION! Deletes all Immich data to start from scratch.
```

## Extra work

### Security

- Default password for the server is written in plaintext within the config file. Must change it from default before running the docker image.

- https for app: need to use a reverse proxy like nginx or caddy (described in the guide)

#### tailscale guide

Tailscale allows you to create a network of your personal devices who can 'see' each other even though they are in completely different networks. It also provides a static DNS name, so we don't need to use additional dynamic dns service providers. This also gives you free https over the internet for your http server.

- After creating and account, run tailscale on your personal devices. In particular on the device where the server is running.

- Make the server available to other personal devices within your tailscale network using

```
sudo tailscale serve --bg 2283
```

- One can `serve` multiple servers running on different ports using names like this

```
sudo tailscale serve --set-path /immich --bg 2283
sudo tailscale serve --set-path /jupyter --bg 8888
```

This sets the tailscale ip (or the landing hostname) of the device into the server itself. e.g. from a tailscale-connected device, visit the immich server directly using `https://hostname.network-name.ts.net`.


- Check status of your server using 

```
tailscale serve status
```

or

```
tailscale funnel status
```

- Turn the server off using

```
sudo tailscale serve reset
```

or 

```
sudo tailscale funnel reset
```

- To make the servers created this way publicly available (not necessary since it defeats the purpose of a private image server) using `funnel` as opposed to `serve`.


### Dynamic DNS

- They recommend duckdns

### Backup

Borg script is provided for local and remote (via ssh) backup.

- Install borg with

```
sudo apt install borgbackup
```

- Like a git repository, initiate a borg repository with

```
borg init --encryption=none <backup_dir>
```

- Create the backup using

```

borg create --stats --progress <backup_dir>::{now} immich-app/library/ --exclude=immich-app/library/thumbs/ --exclude immich-app/library/encoded-video/
```

The stats will show the statistics after compression is done. The progress bar is good for large backups.

- Need to prune the trees and compact to reduce size of multiple backups

```
borg prune --keep-weekly=4 --keep-monthly=3 <backup_dir>
borg compact <backup_dir>
```

### Bulk upload

immich-go does not work very well as it makes many of the uploaded file corrupted (but downloading and uploading them fixes them). Therefore, we will use: https://github.com/TheLastGimbus/GooglePhotosTakeoutHelper/tree/master?tab=readme-ov-file
Download the script from the github, and run it on extracted takeout zips. This creates a flattened list of images which we can upload using bulk-upload script.

