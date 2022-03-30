#!/bin/bash
set -e
sudo bash -c '{
# clean apt cache
apt clean 
}'
sudo bash -c '{
# clean up logs
cloud-init clean 
find /var/log -type f -exec truncate -s 0 {} \; && \
rm -rf /etc/vault.d/watched
}'
