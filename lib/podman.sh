#!/usr/bin/env bash
# podman.sh - Podman container module (matches original visual style)

# Update Podman containers
update_podman() {
    if [[ "$ENABLE_PODMAN" != "true" ]]; then
        return 0
    fi

    if ! has_command podman; then
        return 0
    fi

    show_section "PODMAN - Containers" "${BLUE}" "🐋"

    # Check if there are running containers
    local running_containers
    running_containers=$(podman ps -q 2>/dev/null | wc -l || echo 0)

    if [[ $running_containers -eq 0 ]]; then
        echo -e "${YELLOW}  ℹ️  No active containers${RESET}"
        end_section
        return 0
    fi

    echo -e "${BLUE}  → Checking ${running_containers} container(s) for updates...${RESET}"
    echo ""

    # List running containers with their images
    local containers
    containers=$(podman ps --format "{{.Names}}|{{.Image}}" 2>/dev/null || true)

    if [[ -n "$containers" ]]; then
        echo -e "${CYAN}  Active containers:${RESET}"
        while IFS='|' read -r name image; do
            echo "    • $name ($image)"
        done <<< "$containers"
        echo ""
    fi

    # Pull latest images for running containers
    echo -e "${BLUE}  → Pulling latest images...${RESET}"
    local images
    images=$(podman ps --format "{{.Image}}" 2>/dev/null | sort -u || true)

    local updated=0
    while IFS= read -r image; do
        [[ -z "$image" ]] && continue
        if podman pull "$image" 2>/dev/null | grep -q "Pulling\|Writing"; then
            ((updated++)) || true
            echo -e "${GREEN}    ✓ $image${RESET}"
        else
            echo -e "${DIM}    - $image (up to date)${RESET}"
        fi
    done <<< "$images"

    echo ""
    if [[ $updated -gt 0 ]]; then
        echo -e "${GREEN}  ✓ $updated image(s) updated${RESET}"
        echo -e "${YELLOW}  ℹ️  Restart containers to apply updates${RESET}"
        UPDATES_PODMAN=$updated
    else
        echo -e "${GREEN}  ✓ All container images up to date${RESET}"
    fi

    end_section
}

# Clean unused Podman resources
clean_podman() {
    if ! has_command podman; then
        return 0
    fi

    echo -e "${YELLOW}  → Cleaning Podman resources...${RESET}"

    local before_images after_images cleaned
    before_images=$(podman images -q 2>/dev/null | wc -l || echo 0)

    podman system prune -f >/dev/null 2>&1 || true

    after_images=$(podman images -q 2>/dev/null | wc -l || echo 0)
    cleaned=$((before_images - after_images))
    [[ $cleaned -lt 0 ]] && cleaned=0

    if [[ $cleaned -gt 0 ]]; then
        echo -e "${GREEN}    ✓ Removed $cleaned unused image(s)${RESET}"
    else
        echo -e "${GREEN}    ✓ No unused resources${RESET}"
    fi
    echo ""
}
