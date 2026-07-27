#!/bin/sh

# Add to crontab -e: run everyday at 3:27 am
# 27 3 * * * ~/myconfigs/borg-setup.sh >> ~/immich-app/backup.log

# Paths
UPLOAD_LOCATION="$HOME/immich-app/library"
LOG="$HOME/immich-app/backup.log"

## local backup
# BACKUP_PATH="/mnt/hdd320/immich-borg"
# BACKUP_PATH_DB="/mnt/hdd320/immich-borg-db"

## Remote backup
BACKUP_PATH="precision:/mnt/hdd2tb/immich-borg"
BACKUP_PATH_DB="precision:/mnt/hdd2tb/immich-borg-db"

echo $(date)

# For remote path, this won't work, make sure di exists
mkdir "$BACKUP_PATH"
mkdir "$BACKUP_PATH_DB"

# run once
borg init --encryption=none "$BACKUP_PATH"
borg init --encryption=none "$BACKUP_PATH_DB"

### Local

### Append to local/remote Borg repository
borg create $BACKUP_PATH::{now} $UPLOAD_LOCATION --exclude $UPLOAD_LOCATION/thumbs/ --exclude $UPLOAD_LOCATION/encoded-video/ --progress >> "$LOG"
borg prune --keep-weekly=4 --keep-monthly=3 $BACKUP_PATH -v >> "$LOG"
borg compact $BACKUP_PATH -v >> "$LOG"


# Backup Immich database
LOCAL_DB_BACKUP=$HOME/immich-app/database-backup/immich-database.sql.gz
docker exec -t immich_postgres pg_dumpall -c -U postgres | /usr/bin/gzip > $LOCAL_DB_BACKUP
### Append DB to local/remote Borg repository
borg create $BACKUP_PATH_DB::{now} $LOCAL_DB_BACKUP --progress >> "$LOG"
borg prune --keep-weekly=4 --keep-monthly=3 $BACKUP_PATH_DB -v >> "$LOG"
borg compact $BACKUP_PATH_DB -v >> "$LOG"

