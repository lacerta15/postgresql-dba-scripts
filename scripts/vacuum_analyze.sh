#!/bin/bash
# Run VACUUM ANALYZE on all databases
PGUSER="${PGUSER:-postgres}"
for DB in $(psql -U "$PGUSER" -t -c "SELECT datname FROM pg_database WHERE datistemplate=false;"); do
    echo "VACUUM ANALYZE on $DB..."
    psql -U "$PGUSER" -d "$DB" -c "VACUUM ANALYZE;"
done
