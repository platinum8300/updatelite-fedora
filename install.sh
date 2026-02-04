#!/bin/bash
# ==============================================================================
# updateLITE · Fedora Edition - Instalador
# ==============================================================================

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
ROCKET=$(printf "\xF0\x9F\x9A\x80")
PACKAGE=$(printf "\xF0\x9F\x93\xA6")
FOLDER=$(printf "\xF0\x9F\x93\x81")
GEAR=$(printf "\xE2\x9A\x99\xEF\xB8\x8F")
PARTY=$(printf "\xF0\x9F\x8E\x89")

# Directorios de instalación
INSTALL_BIN="${HOME}/.local/bin"
INSTALL_LIB="${HOME}/.local/share/updatelite/lib"
INSTALL_CONFIG="${HOME}/.config/updatelite"

# Directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "${BLUE}${BOLD}================================================================================${RESET}"
echo "${BLUE}${BOLD}  ${ROCKET} updateLITE · Fedora Edition - Instalador${RESET}"
echo "${BLUE}${BOLD}================================================================================${RESET}"
echo

# Verificar Bash 4.0+
echo "${CYAN}${PACKAGE} Verificando requisitos...${RESET}"

if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
    echo "${RED}${CROSS} Error: Se requiere Bash 4.0 o superior${RESET}"
    echo "   Versión actual: $BASH_VERSION"
    exit 1
fi
echo "   ${CHECK} Bash ${BASH_VERSION}"

# Verificar Fedora
if [[ ! -f /etc/fedora-release ]]; then
    echo "${RED}${CROSS} Error: Este script está diseñado para Fedora Linux${RESET}"
    exit 1
fi
FEDORA_VERSION=$(cat /etc/fedora-release)
echo "   ${CHECK} ${FEDORA_VERSION}"

# Verificar DNF5
if ! command -v dnf5 &>/dev/null; then
    echo "${RED}${CROSS} Error: dnf5 no está instalado${RESET}"
    echo "   Instálalo con: sudo dnf install dnf5"
    exit 1
fi
echo "   ${CHECK} dnf5 disponible"

# Verificar sudo
if ! command -v sudo &>/dev/null; then
    echo "${RED}${CROSS} Error: sudo no está disponible${RESET}"
    exit 1
fi
echo "   ${CHECK} sudo disponible"

echo

# Crear directorios
echo "${CYAN}${FOLDER} Creando directorios de instalación...${RESET}"

mkdir -p "$INSTALL_BIN"
echo "   ${CHECK} ${INSTALL_BIN}"

mkdir -p "$INSTALL_LIB"
echo "   ${CHECK} ${INSTALL_LIB}"

mkdir -p "$INSTALL_CONFIG"
echo "   ${CHECK} ${INSTALL_CONFIG}"

echo

# Copiar archivos
echo "${CYAN}${PACKAGE} Instalando archivos...${RESET}"

# Copiar script principal
cp "${SCRIPT_DIR}/updatelite" "${INSTALL_BIN}/updatelite"
chmod +x "${INSTALL_BIN}/updatelite"
echo "   ${CHECK} updatelite → ${INSTALL_BIN}/"

# Copiar módulos
for module in "${SCRIPT_DIR}"/lib/*.sh; do
    if [[ -f "$module" ]]; then
        cp "$module" "${INSTALL_LIB}/"
        echo "   ${CHECK} $(basename "$module") → ${INSTALL_LIB}/"
    fi
done

# Crear configuración si no existe
if [[ ! -f "${INSTALL_CONFIG}/config" ]]; then
    if [[ -f "${SCRIPT_DIR}/config/updatelite.conf.example" ]]; then
        cp "${SCRIPT_DIR}/config/updatelite.conf.example" "${INSTALL_CONFIG}/config"
        echo "   ${CHECK} config → ${INSTALL_CONFIG}/"
    fi
fi

echo

# Verificar PATH
echo "${CYAN}${GEAR} Verificando PATH...${RESET}"

if [[ ":$PATH:" != *":${INSTALL_BIN}:"* ]]; then
    echo "   ${YELLOW}⚠ ${INSTALL_BIN} no está en PATH${RESET}"
    echo
    echo "   Añade esta línea a tu ~/.bashrc o ~/.zshrc:"
    echo "   ${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
    echo
else
    echo "   ${CHECK} PATH configurado correctamente"
fi

echo

# Verificar instalación
echo "${CYAN}${ROCKET} Verificando instalación...${RESET}"

if [[ -x "${INSTALL_BIN}/updatelite" ]]; then
    echo "   ${CHECK} updatelite instalado correctamente"

    # Mostrar versión
    VERSION=$("${INSTALL_BIN}/updatelite" --version 2>/dev/null || echo "v1.0.0")
    echo "   ${CHECK} Versión: ${VERSION}"
else
    echo "${RED}${CROSS} Error durante la instalación${RESET}"
    exit 1
fi

echo
echo "${GREEN}${BOLD}================================================================================${RESET}"
echo "${GREEN}${BOLD}  ${PARTY} Instalación completada exitosamente ${PARTY}${RESET}"
echo "${GREEN}${BOLD}================================================================================${RESET}"
echo
echo "  Uso:"
echo "    ${CYAN}updatelite${RESET}           Ejecutar actualización completa"
echo "    ${CYAN}updatelite --check${RESET}   Verificar sin aplicar cambios"
echo "    ${CYAN}updatelite --help${RESET}    Mostrar ayuda"
echo
echo "  Configuración: ${CYAN}${INSTALL_CONFIG}/config${RESET}"
echo
