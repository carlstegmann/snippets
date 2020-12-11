#!/bin/sh

# this can be used to sync files from the s3 bucket into the the correct folders in case you use multiple docker container on the same host
# you will need s3cmd and the folder for your docker volumes

DOCKER_VOLUMES=<MY-PATH-TO-THE-FOLDER-I-LIKE-TO-USE-FOR-DOCKER-VOLUMES>

echo "syncing cert-data"
/usr/local/bin/s3cmd --config=/home/gvmd/.s3cfg sync s3://gvm-sync/gvm/cert-data/ ${DOCKER_VOLUMES}/gvm/cert-data/
echo "syncing cert-data done."

echo "syncing data-objects"
/usr/local/bin/s3cmd --config=/home/gvmd/.s3cfg sync s3://gvm-sync/gvm/data-objects/ ${DOCKER_VOLUMES}/gvm/data-objects/
echo "syncing data-objects done."

echo "syncing scap data"
/usr/local/bin/s3cmd --config=/home/gvmd/.s3cfg sync s3://gvm-sync/gvm/scap-data/ ${DOCKER_VOLUMES}/gvm/scap-data/
echo "syncing scap-data done."

echo "syncing openvas nvts"
/usr/local/bin/s3cmd --config=/home/gvmd/.s3cfg sync s3://gvm-sync/openvas/plugins/ ${DOCKER_VOLUMES}/openvas/plugins/
echo "syncing openvas nvts done."
