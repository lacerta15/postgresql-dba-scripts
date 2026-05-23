#!/bin/bash
# PostgreSQL full backup script
PGHOST="${PGHOST:-localhost}"
PGUSER="${PGUSER:-postgres}"
BACKUP_DIR="${BACKUP_DIR:-/backup/postgresql}"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR/$DATE"

for DB in $(psql -h "$PGHOST" -U "$PGUSER" -t -c "SELECT datname FROM pg_database WHERE datistemplate=false;"); do
    echo "[$(date)] Backing up $DB..."
    pg_dump -h "$PGHOST" -U "$PGUSER" -Fc "$DB" > "$BACKUP_DIR/$DATE/${DB}.dump"
    echo "[$(date)] Done: $DB"
done

# Cleanup backups older than 7 days
find "$BACKUP_DIR" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} +
echo "[$(date)] Backup complete. Location: $BACKUP_DIR/$DATE"
