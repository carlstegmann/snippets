#!/usr/bin/env bash
# "Updating OpenVas Feeds"
greenbone-nvt-sync --rsync
greenbone-scapdata-sync
greenbone-certdata-sync
exit 0
