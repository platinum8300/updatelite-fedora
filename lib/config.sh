#!/usr/bin/env bash
#
# config.sh - Configuration loading and defaults
#
# Copyright (C) 2026 platinum8300
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# Default configuration values
declare -g ENABLE_DNF="${ENABLE_DNF:-true}"
declare -g ENABLE_COPR="${ENABLE_COPR:-true}"
declare -g ENABLE_FLATPAK="${ENABLE_FLATPAK:-true}"
declare -g ENABLE_FIRMWARE="${ENABLE_FIRMWARE:-true}"
declare -g ENABLE_PODMAN="${ENABLE_PODMAN:-false}"

declare -g CLEANUP_ORPHANS="${CLEANUP_ORPHANS:-true}"
declare -g CLEANUP_CACHE="${CLEANUP_CACHE:-true}"
declare -g CLEANUP_JOURNAL="${CLEANUP_JOURNAL:-true}"
declare -g JOURNAL_VACUUM_DAYS="${JOURNAL_VACUUM_DAYS:-7}"

declare -g ENABLE_LOGGING="${ENABLE_LOGGING:-false}"
declare -g LOG_DIR="${LOG_DIR:-$HOME/logs/updatelite}"

declare -g ENABLE_PHRASES="${ENABLE_PHRASES:-true}"
declare -g ENABLE_COLORS="${ENABLE_COLORS:-true}"

declare -g CRITICAL_PACKAGES="${CRITICAL_PACKAGES:-kernel systemd glibc dracut grub2 mesa fwupd}"

# Config file location
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/updatelite"
CONFIG_FILE="$CONFIG_DIR/config"

# Load configuration from file (safe parsing, no eval/source)
load_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        return 0
    fi

    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue

        # Remove leading/trailing whitespace
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        # Remove quotes from value
        value="${value#\"}"
        value="${value%\"}"
        value="${value#\'}"
        value="${value%\'}"

        # Only set known configuration keys
        case "$key" in
            ENABLE_DNF|ENABLE_COPR|ENABLE_FLATPAK|ENABLE_FIRMWARE|ENABLE_PODMAN|\
            CLEANUP_ORPHANS|CLEANUP_CACHE|CLEANUP_JOURNAL|JOURNAL_VACUUM_DAYS|\
            ENABLE_LOGGING|LOG_DIR|\
            ENABLE_PHRASES|ENABLE_COLORS|\
            CRITICAL_PACKAGES)
                declare -g "$key=$value"
                ;;
        esac
    done < "$CONFIG_FILE"
}

# Create default config if it doesn't exist
create_default_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        return 0
    fi

    mkdir -p "$CONFIG_DIR"

    cat > "$CONFIG_FILE" << 'CONFIGEOF'
# updateLITE Fedora Edition - configuration
# Location: ~/.config/updatelite/config

# Modules (true/false)
ENABLE_DNF=true
ENABLE_COPR=true
ENABLE_FLATPAK=true
ENABLE_FIRMWARE=true
ENABLE_PODMAN=false

# Cleanup options
CLEANUP_ORPHANS=true
CLEANUP_CACHE=true
CLEANUP_JOURNAL=true
JOURNAL_VACUUM_DAYS=7

# Logging
ENABLE_LOGGING=false
LOG_DIR=$HOME/logs/updatelite

# Interface
ENABLE_PHRASES=true
ENABLE_COLORS=true

# Critical packages that require reboot (space-separated)
CRITICAL_PACKAGES=kernel systemd glibc dracut grub2 mesa fwupd
CONFIGEOF

    echo "Created default config at $CONFIG_FILE"
}

# Detect distribution
detect_distro() {
    echo "fedora"
}

# Detect kernel variant
detect_kernel() {
    uname -r
}
