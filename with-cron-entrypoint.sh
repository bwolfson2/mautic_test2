#!/bin/bash
set -e

service cron start

# Fix Apache MPM before base entrypoint starts apache
/opt/fix-apache-mpm.sh || true

exec /entrypoint.sh "$@"