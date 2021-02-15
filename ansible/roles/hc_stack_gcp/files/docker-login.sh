#! /bin/bash

exec /usr/bin/docker login -u oauth2accesstoken -p $(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token"  -H "Metadata-Flavor: Google" | grep -Po '(?<="access_token":")([^"]*)') https://us.gcr.io
