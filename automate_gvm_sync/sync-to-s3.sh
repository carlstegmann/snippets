#!/bin/sh
# this will sync the local rsynced files from the community feed server into your private bucket (in this case gvm-sync, feel free to name it as you like)
/usr/local/bin/s3cmd --config=/home/gvmd/.s3cfg sync /home/gvmd/gvm-sync/ s3://gvm-sync/
