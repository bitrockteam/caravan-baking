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
find /root/.*history /home/*/.*history -exec rm -f {} \;
find / -name "authorized_keys" –exec rm –f {} \;
}'

sudo truncate -s 0 /etc/machine-id
sudo truncate -s 0 /var/lib/dbus/machine-id