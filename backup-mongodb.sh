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
echo "oplog-flag = $OPLOG_FLAG"


mongodump $OPLOG_FLAG \
	--archive "$ARCHIVE_NAME" \
	--gzip \
	--host "$MONGODB_HOST"
	--authenticationDatabase "$MONGODB_AUTH_DB"
	-u $MONGODB_USER
	-p "$MONGODB_ROOT_PASSWORD"
	
# mongodump --oplog \
# --archive="$ARCHIVE_NAME" \
#  --gzip \
#  --host "mongodb-0.mongodb-headless.mongodb.svc.cluster.local:27017,mongodb-1.mongodb-headless.mongodb.svc.cluster.local:27017,mongodb-2.mongodb-headless.mongodb.svc.cluster.local:27017" \
#  --authenticationDatabase admin \
#  -u root \
#  -p "moonswitch"


echo "[$SCRIPT_NAME] Uploading compressed archive to S3 bucket..."
aws s3 cp "$ARCHIVE_NAME" "$BUCKET_URI"

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "$ARCHIVE_NAME"

echo "[$SCRIPT_NAME] Backup complete!"
