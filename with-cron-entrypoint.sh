#!/bin/bash
set -e

service cron start

a2dismod mpm_event 2>/dev/null || true
a2dismod mpm_worker 2>/dev/null || true
a2dismod mpm_prefork 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true
apache2ctl configtest

exec /entrypoint.sh "$@"
