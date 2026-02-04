#!/usr/bin/env bash
# copr.sh - COPR repository info module (matches original visual style)
# Note: COPR packages are updated via DNF, this module shows active repos

# Show COPR repository information
update_copr() {
    if [[ "$ENABLE_COPR" != "true" ]]; then
        return 0
    fi

    # Check if any COPR repos are enabled
    local copr_repos
    copr_repos=$(dnf5 copr list --enabled 2>/dev/null || dnf copr list 2>/dev/null || true)

    if [[ -z "$copr_repos" ]]; then
        return 0
    fi

    show_section "COPR - Community Repositories" "${MAGENTA}" "📦"

    echo -e "${MAGENTA}  → Active COPR repositories:${RESET}"
    echo ""

    local count=0
    while IFS= read -r repo; do
        [[ -z "$repo" ]] && continue
        echo "    • $repo"
        ((count++)) || true
    done <<< "$copr_repos"

    echo ""
    echo -e "${DIM}  ℹ️  COPR packages are updated via DNF${RESET}"
    echo -e "${GREEN}  ✓ $count COPR repo(s) active${RESET}"

    UPDATES_COPR=$count

    end_section
}

# List packages from COPR repos
list_copr_packages() {
    # List packages that come from COPR repos
    local copr_pkgs
    copr_pkgs=$(dnf5 repoquery --installed --qf '%{name} (%{from_repo})' 2>/dev/null | grep -i copr || true)

    if [[ -n "$copr_pkgs" ]]; then
        echo "$copr_pkgs"
    fi
}
