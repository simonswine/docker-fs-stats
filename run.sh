#!/bin/bash

set -e

SLACK_CHANNEL=${SLACK_CHANNEL:-stats}
MOUNT_POINT=${MOUNT_POINT:-/mnt/persistent}

if [ -e "$SLACK_TOKEN" ]; then
    echo "please provide a slack token" >&2
    exit 1
fi

echo "$SLACK_TOKEN" > ~/.slackcat
SLACK="slackcat -s --tee -c ${SLACK_CHANNEL}"

{
    echo -n "Running disks stats on host $(hostname) in ${MOUNT_POINT}"

    findmnt ${MOUNT_POINT}
    df -h ${MOUNT_POINT}

    dd if=/dev/zero of=${MOUNT_POINT}/here bs=1G count=1 oflag=direct 2>&1


    mkdir -p ${MOUNT_POINT}/bonnie
    chmod 777 ${MOUNT_POINT}/bonnie
    bonnie++ -d ${MOUNT_POINT}/bonnie -n 4 -m $(hostname) -x 3 -b -u nobody

} | $SLACK
