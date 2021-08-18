#!/bin/bash -x

set -e

SCRIPT_NAME=backup-mongodb
ARCHIVE_NAME=mongodump_$(date +%Y%m%d_%H%M%S).gz
OPLOG_FLAG=""


if [ -n "$MONGODB_OPLOG" ]; then
	OPLOG_FLAG="--oplog"
fi
echo "password is $MONGODB_ROOT_PASSWORD"
echo "[$SCRIPT_NAME] Dumping all MongoDB databases to compressed archive..."


mongodump $OPLOG_FLAG \
	--archive="$ARCHIVE_NAME" \
	--gzip \
	
	--authenticationDatabase="$MONGODB_AUTH_DB"
	--user="$MONGODB_USER"
	--password="$MONGODB_ROOT_PASSWORD"
	--host="$MONGODB_HOST"


echo "[$SCRIPT_NAME] Uploading compressed archive to S3 bucket..."
aws s3 cp "$ARCHIVE_NAME" "$BUCKET_URI"

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "$ARCHIVE_NAME"

echo "[$SCRIPT_NAME] Backup complete!"
