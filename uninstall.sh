#!/bin/bash
# ==============================================================================
# updateLITE · Fedora Edition - Desinstalador
# ==============================================================================
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

set -euo pipefail

# Colores
RED=$'\e[38;5;196m'
GREEN=$'\e[38;5;46m'
YELLOW=$'\e[38;5;226m'
BLUE=$'\e[38;5;39m'
CYAN=$'\e[38;5;45m'
RESET=$'\e[0m'
BOLD=$'\e[1m'

# Emojis
CHECK=$(printf "\xE2\x9C\x85")
CROSS=$(printf "\xE2\x9D\x8C")
TRASH=$(printf "\xF0\x9F\x97\x91\xEF\xB8\x8F")
FOLDER=$(printf "\xF0\x9F\x93\x81")
WARNING=$(printf "\xE2\x9A\xA0\xEF\xB8\x8F")

# Directorios de instalación
INSTALL_BIN="${HOME}/.local/bin"
INSTALL_LIB="${HOME}/.local/share/updatelite"
INSTALL_CONFIG="${HOME}/.config/updatelite"

echo
echo "${BLUE}${BOLD}================================================================================${RESET}"
echo "${BLUE}${BOLD}  ${TRASH} updateLITE · Fedora Edition - Desinstalador${RESET}"
echo "${BLUE}${BOLD}================================================================================${RESET}"
echo

# Confirmar desinstalación
echo "${YELLOW}${WARNING} Esta acción eliminará updateLITE de tu sistema${RESET}"
echo
read -p "¿Deseas continuar? [s/N] " -n 1 -r
echo

if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
    echo "${CYAN}Desinstalación cancelada${RESET}"
    exit 0
fi

echo

# Eliminar script principal
echo "${CYAN}${TRASH} Eliminando archivos...${RESET}"

if [[ -f "${INSTALL_BIN}/updatelite" ]]; then
    rm -f "${INSTALL_BIN}/updatelite"
    echo "   ${CHECK} Eliminado: ${INSTALL_BIN}/updatelite"
else
    echo "   ${YELLOW}⚠ No encontrado: ${INSTALL_BIN}/updatelite${RESET}"
fi

# Eliminar módulos
if [[ -d "${INSTALL_LIB}" ]]; then
    rm -rf "${INSTALL_LIB}"
    echo "   ${CHECK} Eliminado: ${INSTALL_LIB}/"
else
    echo "   ${YELLOW}⚠ No encontrado: ${INSTALL_LIB}/${RESET}"
fi

echo

# Preguntar sobre configuración
echo "${YELLOW}${WARNING} ¿Deseas eliminar también la configuración?${RESET}"
echo "   Directorio: ${INSTALL_CONFIG}"
read -p "   [s/N] " -n 1 -r
echo

if [[ $REPLY =~ ^[SsYy]$ ]]; then
    if [[ -d "${INSTALL_CONFIG}" ]]; then
        rm -rf "${INSTALL_CONFIG}"
        echo "   ${CHECK} Eliminado: ${INSTALL_CONFIG}/"
    else
        echo "   ${YELLOW}⚠ No encontrado: ${INSTALL_CONFIG}/${RESET}"
    fi
else
    echo "   ${CYAN}Configuración conservada${RESET}"
fi

echo
echo "${GREEN}${BOLD}================================================================================${RESET}"
echo "${GREEN}${BOLD}  ${CHECK} Desinstalación completada${RESET}"
echo "${GREEN}${BOLD}================================================================================${RESET}"
echo
echo "  updateLITE ha sido eliminado de tu sistema."
echo
echo "  Para reinstalar, ejecuta:"
echo "    ${CYAN}./install.sh${RESET}"
echo
