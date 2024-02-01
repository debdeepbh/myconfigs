#!/bin/sh

# Add to crontab -e: run everyday at 3:27 am
# 27 3 * * * ~/myconfigs/borg-setup.sh >> ~/immich-app/backup.log

# Paths
UPLOAD_LOCATION="$HOME/immich-app/library"
BACKUP_PATH="/media/debdeep/hdd320/immich-borg"

echo $(date)

mkdir "$BACKUP_PATH"

# REMOTE_HOST="remote_host@IP"
# REMOTE_BACKUP_PATH="/path/to/remote/backup/directory"

# run once
borg init --encryption=none "$BACKUP_PATH"

### Local

# Backup Immich database
docker exec -t immich_postgres pg_dumpall -c -U postgres | /usr/bin/gzip > $HOME/tmp-immich-db.sql.gz

### Append to local Borg repository
borg create $BACKUP_PATH::{now} $UPLOAD_LOCATION --exclude $UPLOAD_LOCATION/thumbs/ --exclude $UPLOAD_LOCATION/encoded-video/ --progress >>
borg prune --keep-weekly=4 --keep-monthly=3 $BACKUP_PATH -v
borg compact $BACKUP_PATH -v


# ### Append to remote Borg repository
# borg create $REMOTE_HOST:$REMOTE_BACKUP_PATH/immich-borg::{now} $UPLOAD_LOCATION --exclude $UPLOAD_LOCATION/thumbs/ --exclude $UPLOAD_LOCATION/encoded-video/
# borg prune --keep-weekly=4 --keep-monthly=3 $REMOTE_HOST:$REMOTE_BACKUP_PATH/immich-borg
# borg compact $REMOTE_HOST:$REMOTE_BACKUP_PATH/immich-borg
