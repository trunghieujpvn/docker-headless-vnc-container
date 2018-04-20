#!/bin/bash
set -e

chown root:${BIND_USER} /run/named

chgrp ${BIND_USER} /etc/bind/rndc.key

if [ ! -e /etc/bind/named.conf ]; then
  echo missing named.conf extracting defaults
  cd /
  tar xzvf /etc/bind-defaults.tgz
fi

# allow arguments to be passed to named
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == named || ${1} == $(which named) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch named
if [[ -z ${1} ]]; then
  echo "Starting named..."
  exec $(which named) -u ${BIND_USER} -g ${EXTRA_ARGS}
else
  exec "$@"
fi
