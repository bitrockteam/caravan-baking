#! /bin/bash

INTERFACE=$(ip route | grep '^default' | grep -Po '(?<=dev )(.+?)(?= )')
exec /usr/local/bin/consul agent -bind="{{ GetInterfaceIP '$INTERFACE' }}" -config-dir=/etc/consul.d/
