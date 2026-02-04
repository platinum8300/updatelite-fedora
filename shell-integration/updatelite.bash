# ==============================================================================
# updateLITE · Fedora Edition - Bash Integration
# ==============================================================================
#
# Añade esta línea a tu ~/.bashrc:
#   source ~/.local/share/updatelite/shell-integration/updatelite.bash
#
# ==============================================================================

# Completado de argumentos para updatelite
_updatelite_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="--help --version --check -h -v -c"

    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}

complete -F _updatelite_completions updatelite

# Alias útiles
alias ul='updatelite'
alias ulc='updatelite --check'
alias ulh='updatelite --help'
