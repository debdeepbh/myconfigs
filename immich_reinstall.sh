#!/bin/bash
#######################################################################
# Re-installing immich server after it is broken

cd ~/immich-app


# database backup location
backup="$HOME/today-dump.sql.gz"
# backup database
docker exec -t immich_postgres pg_dumpall -c -U postgres | gzip > "$backup"

# Remove the existing docker
docker compose down -v	# this deletes docker, but keeps the library with all images

# Get the latest configs
wget  https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env
wget https://github.com/immich-app/immich/releases/latest/download/hwaccel.ml.yml

# # older version
# wget https://github.com/immich-app/immich/releases/download/v1.94.1/docker-compose.yml
# wget -O .env https://github.com/immich-app/immich/releases/download/v1.94.1/example.env
# wget https://github.com/immich-app/immich/releases/download/v1.94.1/hwaccel.ml.yml

# Change the database password
echo 'Change the database password'
vim .env

# Create docker with new config files
docker compose pull     # Update to latest version of Immich (if desired)
docker compose create   # Create Docker containers for Immich apps without running them.
docker start immich_postgres    # Start Postgres server
sleep 10    # Wait for Postgres server to start up

# restore backed up database 
gunzip < "$backup" | docker exec -i immich_postgres psql -U postgres -d immich    # Restore Backup

# run the new docker
docker compose up -d    # Start remainder of Immich apps
