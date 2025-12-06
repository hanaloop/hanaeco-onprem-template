#!/bin/bash

# Script to back up a PostgreSQL database
USER="hanaeco_user"
DBNAME="hanaeco_db"
ORGNAME="hanaeco_org"
VERSION="1.8.0"
TIMESTAMP=$(date +%Y%m%d)
TARGET_DIR="../db-backups/"
FILENAME="${TARGET_DIR}hanaeco-v${VERSION}-${ORGNAME}-${TIMESTAMP}.sql"

START_TIME=$(date +%s)

pg_dump -h localhost -p 5432 -U "${USER}" -d "${DBNAME}" -Fc -b -v -f "${FILENAME}"

END_TIME=$(date +%s)
ELAPSED_SECONDS=$((END_TIME - START_TIME))

echo "Backup completed: ${FILENAME} (elapsed: ${ELAPSED_SECONDS}s)"
