#!/usr/bin/env bash

for role in ansible/roles/*;
do
  pushd "${role}" || exit
  molecule destroy
  popd || exit
done
