#!/usr/bin/env bash
set -euo pipefail

# Disable all MPMs first (ignore failures)
a2dismod mpm_event 2>/dev/null || true
a2dismod mpm_worker 2>/dev/null || true
a2dismod mpm_prefork 2>/dev/null || true

# Enable exactly one (prefork is the safest for mod_php images)
a2enmod mpm_prefork 2>/dev/null || true

# Safety: remove any stray LoadModule lines if they exist (rare, but fixes stubborn images)
# This only affects enabled module files; harmless if patterns don't exist.
sed -i '/LoadModule mpm_event_module/d' /etc/apache2/mods-enabled/*.load 2>/dev/null || true
sed -i '/LoadModule mpm_worker_module/d' /etc/apache2/mods-enabled/*.load 2>/dev/null || true

# Validate
apache2ctl -M | grep -E 'mpm_' || true
apache2ctl configtest
