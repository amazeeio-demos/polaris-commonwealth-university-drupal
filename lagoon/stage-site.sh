#!/bin/bash
set -e

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting site staging process..."

# 1. Assume running in /app
cd /app
log "Changed directory to /app"

# 2. Load up the database file
log "Importing database from /app/lagoon/db-image.sql.gz..."
db_start=$(date +%s)
zcat /app/lagoon/db-image.sql.gz | $(drush sql:connect)
db_end=$(date +%s)
db_duration=$((db_end - db_start))
log "Database import complete. Duration: ${db_duration}s"

# 3. Ensure /app/web/sites/default/files exists
log "Ensuring /app/web/sites/default/files exists..."
mkdir -p /app/web/sites/default/files

# 4. cd to /app/web/sites/default/files
cd /app/web/sites/default/files
log "Changed directory to /app/web/sites/default/files"

# 5. run "tar -zxvf files_backup.tar.gz"
log "Extracting files from /app/lagoon/files_backup.tar.gz..."
files_start=$(date +%s)
tar -zxf /app/lagoon/files_backup.tar.gz
files_end=$(date +%s)
files_duration=$((files_end - files_start))
log "File extraction complete. Duration: ${files_duration}s"

log "Site staging process finished successfully."
log "----------------------------------------"
log "Summary:"
log "Database Import: ${db_duration}s"
log "Files Extraction: ${files_duration}s"
log "----------------------------------------"
