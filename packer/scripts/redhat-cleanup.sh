#!/bin/bash
set -e
sudo bash -c '{
# clean yum history
yum history new && \
yum -y clean all  && \
rm -rf /var/cache/yum && \
rm /var/lib/rpm/.*.lock && \
rpm --rebuilddb
}'
sudo bash -c '{
# clean up logs
truncate -c -s 0 /var/log/yum.log && \
find /var/log -type f -exec truncate -s 0 {} \; && \
rm -rf /var/log/anaconda* /var/lib/yum/* /var/lib/random-seed /root/install.log /root/install.log.syslog /root/anaconda-ks.cfg /etc/vault.d/watched
}'

sudo find / -name "authorized_keys" -exec rm -f {} \;
sudo truncate -s 0 /etc/machine-id
sudo truncate -s 0 /var/lib/dbus/machine-id