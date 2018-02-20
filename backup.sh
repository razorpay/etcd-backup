#!/bin/bash

export BACKUP_FILE_NAME=etcd-backup-$(date +%Y-%m-%d-%H-%M).db
ETCD_CA_PATH=${ETCD_CA_PATH:-}
ETCD_CERT_PATH=${ETCD_CERT_PATH:-}
ETCD_KEY_PATH=${ETCD_KEY_PATH:-}
ETCD_ENDPOINTS=${ETCD_ENDPOINTS:-}
S3_BUCKET_NAME=${S3_BUCKET_NAME:-}
CLUSTER_NAME=${CLUSTER_NAME:-}

echo "Starting the backup"
export ETCDCTL_API=3
/tmp/etcd/etcdctl --endpoints=${ETCD_ENDPOINTS} \
                  --cacert=${ETCD_CA_PATH} --cert=${ETCD_CERT_PATH} \
                  --key=${ETCD_KEY_PATH} snapshot save /backup/${BACKUP_FILE_NAME}
aws s3api put-object --region ap-south-1 --bucket ${S3_BUCKET_NAME}\
                     --key ${CLUSTER_NAME}/etcd-backup/${BACKUP_FILE_NAME}\
                     --body /backup/${BACKUP_FILE_NAME}

echo "Backup completed"
