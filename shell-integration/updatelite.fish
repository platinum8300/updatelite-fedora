# ==============================================================================
# updateLITE · Fedora Edition - Fish Integration
# ==============================================================================
#
# Copia este archivo a ~/.config/fish/conf.d/updatelite.fish
#
# ==============================================================================

# Completado de argumentos para updatelite
complete -c updatelite -s h -l help -d 'Mostrar ayuda'
complete -c updatelite -s v -l version -d 'Mostrar versión'
complete -c updatelite -s c -l check -d 'Verificar sin aplicar cambios (dry-run)'

# Alias útiles
alias ul='updatelite'
alias ulc='updatelite --check'
alias ulh='updatelite --help'
