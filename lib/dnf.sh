#!/usr/bin/env bash
#
# dnf.sh - DNF5 update module
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

# Transaction ID before update (to detect new transactions)
declare -g DNF_TID_BEFORE=""

# Check for dnf database lock
check_dnf_lock() {
    if [[ -f /var/cache/dnf/lock ]]; then
        echo -e "${RED}  ✗ DNF database is locked${RESET}"
        echo -e "${YELLOW}    Another package manager might be running${RESET}"
        return 1
    fi
    return 0
}

# Update system packages via DNF5
update_dnf() {
    if [[ "$ENABLE_DNF" != "true" ]]; then
        return 0
    fi

    show_section "DNF - System Packages" "${BLUE}" "📦"

    # Save transaction ID BEFORE update
    DNF_TID_BEFORE=$(sudo dnf5 history list 2>/dev/null | head -2 | tail -1 | awk '{print $1}' || true)

    echo -e "${BLUE}  → Syncing and updating...${RESET}"
    echo ""

    # Execute dnf5 with real-time output
    local dnf_exit
    sudo dnf5 upgrade -y --refresh
    dnf_exit=$?

    echo ""
    if [[ $dnf_exit -eq 0 ]]; then
        echo -e "${GREEN}  ✓ DNF update completed${RESET}"
    else
        echo -e "${RED}  ✗ DNF error. Continuing...${RESET}"
        echo -e "${YELLOW}    Suggestion: sudo dnf5 distro-sync${RESET}"
    fi

    # Capture updated/installed packages from dnf history (only if new transaction)
    _capture_dnf_packages

    end_section
}

# Capture packages from last dnf transaction (only if it's a NEW transaction)
_capture_dnf_packages() {
    # Get current last transaction ID
    local last_tid
    last_tid=$(sudo dnf5 history list 2>/dev/null | head -2 | tail -1 | awk '{print $1}' || true)

    # If no transaction ID or same as before, no new packages were installed
    if [[ -z "$last_tid" ]] || ! [[ "$last_tid" =~ ^[0-9]+$ ]]; then
        return 0
    fi

    # CRITICAL: Only process if there's a NEW transaction (ID changed)
    if [[ "$last_tid" == "$DNF_TID_BEFORE" ]]; then
        # No new transaction - DNF didn't install/upgrade anything
        return 0
    fi

    # Get transaction info for the NEW transaction
    local trans_info
    trans_info=$(sudo dnf5 history info "$last_tid" 2>/dev/null || true)

    if [[ -z "$trans_info" ]]; then
        return 0
    fi

    # Parse upgraded packages
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]+Upgrade[[:space:]]+ ]]; then
            local pkg_name version_info
            pkg_name=$(echo "$line" | awk '{print $2}' || true)
            version_info=$(echo "$line" | awk '{$1=$2=""; print $0}' | xargs 2>/dev/null || true)
            [[ -n "$pkg_name" ]] && DNF_PACKAGES+=("${pkg_name}|${version_info}|upgraded")
        elif [[ "$line" =~ ^[[:space:]]+Install[[:space:]]+ ]]; then
            local pkg_name version_info
            pkg_name=$(echo "$line" | awk '{print $2}' || true)
            version_info=$(echo "$line" | awk '{$1=$2=""; print $0}' | xargs 2>/dev/null || true)
            [[ -n "$pkg_name" ]] && DNF_PACKAGES+=("${pkg_name}|${version_info}|installed")
        fi
    done <<< "$trans_info"

    UPDATES_DNF=${#DNF_PACKAGES[@]}
    return 0
}
