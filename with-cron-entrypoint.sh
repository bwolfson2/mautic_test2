#!/bin/bash
set -e

service cron start

exec /entrypoint.sh "$@"
