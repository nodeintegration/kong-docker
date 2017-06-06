#!/usr/local/bin/dumb-init /bin/bash
set -e

# Make a pipe for the logs so we can ensure Kong logs get directed to docker logging
# see https://github.com/docker/docker/issues/6880
# also, https://github.com/docker/docker/issues/31106, https://github.com/docker/docker/issues/31243
# https://github.com/docker/docker/pull/16468, https://github.com/behance/docker-nginx/pull/51
rm -f /tmp/logpipe
mkfifo -m 666 /tmp/logpipe
# This child process will still receive signals as per https://github.com/Yelp/dumb-init#session-behavior
cat <> /tmp/logpipe 1>&2 &


if [ -n "${ADMIN_AUTH_PASSWORD}" ]; then
 echo "${ADMIN_AUTH_PASSWORD}" | openssl passwd -apr1 -stdin | sed -e 's/^/admin:/' > /etc/kong/kong.admin.htpasswd
else
 echo "admin" | openssl passwd -apr1 -stdin | sed -e 's/^/admin:/' > /etc/kong/kong.admin.htpasswd
fi

if [ -z "${$NGINX_SET_REAL_IP_FROM}" ]; then
  NGINX_SET_REAL_IP_FROM="10.0.0.0/8"
fi

sed -i -e "s/#NGINX_SET_REAL_IP_FROM#/${NGINX_SET_REAL_IP_FROM}/g"  /usr/local/share/lua/5.1/kong/templates/nginx_kong.lua

if [ -n "${NGINX_AUTH_SECTION}" ]; then
  sed -i -e "s/#NGINX_AUTH_SECTION#/${NGINX_AUTH_SECTION}/g"  /usr/local/share/lua/5.1/kong/templates/nginx_kong.lua
fi

# Disabling nginx daemon mode
export KONG_NGINX_DAEMON="off"

exec "$@"
