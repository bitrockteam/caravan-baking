#! /bin/bash

exec /usr/local/bin/consul agent -bind='{{ GetInterfaceIP \"'\$(ip route | grep '^default' | grep -Po '(?<=dev )(.+?)(?= )')'\" }}' -config-dir=/etc/consul.d/
