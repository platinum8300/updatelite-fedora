# ==============================================================================
# updateLITE · Fedora Edition - Zsh Integration
# ==============================================================================
#
# Añade esta línea a tu ~/.zshrc:
#   source ~/.local/share/updatelite/shell-integration/updatelite.zsh
#
# ==============================================================================

# Completado de argumentos para updatelite
_updatelite() {
    local -a opts
    opts=(
        '--help[Mostrar ayuda]::'
        '-h[Mostrar ayuda]::'
        '--version[Mostrar versión]::'
        '-v[Mostrar versión]::'
        '--check[Verificar sin aplicar cambios (dry-run)]::'
        '-c[Verificar sin aplicar cambios (dry-run)]::'
    )
    _arguments $opts
}

compdef _updatelite updatelite

# Alias útiles
alias ul='updatelite'
alias ulc='updatelite --check'
alias ulh='updatelite --help'
