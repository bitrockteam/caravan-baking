#!/bin/bash
set -e
sudo ls -la /etc/consul.d/ && \
sudo systemctl start consul &&  \
sleep 10s && \
systemctl status consul
