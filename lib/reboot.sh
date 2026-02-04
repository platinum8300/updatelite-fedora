#!/usr/bin/env bash
# reboot.sh - Reboot detection module (matches original visual style)

# Check if reboot is required based on updated critical packages
check_reboot_required() {
    # Get system boot time as Unix timestamp
    local boot_time
    boot_time=$(date -d "$(uptime -s)" +%s 2>/dev/null || echo 0)

    # Get critical packages list
    local critical_pkgs
    IFS=' ' read -ra critical_pkgs <<< "$CRITICAL_PACKAGES"

    local needs_reboot=false
    local reboot_packages=()

    # Check kernel mismatch (running kernel vs installed kernel)
    local running_kernel
    running_kernel=$(uname -r)

    local installed_kernel
    installed_kernel=$(rpm -q kernel --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n' 2>/dev/null | sort -V | tail -1)

    if [[ -n "$installed_kernel" ]]; then
        # Extract version for comparison
        local running_ver="${running_kernel%%[-_]*}"
        local pkg_ver="${installed_kernel%%-*}"

        if [[ "$running_ver" != "$pkg_ver" ]]; then
            needs_reboot=true
            reboot_packages+=("kernel (running: $running_kernel, installed: $installed_kernel)")
        fi
    fi

    # Check if needs-restarting is available (from dnf-utils)
    if has_command needs-restarting; then
        if ! needs-restarting -r &>/dev/null 2>&1; then
            needs_reboot=true
            if [[ ! " ${reboot_packages[*]} " =~ "kernel" ]]; then
                reboot_packages+=("Core system libraries updated")
            fi
        fi
    fi

    # Show reboot notice or confirmation
    if [[ "$needs_reboot" == "true" ]]; then
        echo ""
        echo -e "${BOLD}${YELLOW}╔════════════════════════════════════════════════════════ ${RESET}"
        echo -e "${BOLD}${YELLOW}║            ⚠️  REBOOT RECOMMENDED ⚠️                    ${RESET}"
        echo -e "${BOLD}${YELLOW}╚════════════════════════════════════════════════════════ ${RESET}"
        echo ""

        if [[ ${#reboot_packages[@]} -gt 0 ]]; then
            echo -e "${CYAN}  Critical packages updated:${RESET}"
            for pkg in "${reboot_packages[@]}"; do
                echo -e "    ${YELLOW}→${RESET} $pkg"
            done
        fi

        echo ""
        echo -e "${DIM}  A system reboot is recommended to apply all changes.${RESET}"
    else
        echo ""
        echo -e "${GREEN}  ✓ No reboot required${RESET}"
    fi
}
